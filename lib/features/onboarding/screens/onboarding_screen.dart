// lib/features/onboarding/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/services/storage_service.dart';
 import '../../../services/analytics_service.dart';
import '../../../services/storage_service.dart';
import '../../auth/screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'AI-Powered Resume Builder',
      'description': 'Create ATS-optimized resumes tailored to your target role with our advanced AI technology',
      'image': Icons.description_outlined,
      'color': const Color(0xFF3B82F6),
    },
    {
      'title': 'Mock Interview Simulator',
      'description': 'Practice with our AI interviewer and get real-time feedback to improve your interview skills',
      'image': Icons.record_voice_over_outlined,
      'color': const Color(0xFF10B981),
    },
    {
      'title': 'Cover Letter Generator',
      'description': 'Generate personalized cover letters that highlight your skills and experience for any job',
      'image': Icons.mail_outlined,
      'color': const Color(0xFFF59E0B),
    },
    {
      'title': 'Career Analytics',
      'description': 'Track your progress, identify improvement areas, and get personalized recommendations',
      'image': Icons.insights_outlined,
      'color': const Color(0xFF8B5CF6),
    },
  ];

  @override
  void initState() {
    super.initState();
    _logOnboardingStart();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _logOnboardingStart() async {
    final analyticsService = context.read<AnalyticsService>();
    await analyticsService.logScreenView('onboarding');
    await analyticsService.logEvent('onboarding_started');
  }

  void _nextPage() async {
    final analyticsService = context.read<AnalyticsService>();

    if (_currentPage < _onboardingData.length - 1) {
      await analyticsService.logEvent('onboarding_page_viewed', parameters: {
        'page': _currentPage + 1,
        'title': _onboardingData[_currentPage + 1]['title'],
      });

      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await _completeOnboarding();
    }
  }

  void _skipOnboarding() async {
    final analyticsService = context.read<AnalyticsService>();
    await analyticsService.logEvent('onboarding_skipped', parameters: {
      'current_page': _currentPage,
    });
    await _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    final analyticsService = context.read<AnalyticsService>();
    final storageService = context.read<StorageService>();

    // Mark onboarding as completed
    await storageService.setBool('onboarding_completed', true);
    await analyticsService.logEvent('onboarding_completed');

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _skipOnboarding,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon container
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: _onboardingData[index]['color'].withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _onboardingData[index]['image'],
                            size: 60,
                            color: _onboardingData[index]['color'],
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Title
                        Text(
                          _onboardingData[index]['title'],
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        // Description
                        Text(
                          _onboardingData[index]['description'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom navigation
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page indicators
                  Row(
                    children: List.generate(
                      _onboardingData.length,
                          (index) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? const Color(0xFF1E3A8A)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  // Next/Get Started button
                  ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      backgroundColor: const Color(0xFF1E3A8A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentPage < _onboardingData.length - 1 ? 'Next' : 'Get Started',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _currentPage < _onboardingData.length - 1
                              ? Icons.arrow_forward
                              : Icons.check,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}