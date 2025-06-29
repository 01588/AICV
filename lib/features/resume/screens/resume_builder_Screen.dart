import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/step_indicator.dart';
import '../../../core/widgets/ai_suggestion_card.dart';
import '../providers/resume_provider.dart';
import '../models/resume_model.dart';
import '../widgets/resume_form_sections.dart';
import '../widgets/template_selector.dart';
import '../widgets/ai_writing_assistant.dart';
import 'resume_preview_screen.dart';

class ResumeBuilderScreen extends StatefulWidget {
  final ResumeModel? existingResume;

  const ResumeBuilderScreen({
    Key? key,
    this.existingResume,
  }) : super(key: key);

  @override
  State<ResumeBuilderScreen> createState() => _ResumeBuilderScreenState();
}

class _ResumeBuilderScreenState extends State<ResumeBuilderScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _stepAnimationController;
  late Animation<double> _progressAnimation;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  final List<ResumeStep> _steps = [
    ResumeStep(
      title: 'Personal Info',
      icon: Icons.person_outline,
      description: 'Basic information and contact details',
    ),
    ResumeStep(
      title: 'Professional',
      icon: Icons.work_outline,
      description: 'Work experience and achievements',
    ),
    ResumeStep(
      title: 'Skills',
      icon: Icons.star_outline,
      description: 'Technical and soft skills',
    ),
    ResumeStep(
      title: 'Education',
      icon: Icons.school_outline,
      description: 'Academic background and certifications',
    ),
    ResumeStep(
      title: 'Template',
      icon: Icons.design_services_outlined,
      description: 'Choose your resume design',
    ),
    ResumeStep(
      title: 'Review',
      icon: Icons.preview_outlined,
      description: 'Final review and AI optimization',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _stepAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _stepAnimationController,
      curve: Curves.easeInOut,
    ));

    // Initialize with existing resume if provided
    if (widget.existingResume != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ResumeProvider>().loadExistingResume(widget.existingResume!);
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _stepAnimationController.dispose();
    super.dispose();
  }

  void _nextStep() async {
    final resumeProvider = context.read<ResumeProvider>();

    // Validate current step
    if (!_validateCurrentStep()) {
      return;
    }

    // Show AI suggestions before moving to next step
    if (_currentStep < 3) {
      await _showAISuggestions();
    }

    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _updateProgress();

      // Trigger haptic feedback
      HapticFeedback.lightImpact();
    } else {
      // Generate and preview resume
      await _generateResume();
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
      _updateProgress();
      HapticFeedback.lightImpact();
    }
  }

  void _updateProgress() {
    final progress = (_currentStep + 1) / _steps.length;
    _stepAnimationController.animateTo(progress);
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

  Future<void> _showAISuggestions() async {
    final resumeProvider = context.read<ResumeProvider>();
    final suggestions = await resumeProvider.generateAISuggestions(_currentStep);

    if (suggestions.isNotEmpty && mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => AISuggestionsBottomSheet(
          suggestions: suggestions,
          onApplySuggestion: (suggestion) {
            resumeProvider.applySuggestion(suggestion);
            Navigator.pop(context);
          },
        ),
      );
    }
  }

  Future<void> _generateResume() async {
    final resumeProvider = context.read<ResumeProvider>();

    try {
      await resumeProvider.generateResume();

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResumePreviewScreen(
              resume: resumeProvider.currentResume!,
            ),
          ),
        );
      }
    } catch (e) {
      _showErrorDialog('Failed to generate resume. Please try again.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: 'AI Resume Builder',
        showBackButton: true,
        actions: [
          Consumer<ResumeProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: const Icon(Icons.save_outlined),
                onPressed: provider.isLoading ? null : () => provider.saveDraft(),
                tooltip: 'Save Draft',
              );
            },
          ),
        ],
      ),
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Progress Header
              _buildProgressHeader(),

              // Content
              Expanded(
                child: Consumer<ResumeProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('AI is working on your resume...'),
                          ],
                        ),
                      );
                    }

                    return Form(
                      key: _formKey,
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          PersonalInfoFormSection(
                            initialData: provider.personalInfo,
                            onChanged: provider.updatePersonalInfo,
                          ),
                          ProfessionalInfoFormSection(
                            initialData: provider.professionalInfo,
                            onChanged: provider.updateProfessionalInfo,
                          ),
                          SkillsFormSection(
                            initialData: provider.skills,
                            onChanged: provider.updateSkills,
                          ),
                          EducationFormSection(
                            initialData: provider.education,
                            onChanged: provider.updateEducation,
                          ),
                          TemplateSelector(
                            selectedTemplate: provider.selectedTemplate,
                            onTemplateSelected: provider.updateTemplate,
                          ),
                          ResumeReviewSection(
                            resume: provider.buildResumeModel(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Navigation Footer
              _buildNavigationFooter(),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildProgressHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Step indicator
          StepIndicator(
            currentStep: _currentStep,
            totalSteps: _steps.length,
            stepTitles: _steps.map((step) => step.title).toList(),
          ),

          const SizedBox(height: 16),

          // Progress bar
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: _progressAnimation.value,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 6,
              );
            },
          ),

          const SizedBox(height: 12),

          // Current step info
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _steps[_currentStep].icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _steps[_currentStep].title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _steps[_currentStep].description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _previousStep,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),

            if (_currentStep > 0) const SizedBox(width: 16),

            Expanded(
              flex: _currentStep == 0 ? 1 : 1,
              child: Consumer<ResumeProvider>(
                builder: (context, provider, child) {
                  return ElevatedButton.icon(
                    onPressed: provider.isLoading ? null : _nextStep,
                    icon: Icon(
                      _currentStep < _steps.length - 1
                          ? Icons.arrow_forward
                          : Icons.auto_awesome,
                    ),
                    label: Text(
                      _currentStep < _steps.length - 1
                          ? 'Continue'
                          : 'Generate Resume',
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.primaryBlue,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    if (_currentStep >= 4) return null;

    return FloatingActionButton.extended(
      onPressed: () => _showAIAssistant(),
      icon: const Icon(Icons.psychology),
      label: const Text('AI Help'),
      backgroundColor: AppColors.purple,
    );
  }

  void _showAIAssistant() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AIWritingAssistant(),
    );
  }
}

class ResumeStep {
  final String title;
  final IconData icon;
  final String description;

  const ResumeStep({
    required this.title,
    required this.icon,
    required this.description,
  });
}

class AISuggestionsBottomSheet extends StatelessWidget {
  final List<AISuggestion> suggestions;
  final Function(AISuggestion) onApplySuggestion;

  const AISuggestionsBottomSheet({
    Key? key,
    required this.suggestions,
    required this.onApplySuggestion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: AppColors.purple),
                const SizedBox(width: 12),
                const Text(
                  'AI Suggestions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          const Divider(),

          // Suggestions list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                return AISuggestionCard(
                  suggestion: suggestion,
                  onApply: () => onApplySuggestion(suggestion),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ResumeReviewSection extends StatelessWidget {
  final ResumeModel resume;

  const ResumeReviewSection({
    Key? key,
    required this.resume,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ATS Score Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.successGradient,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.verified,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 12),
                const Text(
                  'ATS Compatibility Score',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${resume.atsScore}%',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Excellent! Your resume is highly optimized for ATS systems.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Resume Summary
          _buildSummaryCard(
            'Resume Summary',
            Icons.description,
            [
              'Template: ${resume.template?.name ?? 'Modern'}',
              'Sections: ${resume.sections.length}',
              'Keywords: ${resume.keywords.length}',
              'Estimated reading time: 30 seconds',
            ],
          ),

          const SizedBox(height: 16),

          // Optimization Tips
          _buildSummaryCard(
            'AI Optimization',
            Icons.auto_awesome,
            [
              'Keywords strategically placed for ATS scanning',
              'Action verbs used to highlight achievements',
              'Quantified results included where possible',
              'Industry-specific terminology incorporated',
            ],
          ),

          const SizedBox(height: 16),

          // Quick Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _shareResume(context),
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _downloadResume(context),
                  icon: const Icon(Icons.download),
                  label: const Text('Download'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, IconData icon, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryBlue),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 6, right: 8),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  void _shareResume(BuildContext context) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality coming soon!')),
    );
  }

  void _downloadResume(BuildContext context) {
    // Implement download functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Resume will be downloaded!')),
    );
  }
}