// lib/features/resume/providers/resume_provider.dart
import 'package:flutter/foundation.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/api_service.dart';
import '../../../core/utils/exceptions.dart';
import '../../../services/analytics_service.dart';
import '../../../services/api_service.dart';
import '../../../services/storage_service.dart';
import '../models/template_model.dart';

class ResumeProvider extends ChangeNotifier {
  final AnalyticsService _analyticsService;
  final StorageService _storageService;
  final ApiService _apiService;

  List<Resume> _resumes = [];
  List<ResumeTemplate> _templates = [];
  Resume? _currentResume;
  bool _isLoading = false;
  String? _error;

  // Resume data for building
  Map<String, dynamic> _personalInfo = {};
  Map<String, dynamic> _professionalInfo = {};
  Map<String, dynamic> _education = {};
  List<String> _skills = [];
  String? _selectedTemplate;

  ResumeProvider({
    required AnalyticsService analyticsService,
    required StorageService storageService,
    required ApiService apiService,
  })  : _analyticsService = analyticsService,
        _storageService = storageService,
        _apiService = apiService;

  // Getters
  List<Resume> get resumes => _resumes;
  List<ResumeTemplate> get templates => _templates;
  Resume? get currentResume => _currentResume;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Resume building getters
  Map<String, dynamic> get personalInfo => _personalInfo;
  Map<String, dynamic> get professionalInfo => _professionalInfo;
  Map<String, dynamic> get education => _education;
  List<String> get skills => _skills;
  String? get selectedTemplate => _selectedTemplate;

  // Update methods for resume building
  void updatePersonalInfo(Map<String, dynamic> info) {
    _personalInfo = Map.from(info);
    notifyListeners();
  }

  void updateProfessionalInfo(Map<String, dynamic> info) {
    _professionalInfo = Map.from(info);
    notifyListeners();
  }

  void updateEducation(Map<String, dynamic> info) {
    _education = Map.from(info);
    notifyListeners();
  }

  void updateSkills(List<String> skillsList) {
    _skills = List.from(skillsList);
    notifyListeners();
  }

  void updateTemplate(String templateId) {
    _selectedTemplate = templateId;
    notifyListeners();
  }

  // Validation methods
  bool validatePersonalInfo() {
    return _personalInfo['fullName'] != null &&
        _personalInfo['fullName'].toString().isNotEmpty &&
        _personalInfo['email'] != null &&
        _personalInfo['email'].toString().isNotEmpty;
  }

  bool validateProfessionalInfo() {
    return _professionalInfo['jobTitle'] != null &&
        _professionalInfo['jobTitle'].toString().isNotEmpty;
  }

  bool validateSkills() {
    return _skills.isNotEmpty;
  }

  bool validateEducation() {
    // Education is optional, so always return true
    return true;
  }

  // Generate resume
  Future<Resume?> generateResume() async {
    if (!validatePersonalInfo() || !validateProfessionalInfo() || !validateSkills()) {
      _setError('Please fill in all required fields');
      return null;
    }

    _setLoading(true);
    _setError(null);

    try {
      final resumeData = {
        'personalInfo': _personalInfo,
        'professionalInfo': _professionalInfo,
        'education': _education,
        'skills': _skills,
        'templateId': _selectedTemplate ?? 'modern',
      };

      final response = await _apiService.post('/resumes/generate', body: resumeData);
      final newResume = Resume.fromJson(response['resume']);

      _resumes.add(newResume);
      _currentResume = newResume;

      await _analyticsService.logEvent('resume_generated', parameters: {
        'template_id': _selectedTemplate,
        'skills_count': _skills.length,
      });

      notifyListeners();
      return newResume;
    } catch (e) {
      _setError('Failed to generate resume: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Load user's resumes
  Future<void> loadResumes() async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _apiService.get('/resumes');
      _resumes = (response['resumes'] as List)
          .map((resumeData) => Resume.fromJson(resumeData))
          .toList();

      await _analyticsService.logEvent('resumes_loaded', parameters: {
        'count': _resumes.length,
      });

      notifyListeners();
    } catch (e) {
      _setError('Failed to load resumes: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load available templates
  Future<void> loadTemplates() async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _apiService.get('/templates');
      _templates = (response['templates'] as List)
          .map((templateData) => ResumeTemplate.fromJson(templateData))
          .toList();

      await _analyticsService.logEvent('templates_loaded', parameters: {
        'count': _templates.length,
      });

      notifyListeners();
    } catch (e) {
      _setError('Failed to load templates: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Create new resume
  Future<Resume?> createResume({
    required String name,
    required String templateId,
    Map<String, dynamic>? initialData,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final requestData = {
        'name': name,
        'templateId': templateId,
        if (initialData != null) 'initialData': initialData,
      };

      final response = await _apiService.post('/resumes', body: requestData);
      final newResume = Resume.fromJson(response['resume']);

      _resumes.add(newResume);
      _currentResume = newResume;

      // Save locally
      await _saveResumeLocally(newResume);

      await _analyticsService.logResumeCreated(templateId);
      await _analyticsService.logEvent('resume_created', parameters: {
        'template_id': templateId,
        'resume_id': newResume.id,
      });

      notifyListeners();
      return newResume;
    } catch (e) {
      _setError('Failed to create resume: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Update resume
  Future<void> updateResume(Resume resume) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _apiService.put('/resumes/${resume.id}', body: resume.toJson());
      final updatedResume = Resume.fromJson(response['resume']);

      final index = _resumes.indexWhere((r) => r.id == resume.id);
      if (index != -1) {
        _resumes[index] = updatedResume;
      }

      if (_currentResume?.id == resume.id) {
        _currentResume = updatedResume;
      }

      // Save locally
      await _saveResumeLocally(updatedResume);

      await _analyticsService.logEvent('resume_updated', parameters: {
        'resume_id': resume.id,
        'ats_score': updatedResume.atsScore,
      });

      notifyListeners();
    } catch (e) {
      _setError('Failed to update resume: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Delete resume
  Future<void> deleteResume(String resumeId) async {
    _setLoading(true);
    _setError(null);

    try {
      await _apiService.delete('/resumes/$resumeId');

      _resumes.removeWhere((r) => r.id == resumeId);

      if (_currentResume?.id == resumeId) {
        _currentResume = null;
      }

      // Remove from local storage
      await _storageService.remove('resume_$resumeId');

      await _analyticsService.logEvent('resume_deleted', parameters: {
        'resume_id': resumeId,
      });

      notifyListeners();
    } catch (e) {
      _setError('Failed to delete resume: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Generate AI suggestions
  Future<List<ResumeSuggestion>> generateSuggestions({
    required String resumeId,
    String? jobDescription,
  }) async {
    try {
      final requestData = {
        'resumeId': resumeId,
        if (jobDescription != null) 'jobDescription': jobDescription,
      };

      final response = await _apiService.post('/resumes/$resumeId/suggestions', body: requestData);
      final suggestions = (response['suggestions'] as List)
          .map((suggestionData) => ResumeSuggestion.fromJson(suggestionData))
          .toList();

      await _analyticsService.logEvent('suggestions_generated', parameters: {
        'resume_id': resumeId,
        'suggestion_count': suggestions.length,
        'has_job_description': jobDescription != null,
      });

      return suggestions;
    } catch (e) {
      await _analyticsService.logError('Failed to generate suggestions: $e');
      throw Exception('Failed to generate suggestions: $e');
    }
  }

  // Generate AI suggestions with different method name
  Future<List<ResumeSuggestion>> generateAISuggestions({
    required String resumeId,
    String? jobDescription,
  }) async {
    return generateSuggestions(resumeId: resumeId, jobDescription: jobDescription);
  }

  // Apply suggestion
  Future<void> applySuggestion(String resumeId, ResumeSuggestion suggestion) async {
    try {
      final response = await _apiService.post(
        '/resumes/$resumeId/suggestions/${suggestion.id}/apply',
      );

      final updatedResume = Resume.fromJson(response['resume']);
      final index = _resumes.indexWhere((r) => r.id == resumeId);
      if (index != -1) {
        _resumes[index] = updatedResume;
      }

      if (_currentResume?.id == resumeId) {
        _currentResume = updatedResume;
      }

      await _analyticsService.logEvent('suggestion_applied', parameters: {
        'resume_id': resumeId,
        'suggestion_id': suggestion.id,
        'suggestion_type': suggestion.type.toString().split('.').last,
      });

      notifyListeners();
    } catch (e) {
      await _analyticsService.logError('Failed to apply suggestion: $e');
      throw Exception('Failed to apply suggestion: $e');
    }
  }

  // Build resume model from current data
  Map<String, dynamic> buildResumeModel() {
    return {
      'personalInfo': _personalInfo,
      'professionalInfo': _professionalInfo,
      'education': _education,
      'skills': _skills,
      'templateId': _selectedTemplate ?? 'modern',
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  // Save draft
  Future<void> saveDraft() async {
    try {
      final draftData = buildResumeModel();
      await _storageService.setJson('resume_draft', draftData);

      await _analyticsService.logEvent('resume_draft_saved');
    } catch (e) {
      if (kDebugMode) {
        print('Failed to save draft: $e');
      }
    }
  }

  // Load draft
  Future<void> loadDraft() async {
    try {
      final draftData = _storageService.getJson('resume_draft');
      if (draftData != null) {
        _personalInfo = Map<String, dynamic>.from(draftData['personalInfo'] ?? {});
        _professionalInfo = Map<String, dynamic>.from(draftData['professionalInfo'] ?? {});
        _education = Map<String, dynamic>.from(draftData['education'] ?? {});
        _skills = List<String>.from(draftData['skills'] ?? []);
        _selectedTemplate = draftData['templateId'] as String?;

        notifyListeners();

        await _analyticsService.logEvent('resume_draft_loaded');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load draft: $e');
      }
    }
  }

  // Clear current resume data
  void clearResumeData() {
    _personalInfo.clear();
    _professionalInfo.clear();
    _education.clear();
    _skills.clear();
    _selectedTemplate = null;
    notifyListeners();
  }

  // Set current resume
  void setCurrentResume(Resume? resume) {
    _currentResume = resume;
    notifyListeners();

    if (resume != null) {
      _analyticsService.logEvent('resume_selected', parameters: {
        'resume_id': resume.id,
        'template_id': resume.templateId,
      });
    }
  }

  // Save resume locally
  Future<void> _saveResumeLocally(Resume resume) async {
    try {
      await _storageService.saveResumeData(resume.id, resume.toJson());
    } catch (e) {
      if (kDebugMode) {
        print('Failed to save resume locally: $e');
      }
    }
  }

  // Load resume from local storage
  Future<Resume?> loadResumeFromLocal(String resumeId) async {
    try {
      final resumeData = _storageService.getResumeData(resumeId);
      if (resumeData != null) {
        return Resume.fromJson(resumeData);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load resume from local storage: $e');
      }
    }
    return null;
  }

  // Clear all data
  void clearData() {
    _resumes.clear();
    _templates.clear();
    _currentResume = null;
    _error = null;
    _isLoading = false;
    clearResumeData();
    notifyListeners();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Get resume by ID
  Resume? getResumeById(String id) {
    try {
      return _resumes.firstWhere((resume) => resume.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get template by ID
  ResumeTemplate? getTemplateById(String id) {
    try {
      return _templates.firstWhere((template) => template.id == id);
    } catch (e) {
      return null;
    }
  }

  // Filter templates by category
  List<ResumeTemplate> getTemplatesByCategory(TemplateCategory category) {
    return _templates.where((template) => template.category == category).toList();
  }

  // Get premium templates
  List<ResumeTemplate> getPremiumTemplates() {
    return _templates.where((template) => template.isPremium).toList();
  }

  // Get free templates
  List<ResumeTemplate> getFreeTemplates() {
    return _templates.where((template) => !template.isPremium).toList();
  }
}