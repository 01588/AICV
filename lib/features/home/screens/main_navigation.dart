import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/providers/subscription_provider.dart';
import '../../../core/services/analytics_service.dart';
 import '../../../services/analytics_service.dart';
import '../../home/screens/home_screen.dart';
import '../../resume/screens/resume_list_screen.dart';
import '../../interview/screens/interview_hub_screen.dart';
import '../../cover_letter/screens/cover_letter_hub_screen.dart';
import '../../profile/screens/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;

  const MainNavigation({
    Key? key,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;

  int _currentIndex = 0;
  bool _showFAB = true;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
      color: AppColors.primaryBlue,
    ),
    NavigationItem(
      icon: Icons.description_outlined,
      activeIcon: Icons.description,
      label: 'Resumes',
      color: AppColors.resumeBlue,
    ),
    NavigationItem(
      icon: Icons.record_voice_over_outlined,
      activeIcon: Icons.record_voice_over,
      label: 'Interview',
      color: AppColors.interviewGreen,
    ),
    NavigationItem(
      icon: Icons.mail_outline,
      activeIcon: Icons.mail,
      label: 'Cover Letter',
      color: AppColors.coverLetterOrange,
    ),
    NavigationItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
      color: AppColors.purple,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);

    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fabScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.elasticOut,
    ));

    _fabAnimationController.forward();

    // Track screen view
    AnalyticsService.instance.logEvent('main_navigation_opened', parameters: {
      'initial_index': _currentIndex,
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (_currentIndex == index) {
      // If same tab is tapped, scroll to top or refresh
      _handleSameTabTap(index);
      return;
    }

    setState(() {
      _currentIndex = index;
      _showFAB = _shouldShowFAB(index);
    });

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Track tab change
    AnalyticsService.instance.logEvent('navigation_tab_changed', parameters: {
      'tab_index': index,
      'tab_name': _navigationItems[index].label,
    });

    // Animate FAB
    if (_showFAB) {
      _fabAnimationController.reset();
      _fabAnimationController.forward();
    }
  }

  void _handleSameTabTap(int index) {
    // Handle same tab tap logic for each screen
    switch (index) {
      case 0: // Home
      // Scroll to top or refresh home screen
        break;
      case 1: // Resumes
      // Scroll to top of resume list
        break;
      case 2: // Interview
      // Scroll to top of interview hub
        break;
      case 3: // Cover Letter
      // Scroll to top of cover letter hub
        break;
      case 4: // Profile
      // Scroll to top of profile
        break;
    }
  }

  bool _shouldShowFAB(int index) {
    // Show FAB on home, resumes, interviews, and cover letter tabs
    return index != 4; // Hide on profile tab
  }

  Widget _buildFAB() {
    if (!_showFAB) return const SizedBox.shrink();

    return ScaleTransition(
      scale: _fabScaleAnimation,
      child: FloatingActionButton.extended(
        onPressed: _handleFABPressed,
        backgroundColor: _navigationItems[_currentIndex].color,
        foregroundColor: Colors.white,
        elevation: 8,
        icon: Icon(_getFABIcon()),
        label: Text(_getFABLabel()),
        heroTag: 'main_fab',
      ),
    );
  }

  IconData _getFABIcon() {
    switch (_currentIndex) {
      case 0:
        return Icons.auto_awesome;
      case 1:
        return Icons.add;
      case 2:
        return Icons.play_arrow;
      case 3:
        return Icons.edit;
      default:
        return Icons.add;
    }
  }

  String _getFABLabel() {
    switch (_currentIndex) {
      case 0:
        return 'AI Assistant';
      case 1:
        return 'New Resume';
      case 2:
        return 'Start Interview';
      case 3:
        return 'Write Letter';
      default:
        return 'Create';
    }
  }

  void _handleFABPressed() {
    HapticFeedback.mediumImpact();

    switch (_currentIndex) {
      case 0:
        _showAIAssistant();
        break;
      case 1:
        _createNewResume();
        break;
      case 2:
        _startNewInterview();
        break;
      case 3:
        _createNewCoverLetter();
        break;
    }

    AnalyticsService.instance.logEvent('fab_pressed', parameters: {
      'tab_index': _currentIndex,
      'action': _getFABLabel(),
    });
  }

  void _showAIAssistant() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AIAssistantBottomSheet(),
    );
  }

  void _createNewResume() {
    Navigator.pushNamed(context, '/resume/builder');
  }

  void _startNewInterview() {
    Navigator.pushNamed(context, '/interview/setup');
  }

  void _createNewCoverLetter() {
    Navigator.pushNamed(context, '/cover-letter/builder');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
            _showFAB = _shouldShowFAB(index);
          });
        },
        children: const [
          HomeScreen(),
          ResumeListScreen(),
          InterviewHubScreen(),
          CoverLetterHubScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: AnimatedBottomNavBar(
        currentIndex: _currentIndex,
        items: _navigationItems,
        onTap: _onTabTapped,
      ),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Color color;

  const NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.color,
  });
}

class AIAssistantBottomSheet extends StatefulWidget {
  const AIAssistantBottomSheet({Key? key}) : super(key: key);

  @override
  State<AIAssistantBottomSheet> createState() => _AIAssistantBottomSheetState();
}

class _AIAssistantBottomSheetState extends State<AIAssistantBottomSheet>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  final TextEditingController _queryController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
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
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.purple, AppColors.primaryBlue],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.psychology,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Career Assistant',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Ask me anything about your career',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            const Divider(),

            // Quick Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildQuickActionChip(
                        'Improve my resume',
                        Icons.description,
                        AppColors.resumeBlue,
                      ),
                      _buildQuickActionChip(
                        'Practice interview',
                        Icons.record_voice_over,
                        AppColors.interviewGreen,
                      ),
                      _buildQuickActionChip(
                        'Write cover letter',
                        Icons.mail,
                        AppColors.coverLetterOrange,
                      ),
                      _buildQuickActionChip(
                        'Career advice',
                        Icons.trending_up,
                        AppColors.purple,
                      ),
                      _buildQuickActionChip(
                        'Salary negotiation',
                        Icons.attach_money,
                        AppColors.successGreen,
                      ),
                      _buildQuickActionChip(
                        'Job search tips',
                        Icons.search,
                        AppColors.primaryBlue,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Divider(),

            // Chat Interface
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: [
                        _buildChatMessage(
                          'Hello! I\'m your AI Career Assistant. How can I help you advance your career today?',
                          isBot: true,
                        ),
                      ],
                    ),
                  ),

                  // Input Area
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(24),
                      ),
                    ),
                    child: SafeArea(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _queryController,
                              decoration: InputDecoration(
                                hintText: 'Ask me about your career...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                suffixIcon: _isLoading
                                    ? const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                                    : IconButton(
                                  onPressed: _sendMessage,
                                  icon: const Icon(Icons.send),
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                              maxLines: 3,
                              minLines: 1,
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildQuickActionChip(String label, IconData icon, Color color) {
    return GestureDetector(
      onTap: () => _selectQuickAction(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatMessage(String message, {bool isBot = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isBot) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.purple.withOpacity(0.1),
              child: const Icon(
                Icons.psychology,
                size: 16,
                color: AppColors.purple,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isBot ? Colors.grey[100] : AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: isBot ? Colors.black87 : Colors.white,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (!isBot) ...[
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
              child: const Icon(
                Icons.person,
                size: 16,
                color: AppColors.primaryBlue,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _selectQuickAction(String action) {
    _queryController.text = action;
    _sendMessage();
  }

  void _sendMessage() {
    if (_queryController.text
        .trim()
        .isEmpty || _isLoading) return;

    final message = _queryController.text.trim();
    _queryController.clear();

    setState(() {
      _isLoading = true;
    });

    // Simulate AI response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Show AI response
        _showAIResponse(message);
      }
    });

    AnalyticsService.instance.logEvent('ai_assistant_query', parameters: {
      'query_type': 'chat',
      'message_length': message.length,
    });
  }

  void _showAIResponse(String userMessage) {
    // This would integrate with your AI service
    // For demo purposes, showing a generic response
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('AI response to: "$userMessage"'),
        backgroundColor: AppColors.successGreen,
      ),
    );
  }
}