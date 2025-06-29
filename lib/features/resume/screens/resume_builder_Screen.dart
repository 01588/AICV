// lib/features/resume/screens/resume_builder_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_app_bar.dart';

import '../providers/resume_provider.dart';
import '../widgets/resume_form_sections.dart';

import 'resume_preview_screen.dart';

class ResumeBuilderScreen extends StatefulWidget {
  const ResumeBuilderScreen({Key? key}) : super(key: key);

  @override
  State<ResumeBuilderScreen> createState() => _ResumeBuilderScreenState();
}

class _ResumeBuilderScreenState extends State<ResumeBuilderScreen> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 5;

  // Step titles
  final List<String> _stepTitles = [
    'Personal Info',
    'Professional Info',
    'Skills',
    'Education',
    'Template',
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    final resumeProvider = context.read<ResumeProvider>();
    resumeProvider.loadTemplates();
    resumeProvider.loadDraft();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      if (_validateCurrentStep()) {
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _saveDraft();
      }
    } else {
      _generateResume();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentStep() {
    final resumeProvider = context.read<ResumeProvider>();

    switch (_currentStep) {
      case 0:
        return resumeProvider.validatePersonalInfo();
      case 1:
        return resumeProvider.validateProfessionalInfo();
      case 2:
        return resumeProvider.validateSkills();
      case 3:
        return resumeProvider.validateEducation();
      case 4:
        return resumeProvider.selectedTemplate != null;
      default:
        return true;
    }
  }

  void _saveDraft() {
    final resumeProvider = context.read<ResumeProvider>();
    resumeProvider.saveDraft();
  }

  void _generateResume() async {
    final resumeProvider = context.read<ResumeProvider>();

    if (_formKey.currentState?.validate() ?? false) {
      final resume = await resumeProvider.generateResume();

      if (resume != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResumePreviewScreen(
              resumeData: resumeProvider.buildResumeModel(),
              templateId: resumeProvider.selectedTemplate ?? 'modern',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Resume Builder',
        actions: [
          TextButton(
            onPressed: _saveDraft,
            child: const Text('Save Draft'),
          ),
        ],
      ),
      body: Consumer<ResumeProvider>(
        builder: (context, resumeProvider, child) {
          if (resumeProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Form(
            key: _formKey,
            child: Column(
              children: [
                // Progress indicator
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      StepIndicator(
                        currentStep: _currentStep,
                        totalSteps: _totalSteps,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _stepTitles[_currentStep],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Form content
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildPersonalInfoStep(resumeProvider),
                      _buildProfessionalInfoStep(resumeProvider),
                      _buildSkillsStep(resumeProvider),
                      _buildEducationStep(resumeProvider),
                      _buildTemplateStep(resumeProvider),
                    ],
                  ),
                ),

                // Navigation buttons
                _buildNavigationButtons(resumeProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPersonalInfoStep(ResumeProvider resumeProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: PersonalInfoFormSection(
        data: resumeProvider.personalInfo,
        onChanged: (key, value) {
          final updatedInfo = Map<String, dynamic>.from(resumeProvider.personalInfo);
          updatedInfo[key] = value;
          resumeProvider.updatePersonalInfo(updatedInfo);
        },
      ),
    );
  }

  Widget _buildProfessionalInfoStep(ResumeProvider resumeProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ProfessionalInfoFormSection(
            data: resumeProvider.professionalInfo,
            onChanged: (key, value) {
              final updatedInfo = Map<String, dynamic>.from(resumeProvider.professionalInfo);
              updatedInfo[key] = value;
              resumeProvider.updateProfessionalInfo(updatedInfo);
            },
          ),
          const SizedBox(height: 24),
          AIWritingAssistant(
            onSuggestionApplied: (suggestion) {
              final updatedInfo = Map<String, dynamic>.from(resumeProvider.professionalInfo);
              updatedInfo['aiSuggestion'] = suggestion;
              resumeProvider.updateProfessionalInfo(updatedInfo);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsStep(ResumeProvider resumeProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: SkillsFormSection(
        data: {'skills': resumeProvider.skills},
        onChanged: (key, value) {
          if (key == 'skills' && value is List<String>) {
            resumeProvider.updateSkills(value);
          }
        },
      ),
    );
  }

  Widget _buildEducationStep(ResumeProvider resumeProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: EducationFormSection(
        data: resumeProvider.education,
        onChanged: (key, value) {
          final updatedInfo = Map<String, dynamic>.from(resumeProvider.education);
          updatedInfo[key] = value;
          resumeProvider.updateEducation(updatedInfo);
        },
      ),
    );
  }

  Widget _buildTemplateStep(ResumeProvider resumeProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: TemplateSelector(
        templates: resumeProvider.templates.map((template) => {
          'id': template.id,
          'name': template.name,
          'isPremium': template.isPremium,
          'category': template.category.toString().split('.').last,
        }).toList(),
        selectedTemplateId: resumeProvider.selectedTemplate,
        onTemplateSelected: (templateId) {
          resumeProvider.updateTemplate(templateId);
        },
      ),
    );
  }

  Widget _buildNavigationButtons(ResumeProvider resumeProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                child: const Text('Previous'),
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            flex: _currentStep > 0 ? 1 : 2,
            child: ElevatedButton(
              onPressed: resumeProvider.isLoading ? null : _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: resumeProvider.isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : Text(
                _currentStep < _totalSteps - 1 ? 'Next' : 'Generate Resume',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// AI Suggestions Bottom Sheet
class AISuggestionsBottomSheet extends StatelessWidget {
  final List<Map<String, dynamic>> suggestions;
  final Function(Map<String, dynamic>) onApplySuggestion;

  const AISuggestionsBottomSheet({
    Key? key,
    required this.suggestions,
    required this.onApplySuggestion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AI Suggestions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...suggestions.map((suggestion) => AISuggestionCard(
            title: suggestion['title'] ?? 'Suggestion',
            description: suggestion['description'] ?? '',
            suggestion: suggestion['content'] ?? '',
            confidence: (suggestion['confidence'] ?? 0.8) as double,
            onApply: () {
              onApplySuggestion(suggestion);
              Navigator.pop(context);
            },
            onDismiss: () {
              Navigator.pop(context);
            },
          )).toList(),
        ],
      ),
    );
  }
}