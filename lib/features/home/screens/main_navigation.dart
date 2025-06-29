import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/analytics_service.dart';
 import '../../../core/widgets/custom_app_bar.dart';
import '../../../services/analytics_service.dart';
import 'home_screen.dart';
import '../../resume/screens/resume_list_screen.dart';
import '../../interview/screens/interview_hub_screen.dart';
import '../../cover_letter/screens/cover_letter_hub_screen.dart';
import '../../profile/screens/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const ResumeListScreen(),
    const InterviewHubScreen(),
    const CoverLetterHubScreen(),
    const ProfileScreen(),
  ];

  final List<BottomNavItem> _navItems = [
    const BottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
    ),
    const BottomNavItem(
      icon: Icons.description_outlined,
      activeIcon: Icons.description,
      label: 'Resume',
    ),
    const BottomNavItem(
      icon: Icons.record_voice_over_outlined,
      activeIcon: Icons.record_voice_over,
      label: 'Interview',
    ),
    const BottomNavItem(
      icon: Icons.mail_outline,
      activeIcon: Icons.mail,
      label: 'Cover',
    ),
    const BottomNavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _logScreenView();
  }

  void _logScreenView() async {
    final analyticsService = context.read<AnalyticsService>();
    await analyticsService.logScreenView('main_navigation');
  }

  void _onTabTapped(int index) {
    if (_currentIndex != index) {
      final oldIndex = _currentIndex;
      setState(() {
        _currentIndex = index;
      });

      final analyticsService = context.read<AnalyticsService>();
      final tabName = _getTabName(index);

      analyticsService.logNavigation(_getTabName(oldIndex), tabName);
      analyticsService.logScreenView(tabName);
    }
  }

  String _getTabName(int index) {
    switch (index) {
      case 0:
        return 'home';
      case 1:
        return 'resume';
      case 2:
        return 'interview';
      case 3:
        return 'cover_letter';
      case 4:
        return 'profile';
      default:
        return 'unknown';
    }
  }

  // Fixed method name to match the widget
  Widget _buildAnimatedBottomNavBar() {
    return AnimatedBottomNavBar(
      currentIndex: _currentIndex,
      onTap: _onTabTapped,
      items: _navItems,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey[600],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildAnimatedBottomNavBar(),
    );
  }
}