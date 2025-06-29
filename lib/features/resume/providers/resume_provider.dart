import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/services/ai_service.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/services/storage_service.dart';
import '../models/resume_model.dart';
import '../models/template_model.dart';

class ResumeProvider extends ChangeNotifier {
  final AIService _aiService = AIService.instance;
  final StorageService _storageService = StorageService.instance;

  // Current resume being built
  ResumeModel? _currentResume;

  // Form data
  PersonalInfo _personalInfo = PersonalInfo.empty();
  ProfessionalInfo _professionalInfo = ProfessionalInfo.empty();
  List<Skill> _skills = [];
  List<Education> _education = [];
  ResumeTemplate? _selectedTemplate;

  // State
  bool _isLoading = false;
  String? _errorMessage;
  List<ResumeModel> _savedResumes = [];
  List<AISuggestion> _currentSuggestions = [];

  // Getters
  ResumeModel? get currentResume => _currentResume;
  PersonalInfo get personalInfo => _personalInfo;
  ProfessionalInfo get professionalInfo => _professionalInfo;
  List<Skill> get skills => _skills;
  List<Education> get education => _education;
  ResumeTemplate? get selectedTemplate => _selectedTemplate;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<ResumeModel> get savedResumes => _savedResumes;
  List<AISuggestion> get currentSuggestions => _currentSuggestions;

  ResumeProvider() {
    _loadSavedResumes();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Load existing resume for editing
  void loadExistingResume(ResumeModel resume) {
    _currentResume = resume;
    _personalInfo = resume.personalInfo;
    _professionalInfo = resume.professionalInfo;
    _skills = List.from(resume.skills);
    _education = List.from(resume.education);
    _selectedTemplate = resume.template;
    notifyListeners();
  }

  // Update methods
  void updatePersonalInfo(PersonalInfo info) {
    _personalInfo = info;
    notifyListeners();
  }

  void updateProfessionalInfo(ProfessionalInfo info) {
    _professionalInfo = info;
    notifyListeners();
  }

  void updateSkills(List<Skill> skills) {
    _skills = skills;
    notifyListeners();
  }

  void updateEducation(List<Education> education) {
    _education = education;
    notifyListeners();
  }

  void updateTemplate(ResumeTemplate template) {
    _selectedTemplate = template;
    notifyListeners();
  }

  // Validation methods
  bool validatePersonalInfo() {
    return _personalInfo.fullName.isNotEmpty &&
        _personalInfo.email.isNotEmpty &&
        _personalInfo.phone.isNotEmpty;
  }

  bool validateProfessionalInfo() {
    return _professionalInfo.summary.isNotEmpty &&
        _professionalInfo.workExperience.isNotEmpty;
  }

  bool validateSkills() {
    return _skills.isNotEmpty;
  }

  bool validateEducation() {
    return _education.isNotEmpty;
  }

  // AI Suggestions
  Future<List<AISuggestion>> generateAISuggestions(int stepIndex) async {
    try {
      _setLoading(true);

      List<AISuggestion> suggestions = [];

      switch (stepIndex) {
        case 0: // Personal Info
          suggestions = await _aiService.generatePersonalInfoSuggestions(_personalInfo);
          break;
        case 1: // Professional
          suggestions = await _aiService.generateProfessionalSuggestions(_professionalInfo);
          break;
        case 2: // Skills
          suggestions = await _aiService.generateSkillsSuggestions(_skills, _professionalInfo);
          break;
        case 3: // Education
          suggestions = await _aiService.generateEducationSuggestions(_education);
          break;
      }

      _currentSuggestions = suggestions;
      _setLoading(false);
      return suggestions;
    } catch (e) {
      _setError('Failed to generate AI suggestions: $e');
      _setLoading(false);
      return [];
    }
  }

  void applySuggestion(AISuggestion suggestion) {
    switch (suggestion.type) {
      case SuggestionType.summary:
        _professionalInfo = _professionalInfo.copyWith(summary: suggestion.content);
        break;
      case SuggestionType.skill:
        _skills.add(Skill(
          id: const Uuid().v4(),
          name: suggestion.content,
          level: SkillLevel.intermediate,
          category: SkillCategory.technical,
        ));
        break;
      case SuggestionType.achievement:
      // Add to work experience achievements
        if (_professionalInfo.workExperience.isNotEmpty) {
          final lastJob = _professionalInfo.workExperience.last;
          final updatedAchievements = List<String>.from(lastJob.achievements)
            ..add(suggestion.content);
          final updatedJob = lastJob.copyWith(achievements: updatedAchievements);
          final updatedExperience = List<WorkExperience>.from(_professionalInfo.workExperience)
            ..removeLast()
            ..add(updatedJob);
          _professionalInfo = _professionalInfo.copyWith(workExperience: updatedExperience);
        }
        break;
      case SuggestionType.education:
      // Apply education suggestions
        break;
    }
    notifyListeners();

    AnalyticsService.instance.logEvent('ai_suggestion_applied', parameters: {
      'suggestion_type': suggestion.type.toString(),
    });
  }

  // Resume Generation
  Future<void> generateResume() async {
    try {
      _setLoading(true);
      _setError(null);

      if (_selectedTemplate == null) {
        throw Exception('No template selected');
      }

      // Build resume model
      final resume = buildResumeModel();

      // Generate AI-enhanced content
      final enhancedResume = await _aiService.enhanceResume(resume);

      // Calculate ATS score
      final atsScore = await _aiService.calculateATSScore(enhancedResume);

      _currentResume = enhancedResume.copyWith(atsScore: atsScore);

      // Save to storage
      await _saveResume(_currentResume!);

      AnalyticsService.instance.logEvent('resume_generated', parameters: {
        'template': _selectedTemplate!.name,
        'ats_score': atsScore,
      });

      _setLoading(false);
    } catch (e) {
      _setError('Failed to generate resume: $e');
      _setLoading(false);
      rethrow;
    }
  }

  ResumeModel buildResumeModel() {
    return ResumeModel(
      id: _currentResume?.id ?? const Uuid().v4(),
      personalInfo: _personalInfo,
      professionalInfo: _professionalInfo,
      skills: _skills,
      education: _education,
      template: _selectedTemplate!,
      createdAt: _currentResume?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      sections: _buildSections(),
      keywords: _extractKeywords(),
      atsScore: 0, // Will be calculated during generation
    );
  }

  List<ResumeSection> _buildSections() {
    final sections = <ResumeSection>[];

    // Header section
    sections.add(ResumeSection(
      id: 'header',
      type: SectionType.header,
      title: 'Header',
      content: _personalInfo.toJson(),
      order: 0,
    ));

    // Summary section
    if (_professionalInfo.summary.isNotEmpty) {
      sections.add(ResumeSection(
        id: 'summary',
        type: SectionType.summary,
        title: 'Professional Summary',
        content: {'summary': _professionalInfo.summary},
        order: 1,
      ));
    }

    // Experience section
    if (_professionalInfo.workExperience.isNotEmpty) {
      sections.add(ResumeSection(
        id: 'experience',
        type: SectionType.experience,
        title: 'Work Experience',
        content: {
          'experiences': _professionalInfo.workExperience.map((e) => e.toJson()).toList(),
        },
        order: 2,
      ));
    }

    // Skills section
    if (_skills.isNotEmpty) {
      sections.add(ResumeSection(
        id: 'skills',
        type: SectionType.skills,
        title: 'Skills',
        content: {
          'skills': _skills.map((s) => s.toJson()).toList(),
        },
        order: 3,
      ));
    }

    // Education section
    if (_education.isNotEmpty) {
      sections.add(ResumeSection(
        id: 'education',
        type: SectionType.education,
        title: 'Education',
        content: {
          'education': _education.map((e) => e.toJson()).toList(),
        },
        order: 4,
      ));
    }

    return sections;
  }

  List<String> _extractKeywords() {
    final keywords = <String>[];

    // Extract from skills
    keywords.addAll(_skills.map((skill) => skill.name));

    // Extract from work experience
    for (final experience in _professionalInfo.workExperience) {
      keywords.addAll(experience.responsibilities);
      keywords.addAll(experience.achievements);
    }

    // Extract from summary
    final summaryWords = _professionalInfo.summary
        .split(RegExp(r'[^\w]+'))
        .where((word) => word.length > 3)
        .toList();
    keywords.addAll(summaryWords);

    return keywords.toSet().toList(); // Remove duplicates
  }

  // Save and Load
  Future<void> saveDraft() async {
    try {
      final resume = buildResumeModel();
      await _saveResume(resume);

      AnalyticsService.instance.logEvent('resume_draft_saved');
    } catch (e) {
      _setError('Failed to save draft: $e');
    }
  }

  Future<void> _saveResume(ResumeModel resume) async {
    await _storageService.saveResume(resume);
    await _loadSavedResumes(); // Refresh the list
  }

  Future<void> _loadSavedResumes() async {
    try {
      _savedResumes = await _storageService.getSavedResumes();
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to load saved resumes: $e');
    }
  }

  Future<void> deleteResume(String resumeId) async {
    try {
      await _storageService.deleteResume(resumeId);
      _savedResumes.removeWhere((resume) => resume.id == resumeId);
      notifyListeners();

      AnalyticsService.instance.logEvent('resume_deleted');
    } catch (e) {
      _setError('Failed to delete resume: $e');
    }
  }

  Future<void> duplicateResume(ResumeModel resume) async {
    try {
      final duplicated = resume.copyWith(
        id: const Uuid().v4(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _saveResume(duplicated);

      AnalyticsService.instance.logEvent('resume_duplicated');
    } catch (e) {
      _setError('Failed to duplicate resume: $e');
    }
  }

  // Export functionality
  Future<String> exportToPDF(ResumeModel resume) async {
    try {
      _setLoading(true);

      final pdfPath = await _storageService.exportResumeToPDF(resume);

      AnalyticsService.instance.logEvent('resume_exported_pdf');

      _setLoading(false);
      return pdfPath;
    } catch (e) {
      _setError('Failed to export PDF: $e');
      _setLoading(false);
      rethrow;
    }
  }

  Future<String> exportToWord(ResumeModel resume) async {
    try {
      _setLoading(true);

      final docPath = await _storageService.exportResumeToWord(resume);

      AnalyticsService.instance.logEvent('resume_exported_word');

      _setLoading(false);
      return docPath;
    } catch (e) {
      _setError('Failed to export Word document: $e');
      _setLoading(false);
      rethrow;
    }
  }

  // Clear form data
  void clearForm() {
    _personalInfo = PersonalInfo.empty();
    _professionalInfo = ProfessionalInfo.empty();
    _skills.clear();
    _education.clear();
    _selectedTemplate = null;
    _currentResume = null;
    _currentSuggestions.clear();
    notifyListeners();
  }

  void clearError() {
    _setError(null);
  }

  // Get template suggestions based on industry/role
  Future<List<ResumeTemplate>> getTemplateRecommendations() async {
    try {
      final industry = _professionalInfo.industry;
      final jobTitle = _professionalInfo.targetJobTitle;

      return await _aiService.getTemplateRecommendations(
        industry: industry,
        jobTitle: jobTitle,
      );
    } catch (e) {
      debugPrint('Failed to get template recommendations: $e');
      return [];
    }
  }

  // Analytics and insights
  Future<ResumeAnalytics> getResumeAnalytics(ResumeModel resume) async {
    try {
      return await _aiService.analyzeResume(resume);
    } catch (e) {
      debugPrint('Failed to get resume analytics: $e');
      return ResumeAnalytics.empty();
    }
  }

  // Smart suggestions based on job posting
  Future<List<AISuggestion>> analyzeJobPosting(String jobPosting) async {
    try {
      _setLoading(true);

      final suggestions = await _aiService.analyzeJobPostingForResume(
        jobPosting,
        buildResumeModel(),
      );

      _setLoading(false);
      return suggestions;
    } catch (e) {
      _setError('Failed to analyze job posting: $e');
      _setLoading(false);
      return [];
    }
  }

  @override
  void dispose() {
    // Clean up resources
    super.dispose();
  }
}