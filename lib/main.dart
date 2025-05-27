import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const AICareerAssistantApp());
}

class AICareerAssistantApp extends StatelessWidget {
  const AICareerAssistantApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Career Assistant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          brightness: Brightness.light,
        ),
        fontFamily: 'Poppins',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Poppins',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A8A),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.work_outline,
                        size: 80,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'AI Career Assistant',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Your AI-powered career companion',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Version 1.0',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white38,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text('Skip'),
              ),
            ),
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
                        Text(
                          _onboardingData[index]['title'],
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
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
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dots indicator
                  Row(
                    children: List.generate(
                      _onboardingData.length,
                          (index) => Container(
                        margin: const EdgeInsets.only(right: 6),
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
                    onPressed: () {
                      if (_currentPage < _onboardingData.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      backgroundColor: const Color(0xFF1E3A8A),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      _currentPage < _onboardingData.length - 1 ? 'Next' : 'Get Started',
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

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  void _handleLogin() async {
    // Validate inputs
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both email and password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate login process
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainNavigation()),
      );
    }
  }

  void _handleSocialLogin(String provider) async {
    setState(() => _isLoading = true);

    // Simulate social login process
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainNavigation()),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
        child: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(24.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const SizedBox(height: 40),
    Center(
    child: Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
    color: const Color(0xFF1E3A8A),
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
    BoxShadow(
    color: const Color(0xFF1E3A8A).withOpacity(0.3),
    blurRadius: 12,
    offset: const Offset(0, 4),
    ),
    ],
    ),
    child: const Icon(
    Icons.work_outline,
    size: 60,
    color: Colors.white,
    ),
    ),
    ),
      const SizedBox(height: 30),
      const Text(
        'Welcome Back!',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        'Sign in to continue your career journey',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[600],
        ),
      ),
      const SizedBox(height: 40),

      // Email Field
      TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.email_outlined),
        ),
      ),
      const SizedBox(height: 16),

      // Password Field
      TextField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          labelText: 'Password',
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
      ),

      // Remember Me & Forgot Password
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
              ),
              const Text('Remember me'),
            ],
          ),
          TextButton(
            onPressed: () {
              // Navigate to forgot password screen
            },
            child: const Text('Forgot Password?'),
          ),
        ],
      ),
      const SizedBox(height: 24),

      // Sign In Button
      SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handleLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E3A8A),
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
              : const Text(
            'Sign In',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
      const SizedBox(height: 24),

      // OR Divider
      Row(
        children: [
          Expanded(child: Divider(color: Colors.grey[300])),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'OR',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey[300])),
        ],
      ),
      const SizedBox(height: 24),

      // Social Login Buttons
      Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _handleSocialLogin('Google'),
              icon: const Icon(Icons.g_mobiledata, size: 24),
              label: const Text('Google'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _handleSocialLogin('LinkedIn'),
              icon: const Icon(Icons.link, size: 20),
              label: const Text('LinkedIn'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),

      // Apple Sign In
      SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _handleSocialLogin('Apple'),
          icon: const Icon(Icons.apple, size: 20),
          label: const Text('Sign in with Apple'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),

      const SizedBox(height: 40),

      // Sign Up Link
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account? ",
            style: TextStyle(color: Colors.grey[600]),
          ),
          TextButton(
            onPressed: () {
              // Navigate to sign up page
            },
            child: const Text(
              'Sign Up',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
            ),
          ),
        ],
      ),
    ],
    ),
        ),
        ),
        ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ResumeBuilderPage(),
    const InterviewPage(),
    const ProfilePage(),
    const CoverLetterPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF1E3A8A),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined),
              activeIcon: Icon(Icons.description),
              label: 'Resume',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.record_voice_over_outlined),
              activeIcon: Icon(Icons.record_voice_over),
              label: 'Interview',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mail_outline),
              activeIcon: Icon(Icons.mail),
              label: 'Cover',
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    // App Bar
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Text(
    'AI Career Assistant',
    style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    ),
    ),
    Text(
    'Welcome back, John!',
    style: TextStyle(
    fontSize: 14,
    color: Colors.grey[600],
    ),
    ),
    ],
    ),
    Row(
    children: [
    IconButton(
    icon: const Icon(Icons.search),
    onPressed: () {},
    ),
    Stack(
    children: [
    IconButton(
    icon: const Icon(Icons.notifications_outlined),
    onPressed: () {},
    ),
    Positioned(
    right: 8,
    top: 8,
    child: Container(
    width: 10,
    height: 10,
    decoration: const BoxDecoration(
    color: Colors.red,
    shape: BoxShape.circle,
    ),
    ),
    ),
    ],
    ),
    ],
    ),
    ],
    ),
    const SizedBox(height: 24),

    // Premium Banner
    Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
    gradient: const LinearGradient(
    colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
    BoxShadow(
    color: const Color(0xFF3B82F6).withOpacity(0.3),
    blurRadius: 10,
    offset: const Offset(0, 4),
    ),
    ],
    ),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Row(
    children: [
    Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.2),
    borderRadius: BorderRadius.circular(8),
    ),
    child: const Icon(
    Icons.workspace_premium,
    color: Colors.white,
    size: 24,
    ),
    ),
    const SizedBox(width: 12),
    const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'Upgrade to Premium',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),
    ),
    Text(
    'Unlock unlimited features',
    style: TextStyle(
    fontSize: 14,
    color: Colors.white70,
    ),
    ),
    ],
    ),
    ],
    ),
    const SizedBox(height: 16),
    Row(
    children: [
    Expanded(
    child: Row(
    children: [
    Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    ),
    child: const Icon(
    Icons.check,
    color: Color(0xFF1E3A8A),
    size: 12,
    ),
    ),
    const SizedBox(width: 8),
    const Expanded(
    child: Text(
    'Unlimited Resumes',
    style: TextStyle(
    fontSize: 12,
    color: Colors.white,
    ),
    ),
    ),
    ],
    ),
    ),
    Expanded(
    child: Row(
    children: [
    Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    ),
    child: const Icon(
    Icons.check,
    color: Color(0xFF1E3A8A),
    size: 12,
    ),
    ),
    const SizedBox(width: 8),
    const Expanded(
    child: Text(
    'Advanced Analytics',
    style: TextStyle(
    fontSize: 12,
    color: Colors.white,
    ),
    ),
    ),
    ],
    ),
    ),
    ],
    ),
    const SizedBox(height: 16),
    SizedBox(
    width: double.infinity,
    child: ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: const Color(0xFF1E3A8A),
    padding: const EdgeInsets.symmetric(vertical: 12),
    ),
    child: const Text(
    'Upgrade Now',
    style: TextStyle(fontWeight: FontWeight.bold),
    ),
    ),
    ),
    ],
    ),
    ),
    const SizedBox(height: 24),

    // Usage Stats
    Row(
    children: [
    Expanded(
    child: _buildStatCard(
    'Resumes Created',
    '3/5',
    Icons.description_outlined,
    Colors.blue,
    0.6,
    ),
    ),
    const SizedBox(width: 16),
    Expanded(
    child: _buildStatCard(
    'Interviews Done',
    '12/15',
    Icons.record_voice_over_outlined,
    Colors.green,
    0.8,
    ),
    ),
    ],
    ),
    const SizedBox(height: 24),

    // Quick Actions
    const Text(
    'Quick Actions',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),
    ),
    const SizedBox(height: 16),
    GridView.count(
    shrinkWrap: true,
    // physics: const N
       physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildQuickActionCard(
          context,
          'Create Resume',
          Icons.description_outlined,
          Colors.blue,
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ResumeBuilderPage()),
          ),
        ),
        _buildQuickActionCard(
          context,
          'Mock Interview',
          Icons.record_voice_over_outlined,
          Colors.green,
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InterviewPage()),
          ),
        ),
        _buildQuickActionCard(
          context,
          'Cover Letter',
          Icons.mail_outlined,
          Colors.orange,
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CoverLetterPage()),
          ),
        ),
        _buildQuickActionCard(
          context,
          'Career Analytics',
          Icons.insights_outlined,
          Colors.purple,
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>   Container()),
          ),
        ),
      ],
    ),
      const SizedBox(height: 24),

      // Recent Activity
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('View All'),
          ),
        ],
      ),
      const SizedBox(height: 16),
      _buildActivityCard(
        'Software Engineer Resume',
        'Created 2 days ago',
        Icons.description,
        Colors.blue,
      ),
      const SizedBox(height: 12),
      _buildActivityCard(
        'Technical Interview Practice',
        'Completed yesterday',
        Icons.record_voice_over,
        Colors.green,
      ),
      const SizedBox(height: 12),
      _buildActivityCard(
        'Cover Letter - Product Manager',
        'Created 3 days ago',
        Icons.mail,
        Colors.orange,
      ),

      const SizedBox(height: 24),

      // Job Recommendations
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Job Recommendations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('View All'),
          ),
        ],
      ),
      const SizedBox(height: 16),
      _buildJobCard(
        'Senior Software Engineer',
        'Google',
        'Mountain View, CA',
        '\$150K - \$180K',
        'https://logo.clearbit.com/google.com',
      ),
      const SizedBox(height: 12),
      _buildJobCard(
        'Product Manager',
        'Microsoft',
        'Redmond, WA',
        '\$130K - \$160K',
        'https://logo.clearbit.com/microsoft.com',
      ),
      const SizedBox(height: 24),
    ],
    ),
        ),
        ),
    );
  }

  Widget _buildStatCard(
      String title,
      String value,
      IconData icon,
      Color color,
      double progress,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
      BuildContext context,
      String title,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(
      String title,
      String subtitle,
      IconData icon,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(
      String title,
      String company,
      String location,
      String salary,
      String logoUrl,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                company.substring(0, 1),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      company,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      location,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  salary,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.bookmark_border,
              color: Color(0xFF1E3A8A),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class ResumeBuilderPage extends StatefulWidget {
  const ResumeBuilderPage({Key? key}) : super(key: key);

  @override
  State<ResumeBuilderPage> createState() => _ResumeBuilderPageState();
}

class _ResumeBuilderPageState extends State<ResumeBuilderPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _experienceController = TextEditingController();
  final _skillsController = TextEditingController();
  final _educationController = TextEditingController();
  final _summaryController = TextEditingController();

  bool _isGenerating = false;
  String _selectedTemplate = 'Modern';
  int _currentStep = 0;

  final List<String> _templates = ['Modern', 'Classic', 'Creative', 'Minimal', 'Professional'];
  final List<String> _industries = ['Technology', 'Finance', 'Healthcare', 'Marketing', 'Education'];
  String _selectedIndustry = 'Technology';

  void _generateResume() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isGenerating = true);

      // Simulate AI generation
      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        setState(() => _isGenerating = false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResumePreviewPage(
              name: _nameController.text,
              email: _emailController.text,
              phone: _phoneController.text,
              jobTitle: _jobTitleController.text,
              experience: _experienceController.text,
              skills: _skillsController.text,
              education: _educationController.text,
              summary: _summaryController.text,
              template: _selectedTemplate,
              industry: _selectedIndustry,
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _jobTitleController.dispose();
    _experienceController.dispose();
    _skillsController.dispose();
    _educationController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('AI Resume Builder'),
    backgroundColor: Colors.transparent,
    elevation: 0,
    ),
    body: SafeArea(
    child: Stepper(
    type: StepperType.horizontal,
    currentStep: _currentStep,
    onStepContinue: () {
    if (_currentStep < 3) {
    setState(() {
    _currentStep += 1;
    });
    } else {
    _generateResume();
    }
    },
    onStepCancel: () {
    if (_currentStep > 0) {
    setState(() {
    _currentStep -= 1;
    });
    }
    },
    controlsBuilder: (context, details) {
    return Padding(
    padding: const EdgeInsets.only(top: 20.0),
    child: Row(
    children: [
    Expanded(
    child: ElevatedButton(
    onPressed: details.onStepContinue,
    style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF1E3A8A),
    foregroundColor: Colors.white,
    ),
    child: Text(
    _currentStep < 3 ? 'Continue' : 'Generate Resume',
    ),
    ),
    ),
    if (_currentStep > 0) ...[
    const SizedBox(width: 12),                    Expanded(
        child: OutlinedButton(
          onPressed: details.onStepCancel,
          child: const Text('Back'),
        ),
      ),
    ],
    ],
    ),
    );
    },
      steps: [
        Step(
          title: const Text('Personal'),
          content: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 32,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'AI-Powered Resume Builder',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Create ATS-optimized resumes tailored to your target role',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                ),
              ],
            ),
          ),
          isActive: _currentStep >= 0,
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: const Text('Professional'),
          content: Column(
            children: [
              TextFormField(
                controller: _jobTitleController,
                decoration: const InputDecoration(
                  labelText: 'Target Job Title *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your target job title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedIndustry,
                decoration: const InputDecoration(
                  labelText: 'Industry',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
                items: _industries.map((String industry) {
                  return DropdownMenuItem<String>(
                    value: industry,
                    child: Text(industry),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() => _selectedIndustry = newValue);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _experienceController,
                decoration: const InputDecoration(
                  labelText: 'Work Experience',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.timeline_outlined),
                  hintText: 'Briefly describe your work experience...',
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _educationController,
                decoration: const InputDecoration(
                  labelText: 'Education',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school_outlined),
                  hintText: 'Your educational background...',
                ),
                maxLines: 3,
              ),
            ],
          ),
          isActive: _currentStep >= 1,
          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: const Text('Skills'),
          content: Column(
            children: [
              TextFormField(
                controller: _skillsController,
                decoration: const InputDecoration(
                  labelText: 'Key Skills *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.star_outline),
                  hintText: 'e.g., Python, JavaScript, Project Management...',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your key skills';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _summaryController,
                decoration: const InputDecoration(
                  labelText: 'Professional Summary',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.summarize_outlined),
                  hintText: 'A brief summary of your professional background...',
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: Colors.blue[700]),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Tip: Include skills that match your target job description to improve ATS ranking.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          isActive: _currentStep >= 2,
          state: _currentStep > 2 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: const Text('Template'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose a Template',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _templates.length,
                  itemBuilder: (context, index) {
                    final template = _templates[index];
                    final isSelected = template == _selectedTemplate;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedTemplate = template),
                      child: Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue[50] : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.grey[300]!,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 80,
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.blue[100] : Colors.grey[200],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.description,
                                  color: isSelected ? Colors.blue[700] : Colors.grey[500],
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              template,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? Colors.blue[700] : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.green[700]),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Your resume will be optimized for ATS systems to increase your chances of getting an interview.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          isActive: _currentStep >= 3,
          state: _currentStep > 3 ? StepState.complete : StepState.indexed,
        ),
      ],
    ),
    ),
    );
  }
}

class ResumePreviewPage extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String jobTitle;
  final String experience;
  final String skills;
  final String education;
  final String summary;
  final String template;
  final String industry;

  const ResumePreviewPage({
    Key? key,
    required this.name,
    required this.email,
    required this.phone,
    required this.jobTitle,
    required this.experience,
    required this.skills,
    required this.education,
    required this.summary,
    required this.template,
    required this.industry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Resume Preview'),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
    IconButton(
    icon: const Icon(Icons.edit),
    onPressed: () => Navigator.pop(context),
    ),
    IconButton(
    icon: const Icon(Icons.share),
    onPressed: () {
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
    content: Text('Sharing resume...'),
    backgroundColor: Colors.blue,
    ),
    );
    },
    ),
    IconButton(
    icon: const Icon(Icons.download),
    onPressed: () {
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
    content: Text('Resume downloaded successfully!'),
    backgroundColor: Colors.green,
    ),
    );
    },
    ),
    ],
    ),
    body: SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    children: [
    // ATS Score Card
    Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
    color: Colors.green[50],
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.green[200]!),
    ),
    child: Row(
    children: [
    Container(
    width: 60,
    height: 60,
    decoration: BoxDecoration(
    color: Colors.green,
    shape: BoxShape.circle,
    ),
    child: const Center(
    child: Text(
    '92%',
    style: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 18,
    ),
    ),
    ),
    ),
    const SizedBox(width: 16),
    Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Text(
    'ATS Compatibility Score',
    style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    ),
    ),
    const SizedBox(height: 4),
    Text(
    'Your resume is optimized for ${industry} roles',
    style: TextStyle(
    fontSize: 14,
    color: Colors.grey[700],
    ),
    ),
    ],
    ),
    ),
    ],
    ),
    ),
    const SizedBox(height: 24),

    // Resume Preview
    Container(
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
    BoxShadow(
    color: Colors.grey.withOpacity(0.2),
    spreadRadius: 2,
    blurRadius: 8,
    offset: const Offset(0, 2),
    ),
    ],
    ),
    child: Column(
    children: [
    // Resume Header
    Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(                      color: template == 'Modern' ? const Color(0xFF1E3A8A) :
    template == 'Creative' ? Colors.purple[700] :
    template == 'Minimal' ? Colors.grey[800] :
    template == 'Professional' ? Colors.teal[800] : Colors.blue[800],
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
    ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            jobTitle,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.email, color: Colors.white70, size: 16),
              const SizedBox(width: 8),
              Text(
                email,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
          if (phone.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                Text(
                  phone,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ],
        ],
      ),
    ),

      // Resume Content
      Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Section
            if (summary.isNotEmpty) ...[
              _buildResumeSection('PROFESSIONAL SUMMARY', template),
              const SizedBox(height: 8),
              Text(
                summary,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Skills Section
            _buildResumeSection('KEY SKILLS', template),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.split(',').map((skill) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getTemplateColor(template).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _getTemplateColor(template).withOpacity(0.3)),
                ),
                child: Text(
                  skill.trim(),
                  style: TextStyle(
                    fontSize: 12,
                    color: _getTemplateColor(template),
                  ),
                ),
              )).toList(),
            ),
            const SizedBox(height: 24),

            // Experience Section
            if (experience.isNotEmpty) ...[
              _buildResumeSection('PROFESSIONAL EXPERIENCE', template),
              const SizedBox(height: 8),
              Text(
                experience,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Education Section
            if (education.isNotEmpty) ...[
              _buildResumeSection('EDUCATION', template),
              const SizedBox(height: 8),
              Text(
                education,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
            ],

            // AI Optimization Badge
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green[600]),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'AI Optimized: This resume is ATS-friendly and tailored for your target role.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
    ],
    ),
    ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Edit Resume'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Resume exported as PDF!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Export PDF'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumeSection(String title, String template) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _getTemplateColor(template),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }

  Color _getTemplateColor(String template) {
    switch (template) {
      case 'Modern':
        return const Color(0xFF1E3A8A);
      case 'Creative':
        return Colors.purple[700]!;
      case 'Minimal':
        return Colors.grey[800]!;
      case 'Professional':
        return Colors.teal[800]!;
      default:
        return Colors.blue[800]!;
    }
  }
}

class InterviewPage extends StatefulWidget {
  const InterviewPage({Key? key}) : super(key: key);

  @override
  State<InterviewPage> createState() => _InterviewPageState();
}

class _InterviewPageState extends State<InterviewPage> {
  String _selectedRole = 'Software Engineer';
  String _selectedType = 'Technical';
  String _selectedLevel = 'Mid-Level';
  String _selectedMode = 'Voice';

  final List<String> _roles = [
    'Software Engineer',
    'Data Scientist',
    'Product Manager',
    'UI/UX Designer',
    'Marketing Manager',
    'Sales Representative',
    'Financial Analyst',
    'HR Specialist',
  ];

  final List<String> _types = ['Technical', 'Behavioral', 'Mixed'];
  final List<String> _levels = ['Entry Level', 'Mid-Level', 'Senior Level'];
  final List<String> _modes = ['Voice', 'Text'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('AI Mock Interview'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                // Navigate to interview history
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    // Header Banner
    Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
    gradient: const LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
    BoxShadow(
    color: Colors.green.withOpacity(0.3),
    blurRadius: 10,
    offset: const Offset(0, 4),
    ),
    ],
    ),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Row(
    children: [
    Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.2),
    borderRadius: BorderRadius.circular(12),
    ),
    child: const Icon(
    Icons.record_voice_over,
    color: Colors.white,
    size: 30,
    ),
    ),
    const SizedBox(width: 16),
    const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'AI Mock Interview',
    style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),
    ),
    SizedBox(height: 4),
    Text(
    'Practice with AI feedback',
    style: TextStyle(
    fontSize: 14,
    color: Colors.white70,
    ),
    ),
    ],
    ),
    ],
    ),
    const SizedBox(height: 20),
    const Text(
    'Improve your interview skills with our AI-powered mock interviews. Get real-time feedback and detailed analysis.',
    style: TextStyle(
    fontSize: 14,
    color: Colors.white,
    height: 1.5,
    ),
    ),
    const SizedBox(height: 16),
    Row(
    children: [
    Expanded(
    child: Container(
    padding: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.2),
    borderRadius: BorderRadius.circular(8),
    ),
    child: const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(Icons.check_circle, color: Colors.white, size: 16),
    SizedBox(width: 8),
    Text(
    'Real-time Feedback',
    style: TextStyle(
    fontSize: 12,
    color: Colors.white,
    ),
    ),
    ],
    ),
    ),
    ),
    const SizedBox(width: 12),
    Expanded(
    child: Container(
    padding: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.2),
    borderRadius: BorderRadius.circular(8),
    ),
    child: const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(Icons.analytics_outlined, color: Colors.white, size: 16),
    SizedBox(width: 8),
    Text(
    'Detailed Analysis',
    style: TextStyle(
    fontSize: 12,
    color: Colors.white,
    ),
    ),
    ],
    ),
    ),
    ),
    ],
    ),
    ],
    ),
    ),
    const SizedBox(height: 24),

    // Interview Setup
    const Text(
    'Interview Setup',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),
    ),
    const SizedBox(height: 16),

    // Job Role Selection
    const Text(
    'Job Role',
    style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    ),
    ),
    const SizedBox(height: 8),
    Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
    border: Border.all(color: Colors.grey[300]!),
    borderRadius: BorderRadius.circular(12),
    ),
    child: DropdownButtonHideUnderline(
    child: DropdownButton<String>(
    value: _selectedRole,
    isExpanded: true,
    items: _roles.map((String role) {
    return DropdownMenuItem<String>(
    value: role,
    child: Text(role),
    );
    }).toList(),
    onChanged: (String? newValue) {
    if (newValue != null) {
    setState(() => _selectedRole = newValue);
    }
    },
    ),
    ),
    ),
    const SizedBox(height: 16),

    // Interview Type
    const Text(
    'Interview Type',
    style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    ),
    ),
    const SizedBox(height: 8),
    Row(
    children: _types.map((type) {
    final isSelected = _selectedType == type;
    return Expanded(
    child: GestureDetector(
    onTap: () => setState(() => _selectedType = type),
    child: Container(
    margin: const EdgeInsets.only(right: 8),
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(
    color: isSelected ? Colors.green[100] : Colors.grey[100],
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isSelected ? Colors.green : Colors.grey[300]!,
      ),
    ),
      child: Text(
        type,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.green[700] : Colors.grey[700],
        ),
      ),
    ),
    ),
    );
    }).toList(),
    ),
      const SizedBox(height: 16),

      // Experience Level
      const Text(
        'Experience Level',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 8),
      Row(
        children: _levels.map((level) {
          final isSelected = _selectedLevel == level;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedLevel = level),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue[100] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey[300]!,
                  ),
                ),
                child: Text(
                  level,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.blue[700] : Colors.grey[700],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
      const SizedBox(height: 16),

      // Interview Mode
      const Text(
        'Interview Mode',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 8),
      Row(
        children: _modes.map((mode) {
          final isSelected = _selectedMode == mode;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedMode = mode),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.purple[100] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.purple : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      mode == 'Voice' ? Icons.mic : Icons.keyboard,
                      size: 16,
                      color: isSelected ? Colors.purple[700] : Colors.grey[700],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      mode,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.purple[700] : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
      const SizedBox(height: 24),

      // Recent Interviews
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Recent Practice Sessions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('View All'),
          ),
        ],
      ),
      const SizedBox(height: 16),
      _buildInterviewHistoryCard(
        'Software Engineer - Technical',
        '2 days ago',
        85,
        'Great technical knowledge, work on communication clarity',
      ),
      const SizedBox(height: 12),
      _buildInterviewHistoryCard(
        'Product Manager - Behavioral',
        '1 week ago',
        78,
        'Good leadership examples, improve STAR method usage',
      ),
      const SizedBox(height: 12),
      _buildInterviewHistoryCard(
        'Data Scientist - Mixed',
        '2 weeks ago',
        92,
        'Excellent problem-solving and communication skills',
      ),
      const SizedBox(height: 32),

      // Start Interview Button
      SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InterviewSessionPage(
                  role: _selectedRole,
                  type: _selectedType,
                  level: _selectedLevel,
                  mode: _selectedMode,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _selectedMode == 'Voice' ? Icons.mic : Icons.keyboard,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              const Text(
                'Start Mock Interview',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),

      // Premium Features Banner
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.amber[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.amber[200]!),
        ),
        child: Row(
          children: [
            Icon(Icons.workspace_premium, color: Colors.amber[800]),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Upgrade to Premium for unlimited interviews and personalized feedback',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Upgrade'),
            ),
          ],
        ),
      ),
    ],
    ),
        ),
    );
  }

  Widget _buildInterviewHistoryCard(
      String title,
      String date,
      int score,
      String feedback,
      ) {
    Color scoreColor = score >= 85 ? Colors.green : score >= 70 ? Colors.orange : Colors.red;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: scoreColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$score%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: scoreColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            feedback,
            style: const TextStyle(
              fontSize: 14,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.replay, size: 16),
                label: const Text('Retry'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              const SizedBox(width: 16),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.visibility, size: 16),
                label: const Text('View'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InterviewSessionPage extends StatefulWidget {
  final String role;
  final String type;
  final String level;
  final String mode;

  const InterviewSessionPage({
    Key? key,
    required this.role,
    required this.type,
    required this.level,
    required this.mode,
  }) : super(key: key);

  @override
  State<InterviewSessionPage> createState() => _InterviewSessionPageState();
}

class _InterviewSessionPageState extends State<InterviewSessionPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final TextEditingController _answerController = TextEditingController();
  int _currentQuestionIndex = 0;
  bool _isRecording = false;
  bool _isAnalyzing = false;
  bool _isListening = false;
  double _confidence = 0.0;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Tell me about yourself and your experience in software development.',
      'category': 'Introduction',
      'tips': 'Focus on relevant experience and skills for the role.',
    },
    {
      'question': 'How would you approach debugging a complex software issue?',
      'category': 'Technical',
      'tips': 'Mention systematic approaches and tools you would use.',
    },
    {
      'question': 'Describe a challenging project you worked on and how you overcame obstacles.',
      'category': 'Behavioral',
      'tips': 'Use the STAR method: Situation, Task, Action, Result.',
    },
    {
      'question': 'What are your salary expectations for this role?',
      'category': 'Compensation',
      'tips': 'Research industry standards and be prepared to negotiate.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
      _isListening = _isRecording;
    });

    if (_isRecording) {
      _animationController.repeat(reverse: true);
      // Simulate speech recognition confidence updates
      _startConfidenceSimulation();
    } else {
      _animationController.stop();
      _animationController.reset();
      setState(() {
        _confidence = 0.0;
      });
    }
  }

  void _startConfidenceSimulation() {
    // This would be replaced with actual speech recognition in a real app
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_isRecording) {
        setState(() {
          _confidence = 0.3;
        });
        Future.delayed(const Duration(milliseconds: 500), () {
          if (_isRecording) {
            setState(() {
              _confidence = 0.7;
            });
            Future.delayed(const Duration(milliseconds: 700), () {
              if (_isRecording) {
                setState(() {
                  _confidence = 0.9;
                });
              }
            });
          }
        });
      }
    });
  }

  void _nextQuestion() async {
    if (_answerController.text.isEmpty && !_isRecording) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide an answer before proceeding'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isAnalyzing = true);

    // Simulate AI analysis
    await Future.delayed(const Duration(seconds: 2));

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _answerController.clear();
        _isAnalyzing = false;
        _confidence = 0.0;
      });
    } else {
      // Interview completed
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => InterviewFeedbackPage(
            role: widget.role,
            type: widget.type,
            level: widget.level,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
        appBar: AppBar(
        title: Text('${widget.type} Interview'),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
    Padding(
    padding: const EdgeInsets.only(right: 16.0),
    child: Center(
    child: Text(
     '${_currentQuestionIndex + 1}/${_questions.length}',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
    ),
    ),
    ],
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Bar
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 24),

            // AI Interviewer Avatar
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF059669)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.smart_toy,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  if (_isListening)
                    Positioned.fill(
                      child: CircularProgressIndicator(
                        value: _confidence,
                        strokeWidth: 3,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            const Center(
              child: Text(
                'AI Interviewer',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                _isListening ? 'Listening...' : 'Ask me anything',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Question Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue[200]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      currentQuestion['category'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    currentQuestion['question'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, size: 16, color: Colors.amber[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tip: ${currentQuestion['tips']}',
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Answer Input
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Your Answer',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (widget.mode == 'Voice')
                            TextButton.icon(
                              onPressed: _toggleRecording,
                              icon: Icon(
                                _isRecording ? Icons.stop : Icons.mic,
                                size: 16,
                                color: _isRecording ? Colors.red : Colors.grey[700],
                              ),
                              label: Text(
                                _isRecording ? 'Stop' : 'Record',
                                style: TextStyle(
                                  color: _isRecording ? Colors.red : Colors.grey[700],
                                ),
                              ),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: TextField(
                          controller: _answerController,
                          decoration: const InputDecoration(
                            hintText: 'Type your answer here...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          enabled: widget.mode == 'Text' || !_isRecording,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Recording and Next Button
            Row(
              children: [
                // Voice Recording Button
                if (widget.mode == 'Voice')
                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _isRecording ? _scaleAnimation.value : 1.0,
                        child: GestureDetector(
                          onTap: _toggleRecording,
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: _isRecording ? Colors.red : Colors.grey[200],
                              shape: BoxShape.circle,
                              boxShadow: _isRecording
                                  ? [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ]
                                  : null,
                            ),
                            child: Icon(
                              _isRecording ? Icons.stop : Icons.mic,
                              color: _isRecording ? Colors.white : Colors.grey[600],
                              size: 24,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                if (widget.mode == 'Voice') const SizedBox(width: 16),

                // Next Button
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isAnalyzing ? null : _nextQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isAnalyzing
                          ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Analyzing...'),
                        ],
                      )
                          : Text(
                        _currentQuestionIndex < _questions.length - 1
                            ? 'Next Question'
                            : 'Finish Interview',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    }
  }

  class InterviewFeedbackPage extends StatelessWidget {
  final String role;
  final String type;
  final String level;

  const InterviewFeedbackPage({
  Key? key,
  required this.role,
  required this.type,
  required this.level,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
  title: const Text('Interview Feedback'),
  backgroundColor: Colors.transparent,
  elevation: 0,
  automaticallyImplyLeading: false,
  actions: [
  IconButton(
  icon: const Icon(Icons.close),
  onPressed: () {
  Navigator.of(context).popUntil((route) => route.isFirst);
  },
  ),
  ],
  ),
  body: SingleChildScrollView(
  padding: const EdgeInsets.all(16.0),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  // Overall Score
  Container(
  width: double.infinity,
  padding: const EdgeInsets.all(24),
  decoration: BoxDecoration(
  gradient: const LinearGradient(
  colors: [Color(0xFF10B981), Color(0xFF059669)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  ),
  borderRadius: BorderRadius.circular(16),
  boxShadow: [
  BoxShadow(
  color: Colors.green.withOpacity(0.3),
  blurRadius: 10,
  offset: const Offset(0, 4),
  ),
  ],
  ),
  child: Column(
  children: [
  const Text(
  'Overall Score',
  style: TextStyle(
  fontSize: 18,
  color: Colors.white70,
  ),
  ),
  const SizedBox(height: 8),
  Stack(
  alignment: Alignment.center,
  children: [
  SizedBox(
  width: 120,
  height: 120,
  child: CircularProgressIndicator(
  value: 0.87,
  strokeWidth: 10,
  backgroundColor: Colors.white.withOpacity(0.2),
  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
  ),
  ),
  const Text(
  '87%',
  style: TextStyle(
  fontSize: 36,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  ),
  ),
  ],
  ),
  const SizedBox(height: 8),
  Container(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  decoration: BoxDecoration(
  color: Colors.white.withOpacity(0.2),
  borderRadius: BorderRadius.circular(20),
  ),
  child: const Text(
  'Excellent Performance!',
  style: TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: Colors.white,
  ),
  ),
  ),
  const SizedBox(height: 16),
  Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
  _buildScoreDetail('Technical', '90%'),
  _buildScoreDetail('Communication', '85%'),
  _buildScoreDetail('Clarity', '86%'),
  ],
  ),
  ],
  ),
  ),
  const SizedBox(height: 24),

  // Detailed Feedback
  const Text(
  'Detailed Feedback',
  style: TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  ),
  ),
  const SizedBox(height: 16),

  _buildFeedbackCard(
  'Strengths',
  Icons.thumb_up,
  Colors.green,
  [
  'Strong technical knowledge and problem-solving approach',
  'Clear communication with good use of examples',
  'Confident delivery and professional demeanor',
  'Good understanding of software development best practices',
  ],
  ),
  const SizedBox(height: 16),

  _buildFeedbackCard(
  'Areas for Improvement',
  Icons.trending_up,
  Colors.orange,
  [
  'Consider using the STAR method for behavioral questions',
  'Provide more specific metrics and quantifiable results',
  'Take brief pauses to organize thoughts before answering',
  'Ask clarifying questions when needed',
  ],
  ),
  const SizedBox(height: 16),

  _buildFeedbackCard(
  'Recommendations',
  Icons.lightbulb,
  Colors.blue,
  [
  'Practice more behavioral questions using STAR format',
  'Research common ${role.toLowerCase()} interview questions',
  'Prepare specific examples with measurable outcomes',
  'Practice mock interviews 2-3 times per week',
  ],
  ),
  const SizedBox(height: 24),

  // Question-by-Question Analysis
  const Text(
  'Question Analysis',
  style: TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  ),
  ),
  const SizedBox(height: 16),

  _buildQuestionAnalysisCard(
   'Tell me about yourself',
  'Introduction',
  85,
  'Good overview of experience, but could be more concise and focused on relevant skills for the role.',
  ),
  const SizedBox(height: 12),

  _buildQuestionAnalysisCard(
  'How would you approach debugging a complex issue?',
  'Technical',
  92,
  'Excellent systematic approach with clear steps and tools mentioned.',
  ),
  const SizedBox(height: 12),

  _buildQuestionAnalysisCard(
  'Describe a challenging project',
  'Behavioral',
  78,
  'Good example but lacked structure. Try using the STAR method for clarity.',
  ),
  const SizedBox(height: 12),

  _buildQuestionAnalysisCard(
  'Salary expectations',
  'Compensation',
  88,
  'Well-researched response with appropriate range and willingness to negotiate.',
  ),
  const SizedBox(height: 24),

  // Action Buttons
  Row(
  children: [
  Expanded(
  child: OutlinedButton(
  onPressed: () {
  Navigator.of(context).popUntil((route) => route.isFirst);
  },
  style: OutlinedButton.styleFrom(
  padding: const EdgeInsets.symmetric(vertical: 16),
  shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(12),
  ),
  ),
  child: const Text('Back to Home'),
  ),
  ),
  const SizedBox(width: 12),
  Expanded(
  child: ElevatedButton(
  onPressed: () {
  Navigator.of(context).popUntil((route) => route.isFirst);
  // Navigate to interview page
  },
  style: ElevatedButton.styleFrom(
  backgroundColor: const Color(0xFF10B981),
  foregroundColor: Colors.white,
  padding: const EdgeInsets.symmetric(vertical: 16),
  shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(12),
  ),
  ),
  child: const Text('Practice Again'),
  ),
  ),
  ],
  ),
  const SizedBox(height: 16),

  // Share Results
  SizedBox(
  width: double.infinity,
  child: OutlinedButton.icon(
  onPressed: () {
  ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
  content: Text('Interview results shared successfully!'),
  backgroundColor: Colors.green,
  ),
  );
  },
  icon: const Icon(Icons.share),
  label: const Text('Share Results'),
  style: OutlinedButton.styleFrom(
  padding: const EdgeInsets.symmetric(vertical: 16),
  shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(12),
  ),
  ),
  ),
  ),
  const SizedBox(height: 24),

  // AI Improvement Suggestion
  Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
  color: Colors.blue[50],
  borderRadius: BorderRadius.circular(12),
  border: Border.all(color: Colors.blue[200]!),
  ),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Row(
  children: [
  Icon(Icons.psychology, color: Colors.blue[700]),
  const SizedBox(width: 8),
  const Text(
  'AI Improvement Suggestion',
  style: TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.black87,
  ),
  ),
  ],
  ),
  const SizedBox(height: 12),
  const Text(
  'Based on your performance, we recommend focusing on structured responses using the STAR method for behavioral questions. This will help you provide clear, concise answers that highlight your achievements.',
  style: TextStyle(
  fontSize: 14,
  height: 1.5,
  color: Colors.black87,
  ),
  ),
  const SizedBox(height: 12),
  OutlinedButton(
  onPressed: () {},
  style: OutlinedButton.styleFrom(
  foregroundColor: Colors.blue[700],
  side: BorderSide(color: Colors.blue[700]!),
  ),
  child: const Text('View STAR Method Guide'),
  ),
  ],
  ),
  ),
  ],
  ),
  ),
  );
  }

  Widget _buildScoreDetail(String label, String score) {
  return Column(
  children: [
  Text(
  score,
  style: const TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  ),
  ),
  Text(
  label,
  style: const TextStyle(
  fontSize: 12,
  color: Colors.white70,
  ),
  ),
  ],
  );
  }

  Widget _buildFeedbackCard(
  String title,
  IconData icon,
  Color color,
  List<String> points,
  ) {
  return Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
  color: color.withOpacity(0.05),
  borderRadius: BorderRadius.circular(12),
  border: Border.all(color: color.withOpacity(0.2)),
  ),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Row(
  children: [
  Icon(icon, color: color, size: 20),
  const SizedBox(width: 8),
  Text(
  title,
  style: TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: color,
  ),
  ),
  ],
  ),
  const SizedBox(height: 12),
  ...points.map((point) => Padding(
  padding: const EdgeInsets.only(bottom: 8),
  child: Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Container(
  width: 6,
  height: 6,
  margin: const EdgeInsets.only(top: 6, right: 8),
  decoration: BoxDecoration(
  color: color,
  shape: BoxShape.circle,
  ),
  ),
  Expanded(
  child: Text(
  point,
  style: const TextStyle(fontSize: 14, height: 1.4),
  ),
  ),
  ],
  ),
  )).toList(),
  ],
  ),
  );
  }

  Widget _buildQuestionAnalysisCard(
  String question,
  String category,
  int score,
  String feedback,
  ) {
  Color scoreColor = score >= 85 ? Colors.green : score >= 70 ? Colors.orange : Colors.red;

  return Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12),
  boxShadow: [
  BoxShadow(
  color: Colors.grey.withOpacity(0.1),
  blurRadius: 10,
  offset: const Offset(0, 2),
  ),
  ],
  ),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  Container(
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  decoration: BoxDecoration(
  color: Colors.grey[200],
  borderRadius: BorderRadius.circular(8),
  ),
  child: Text(
  category,
  style: TextStyle(
  fontSize: 12,
  color: Colors.grey[700],
  ),
  ),
  ),
  Container(
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  decoration: BoxDecoration(
  color: scoreColor.withOpacity(0.1),
  borderRadius: BorderRadius.circular(8),
  ),
  child: Text(
  '$score%',
  style: TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.bold,
  color: scoreColor,
  ),
  ),
  ),
  ],
  ),
  const SizedBox(height: 8),
  Text(
  question,
  style: const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  ),
  ),
  const SizedBox(height: 8),
  Text(
  feedback,
  style: TextStyle(
  fontSize: 14,
  color: Colors.grey[700],
  height: 1.4,
  ),
  ),
  ],
  ),
  );
  }
  }

  class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
  title: const Text('Profile'),
  backgroundColor: Colors.transparent,
  elevation: 0,
  actions: [
  IconButton(
  icon: const Icon(Icons.settings),
  onPressed: () {
  // Navigate to settings page or show dialog
  },
  ),
  ],
  ),
  body: SingleChildScrollView(
  padding: const EdgeInsets.all(16.0),
  child: Column(
  children: [
  // Profile Header
  Container(
  width: double.infinity,
  padding: const EdgeInsets.all(24),
  decoration: BoxDecoration(
  gradient: const LinearGradient(
  colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  ),
  borderRadius: BorderRadius.circular(16),
  boxShadow: [
  BoxShadow(
  color: Colors.blue.withOpacity(0.3),
  blurRadius: 10,
  offset: const Offset(0, 4),
  ),
  ],
  ),
  child: Column(
  children: [
  Stack(
  alignment: Alignment.bottomRight,
  children: [
  CircleAvatar(
  radius: 50,
  backgroundColor: Colors.white,
  child: Text(
  'JD',
  style: TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: Theme.of(context).primaryColor,
  ),
  ),
  ),
  Container(
  padding: const EdgeInsets.all(4),
  decoration: const BoxDecoration(
  color: Colors.white,
  shape: BoxShape.circle,
  ),
  child: const Icon(
  Icons.edit,
  size: 18,
  color: Color(0xFF1E3A8A),
  ),
  ),
  ],
  ),
  const SizedBox(height: 16),
  const Text(
  'John Doe',
  style: TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  ),
  ),
  const SizedBox(height: 4),
  const Text(
  'Software Engineer',
  style: TextStyle(
  fontSize: 16,
  color: Colors.white70,
  ),
  ),
  const SizedBox(height: 16),
  Container(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  decoration: BoxDecoration(
  color: Colors.white.withOpacity(0.2),
  borderRadius: BorderRadius.circular(20),
  ),
  child: const Row(
  mainAxisSize: MainAxisSize.min,
  children: [
  Icon(
  Icons.workspace_premium,
  size: 16,
  color: Colors.amber,
  ),
  SizedBox(width: 8),
  Text(
  'Premium Member',
  style: TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w600,
  ),
  ),
  ],
  ),
  ),
  ],
  ),
  ),
  const SizedBox(height: 24),

  // Stats Row
  Row(
  children: [
  Expanded(
  child: _buildStatCard(
  'Resumes',
  '5',
  Icons.description,
  Colors.blue,
  ),
  ),
  const SizedBox(width: 12),
  Expanded(
  child: _buildStatCard(
  'Interviews',
  '12',
  Icons.record_voice_over,
  Colors.green,
  ),
  ),
  const SizedBox(width: 12),
  Expanded(
  child: _buildStatCard(
  'Cover Letters',
  '3',
  Icons.mail,
  Colors.orange,
  ),
  ),
  ],
  ),
  const SizedBox(height: 24),

  // Resume Summary Section
  Container(
  width: double.infinity,
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12),
  boxShadow: [
  BoxShadow(
  color: Colors.grey.withOpacity(0.1),
  blurRadius: 10,
  offset: const Offset(0, 2),
  ),
  ],
  ),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Row(
  children: [
  Container(
  padding: const EdgeInsets.all(8),
  decoration: BoxDecoration(
  color: Colors.blue.withOpacity(0.1),
  borderRadius: BorderRadius.circular(8),
  ),
  child: const Icon(
  Icons.description,
  color: Colors.blue,
  ),
  ),
  const SizedBox(width: 12),
  const Text(
  'Resume Summary',
  style: TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  ),
  ),
  ],
  ),
  const SizedBox(height: 16),
  const Text(
  'Software engineer with 5+ years experience in Flutter development, AI integrations, and mobile app architecture. Skilled in Dart, Firebase, and CI/CD pipelines.',
  style: TextStyle(
  fontSize: 14,
  height: 1.5,
  color: Colors.black87,
  ),
  ),
  const SizedBox(height: 16),
  Row(
  children: [
  Expanded(
  child: OutlinedButton.icon(
  onPressed: () {
  // View resume action
  },
  icon: const Icon(Icons.visibility),
  label: const Text('View'),
  style: OutlinedButton.styleFrom(
  padding: const EdgeInsets.symmetric(vertical: 12),
  ),
  ),
  ),
  const SizedBox(width: 12),
  Expanded(
  child: ElevatedButton.icon(
  onPressed: () {
  // Generate resume action
  },
  icon: const Icon(Icons.add),
  label: const Text('Create New'),
  style: ElevatedButton.styleFrom(
  padding: const EdgeInsets.symmetric(vertical: 12),
  ),
  ),
  ),
  ],
  ),
  ],
  ),
  ),
  const SizedBox(height: 24),

  // Interview Performance
  Container(
  width: double.infinity,
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12),
  boxShadow: [
  BoxShadow(
  color: Colors.grey.withOpacity(0.1),
  blurRadius: 10,
  offset: const Offset(0, 2),
  ),
  ],
  ),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Row(
  children: [
  Container(
  padding: const EdgeInsets.all(8),
  decoration: BoxDecoration(
  color: Colors.green.withOpacity(0.1),
  borderRadius: BorderRadius.circular(8),
  ),
  child: const Icon(
  Icons.analytics,
  color: Colors.green,
  ),
  ),
  const SizedBox(width: 12),
  const Text(
  'Interview Performance',
  style: TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  ),
  ),
  ],
  ),
  const SizedBox(height: 16),
  Row(
  children: [
  Expanded(
  child: Column(
  children: [
  Stack(
  alignment: Alignment.center,
  children: [
  SizedBox(
  width: 80,
  height: 80,
  child: CircularProgressIndicator(
  value: 0.85,
  strokeWidth: 8,
  backgroundColor: Colors.grey[200],
  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
  ),
  ),
  const Text(
  '85%',
  style: TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  ),
  ),
  ],
  ),
  const SizedBox(height: 8),
  const Text(
  'Technical',
  style: TextStyle(
  fontSize: 14,
  color: Colors.grey,
  ),
  ),
  ],
  ),
  ),
  Expanded(
  child: Column(
  children: [
  Stack(
  alignment: Alignment.center,
  children: [
  SizedBox(
  width: 80,
  height: 80,
  child: CircularProgressIndicator(
  value: 0.78,
  strokeWidth: 8,
  backgroundColor: Colors.grey[200],
  valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
  ),
  ),
  const Text(
  '78%',
  style: TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  ),
  ),
  ],
  ),
  const SizedBox(height: 8),
  const Text(
  'Behavioral',
  style: TextStyle(
  fontSize: 14,
  color: Colors.grey,
  ),
  ),
  ],
  ),
  ),
  Expanded(
  child: Column(
  children: [
  Stack(
  alignment: Alignment.center,
  children: [
  SizedBox(
  width: 80,
  height: 80,
  child: CircularProgressIndicator(
  value: 0.92,
  strokeWidth: 8,
  backgroundColor: Colors.grey[200],
  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
  ),
  ),
  const Text(
  '92%',
  style: TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  ),
  ),
  ],
  ),
  const SizedBox(height: 8),
  const Text(
  'Communication',
  style: TextStyle(
  fontSize: 14,
  color: Colors.grey,
  ),
  ),
  ],
  ),
  ),
  ],
  ),
  const SizedBox(height: 16),
  SizedBox(
  width: double.infinity,
  child: OutlinedButton.icon(
  onPressed: () {
  // View detailed performance
  },
  icon: const Icon(Icons.bar_chart),
  label: const Text('View Detailed Performance'),
  style: OutlinedButton.styleFrom(
  padding: const EdgeInsets.symmetric(vertical: 12),
  ),
  ),
  ),
  ],
  ),
  ),
  const SizedBox(height: 24),

  // Subscription Info
  Container(
  width: double.infinity,
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
  color: Colors.blue.shade50,
  borderRadius: BorderRadius.circular(12),
  border: Border.all(color: Colors.blue.shade200),
  ),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Row(
  children: [
  Icon(
  Icons.workspace_premium,
  color: Colors.amber[700],
  ),
  const SizedBox(width: 12),
  const Text(
  'Premium Subscription',
  style: TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Color(0xFF1E3A8A),
  ),
  ),
  ],
  ),
  const SizedBox(height: 12),
  const Text(
  'Your premium subscription renews on June 23, 2025',
  style: TextStyle(
  fontSize: 14,
  color: Colors.black87,
  ),
  ),
  const SizedBox(height: 8),
  const Text(
  'Benefits: Unlimited resumes, AI mock interviews, priority support',
  style: TextStyle(
  fontSize: 14,
  color: Colors.black54,
  ),
  ),
  const SizedBox(height: 16),
  Row(
  children: [
  Expanded(
  child: OutlinedButton(
  onPressed: () {
  // Manage subscription
  },
  style: OutlinedButton.styleFrom(
  foregroundColor: const Color(0xFF1E3A8A),
  side: const BorderSide(color: Color(0xFF1E3A8A)),
  padding: const EdgeInsets.symmetric(vertical: 12),
  ),
  child: const Text('Manage Subscription'),
  ),
  ),
  const SizedBox(width: 12),
  Expanded(
  child: ElevatedButton(
  onPressed: () {
  // Upgrade plan
  },
  style: ElevatedButton.styleFrom(
  backgroundColor: const Color(0xFF1E3A8A),
  foregroundColor: Colors.white,
  padding: const EdgeInsets.symmetric(vertical: 12),
  ),
  child: const Text('Upgrade Plan'),
  ),
  ),
  ],
  ),
  ],
  ),
  ),
  const SizedBox(height: 24),

  // Account Settings
  Container(
  width: double.infinity,
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12),
  boxShadow: [
  BoxShadow(
  color: Colors.grey.withOpacity(0.1),
  blurRadius: 10,
  offset: const Offset(0, 2),
  ),
  ],
  ),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text(
  'Account Settings',
  style: TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  ),
  ),
  const SizedBox(height: 16),
  _buildSettingsItem(
  'Edit Profile',
  Icons.person_outline,
  () {},
  ),
  const Divider(),
  _buildSettingsItem(
  'Notification Preferences',
  Icons.notifications_none,
  () {},
  ),
  const Divider(),
  _buildSettingsItem(
  'Privacy Settings',
  Icons.lock_outline,
  () {},
  ),
  const Divider(),
  _buildSettingsItem(
  'Help & Support',
  Icons.help_outline,
  () {},
  ),
  const Divider(),
  _buildSettingsItem(
  'Sign Out',
  Icons.logout,
  () {
  // Sign out logic
  Navigator.of(context).pushAndRemoveUntil(
  MaterialPageRoute(builder: (context) => const LoginPage()),
  (route) => false,
  );
  },
  color: Colors.red,
  ),
  ],
  ),
  ),
  const SizedBox(height: 24),
  ],
  ),
  ),
  );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
  return Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
  color: color.withOpacity(0.1),
  borderRadius: BorderRadius.circular(12),
  border: Border.all(color: color.withOpacity(0.3)),
  ),
  child: Column(
  children: [
  Icon(icon, color: color),
  const SizedBox(height: 8),
  Text(
  value,
  style: TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: color,
  ),
  ),
  const SizedBox(height: 4),
  Text(
  title,
  style: TextStyle(
  fontSize: 12,
  color: color.withOpacity(0.8),
  ),
  ),
  ],
  ),
  );
  }

  Widget _buildSettingsItem(
  String title,
  IconData icon,
  VoidCallback onTap, {
  Color? color,
  }) {
  return InkWell(
  onTap: onTap,
  borderRadius: BorderRadius.circular(8),
  child: Padding(
  padding: const EdgeInsets.symmetric(vertical: 12),
  child: Row(
  children: [
  Icon(
  icon,
  color: color ?? Colors.grey[700],
  size: 20,
  ),
  const SizedBox(width: 16),
  Text(
  title,
  style: TextStyle(
  fontSize: 16,
  color: color ?? Colors.black87,
  ),
  ),
  const Spacer(),
  Icon(
  Icons.chevron_right,
  color: Colors.grey[400],
  size: 20,
  ),
  ],
  ),
  ),
  );
  }
  }
// Settings Page
  class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
  }

  class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  bool _notifications = true;
  bool _emailUpdates = true;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
  title: const Text('Settings'),
  backgroundColor: Colors.transparent,
  elevation: 0,
  ),
  body: SingleChildScrollView(
  padding: const EdgeInsets.all(16.0),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  // Appearance Section
  const Text(
  'Appearance',
  style: TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  ),
  ),
  const SizedBox(height: 16),
  Container(
  decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12),
  boxShadow: [
  BoxShadow(
  color: Colors.grey.withOpacity(0.1),
  blurRadius: 10,
  offset: const Offset(0, 2),
  ),
  ],
  ),
  child: Column(
  children: [
  SwitchListTile(
  title: const Text('Dark Mode'),
  subtitle: const Text('Enable dark theme for the app'),
  value: _darkMode,
  onChanged: (value) {
  setState(() {
  _darkMode = value;
  });
  },
  secondary: const Icon(Icons.dark_mode),
  ),
  const Divider(height: 1),
  ListTile(
  title: const Text('Language'),
  subtitle: Text(_language),
  leading: const Icon(Icons.language),
  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
  onTap: () {
  // Show language selection dialog
  _showLanguageDialog();
  },
  ),
  ],
  ),
  ),
  const SizedBox(height: 24),

  // Notifications Section
  const Text(
  'Notifications',
  style: TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  ),
  ),
  const SizedBox(height: 16),
  Container(
  decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12),
  boxShadow: [
  BoxShadow(
  color: Colors.grey.withOpacity(0.1),
  blurRadius: 10,
  offset: const Offset(0, 2),
  ),
  ],
  ),
  child: Column(
  children: [
  SwitchListTile(
  title: const Text('Push Notifications'),
  subtitle: const Text('Receive app notifications'),
  value: _notifications,
  onChanged: (value) {
  setState(() {
  _notifications = value;
  });
  },
  secondary: const Icon(Icons.notifications),
  ),
  const Divider(height: 1),
  SwitchListTile(
  title: const Text('Email Updates'),
  subtitle: const Text('Receive updates via email'),
  value: _emailUpdates,
  onChanged: (value) {
  setState(() {
  _emailUpdates = value;
  });
  },
  secondary: const Icon(Icons.email),
  ),
  ],
  ),
  ),
  const SizedBox(height: 24),

  // Account Section
  const Text(
  'Account',
  style: TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  ),
  ),
  const SizedBox(height: 16),
  Container(
  decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12),
  boxShadow: [
  BoxShadow(
  color: Colors.grey.withOpacity(0.1),
  blurRadius: 10,
  offset: const Offset(0, 2),
  ),
  ],
  ),
  child: Column(
  children: [
  ListTile(
  title: const Text('Change Password'),
  leading: const Icon(Icons.lock_outline),
  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
  onTap: () {
  // Navigate to change password screen
  },
  ),
  const Divider(height: 1),
  ListTile(
  title: const Text('Privacy Policy'),
  leading: const Icon(Icons.privacy_tip_outlined),
  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
  onTap: () {
  // Navigate to privacy policy screen
  },
  ),
  const Divider(height: 1),
  ListTile(
  title: const Text('Terms of Service'),
  leading: const Icon(Icons.description_outlined),
  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
  onTap: () {
  // Navigate to terms of service screen
  },
  ),
  ],
  ),
  ),
  const SizedBox(height: 24),

  // Data & Storage Section
  const Text(
  'Data & Storage',
  style: TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  ),
  ),
  const SizedBox(height: 16),
  Container(
  decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12),
  boxShadow: [
  BoxShadow(
  color: Colors.grey.withOpacity(0.1),
  blurRadius: 10,
  offset: const Offset(0, 2),
  ),
  ],
  ),
  child: Column(
  children: [
  ListTile(
  title: const Text('Clear Cache'),
  subtitle: const Text('Free up storage space'),
  leading: const Icon(Icons.cleaning_services_outlined),
  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
  onTap: () {
  // Show clear cache confirmation dialog
  _showClearCacheDialog();
  },
  ),
  const Divider(height: 1),
  ListTile(
  title: const Text('Download My Data'),
  subtitle: const Text('Get a copy of your personal data'),
  leading: const Icon(Icons.download_outlined),
  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
  onTap: () {
  // Navigate to download data screen
  },
  ),
  ],
  ),
  ),
  const SizedBox(height: 24),

  // Danger Zone Section
  const Text(
  'Danger Zone',
  style: TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Colors.red,
  ),
  ),
  const SizedBox(height: 16),
  Container(
  decoration: BoxDecoration(
  color: Colors.red[50],
  borderRadius: BorderRadius.circular(12),
  border: Border.all(color: Colors.red[200]!),
  ),
  child: ListTile(
  title: const Text(
  'Delete Account',
  style: TextStyle(color: Colors.red),
  ),
  subtitle: const Text(
  'Permanently delete your account and all data',
  style: TextStyle(color: Colors.red),
  ),
  leading: const Icon(Icons.delete_forever, color: Colors.red),
  onTap: () {
  // Show delete account confirmation dialog
  _showDeleteAccountDialog();
  },
  ),
  ),
  const SizedBox(height: 32),

  // App Version
  Center(
  child: Text(
  'App Version 1.0.0',
  style: TextStyle(
  fontSize: 14,
  color: Colors.grey[600],
  ),
  ),
  ),
  const SizedBox(height: 16),
  ],
  ),
  ),
  );
  }

  void _showLanguageDialog() {
  showDialog(
  context: context,
  builder: (context) {
  return AlertDialog(
  title: const Text('Select Language'),
  content: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
  _buildLanguageOption('English'),
  _buildLanguageOption('Spanish'),
  _buildLanguageOption('French'),
  _buildLanguageOption('German'),
  _buildLanguageOption('Chinese'),
  ],
  ),
  actions: [
  TextButton(
  onPressed: () {
  Navigator.pop(context);
  },
  child: const Text('Cancel'),
  ),
  ],
  );
  },
  );
  }

  Widget _buildLanguageOption(String language) {
  return ListTile(
  title: Text(language),
  trailing: _language == language
  ? const Icon(Icons.check, color: Colors.green)
      : null,
  onTap: () {
  setState(() {
  _language = language;
  });
  Navigator.pop(context);
  },
  );
  }

  void _showClearCacheDialog() {
  showDialog(
  context: context,
  builder: (context) {
  return AlertDialog(
  title: const Text('Clear Cache'),
  content: const Text(
  'This will clear all cached data. This action cannot be undone.',
  ),
  actions: [
  TextButton(
  onPressed: () {
  Navigator.pop(context);
  },
  child: const Text('Cancel'),
  ),
  TextButton(
  onPressed: () {
  // Clear cache logic
  Navigator.pop(context);
  ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
  content: Text('Cache cleared successfully'),
  backgroundColor: Colors.green,
  ),
  );
  },
  child: const Text('Clear'),
  style: TextButton.styleFrom(
  foregroundColor: Colors.red,
  ),
  ),
  ],
  );
  },
  );
  }

  void _showDeleteAccountDialog() {
  showDialog(
  context: context,
  builder: (context) {
  return AlertDialog(
  title: const Text('Delete Account'),
  content: const Text(
  'This will permanently delete your account and all associated data. This action cannot be undone.',
  ),
  actions: [
  TextButton(
  onPressed: () {
  Navigator.pop(context);
  },
  child: const Text('Cancel'),
  ),
  TextButton(
  onPressed: () {
  // Delete account logic
  Navigator.pop(context);
  Navigator.of(context).pushAndRemoveUntil(
  MaterialPageRoute(builder: (context) => const LoginPage()),
  (route) => false,
  );
  },
  child: const Text('Delete'),
  style: TextButton.styleFrom(
  foregroundColor: Colors.red,
  ),
  ),
  ],
  );
  },
  );
  }
  }

// Cover Letter Generator Page
  class CoverLetterPage extends StatefulWidget {
  const CoverLetterPage({Key? key}) : super(key: key);

  @override
  State<CoverLetterPage> createState() => _CoverLetterPageState();
  }

  class _CoverLetterPageState extends State<CoverLetterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _companyController = TextEditingController();
  final _positionController = TextEditingController();
  final _skillsController = TextEditingController();
  final _experienceController = TextEditingController();

  bool _isGenerating = false;
  String _selectedTone = 'Professional';
  final List<String> _tones = ['Professional', 'Enthusiastic', 'Formal', 'Creative'];

  @override
  void dispose() {
  _nameController.dispose();
  _emailController.dispose();
  _phoneController.dispose();
  _companyController.dispose();
  _positionController.dispose();
  _skillsController.dispose();
  _experienceController.dispose();
  super.dispose();
  }

  void _generateCoverLetter() async {
  if (_formKey.currentState!.validate()) {
  setState(() => _isGenerating = true);

  // Simulate AI generation
  await Future.delayed(const Duration(seconds: 3));

  if (mounted) {
  setState(() => _isGenerating = false);
  Navigator.push(
  context,
  MaterialPageRoute(
  builder: (context) => CoverLetterPreviewPage(
  name: _nameController.text,
  email: _emailController.text,
  phone: _phoneController.text,
  company: _companyController.text,
  position: _positionController.text,
  skills: _skillsController.text,
  experience: _experienceController.text,
  tone: _selectedTone,
  ),
  ),
  );
  }
  }
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
  title: const Text('AI Cover Letter Generator'),
  backgroundColor: Colors.transparent,
  elevation: 0,
  ),
  body: SingleChildScrollView(
  padding: const EdgeInsets.all(16.0),
  child: Form(
  key: _formKey,
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  // Header Banner
  Container(
  width: double.infinity,
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
  gradient: const LinearGradient(
  colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  ),
  borderRadius: BorderRadius.circular(16),
  boxShadow: [
  BoxShadow(
  color: Colors.orange.withOpacity(0.3),
  blurRadius: 10,
  offset: const Offset(0, 4),
  ),
  ],
  ),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Row(
  children: [
  Container(
  padding: const EdgeInsets.all(10),
  decoration: BoxDecoration(
  color: Colors.white.withOpacity(0.2),
  borderRadius: BorderRadius.circular(12),
  ),
  child: const Icon(
  Icons.description,
  color: Colors.white,
  size: 30,
  ),
  ),
  const SizedBox(width: 16),
  const Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Text(
  'AI Cover Letter Generator',
  style: TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  ),
  ),
  SizedBox(height: 4),
  Text(
  'Personalized for your target role',
  style: TextStyle(
  fontSize: 14,
  color: Colors.white70,
  ),
  ),
  ],
  ),
  ],
  ),
  const SizedBox(height: 16),
  const Text(
  'Create a tailored cover letter that highlights your skills and experience for the specific job you\'re applying for.',
  style: TextStyle(
  fontSize: 14,
  color: Colors.white,
  height: 1.5,
  ),
  ),
  ],
  ),
  ),
  const SizedBox(height: 24),

  // Personal Information
  const Text(
  'Personal Information',
  style: TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  ),
  ),
  const SizedBox(height: 16),
  TextFormField(
  controller: _nameController,
  decoration: const InputDecoration(
  labelText: 'Full Name *',
  border: OutlineInputBorder(),
  prefixIcon: Icon(Icons.person_outline),
  ),
  validator: (value) {
  if (value == null || value.isEmpty) {
  return 'Please enter your full name';
  }
  return null;
  },
  ),
  const SizedBox(height: 16),
  TextFormField(
  controller: _emailController,
  decoration: const InputDecoration(
  labelText: 'Email Address *',
  border: OutlineInputBorder(),
  prefixIcon: Icon(Icons.email_outlined),
  ),
  validator: (value) {
  if (value == null || value.isEmpty) {
  return 'Please enter your email';
  }
  return null;
  },
  ),
  const SizedBox(height: 16),
  TextFormField(
  controller: _phoneController,
  decoration: const InputDecoration(
  labelText: 'Phone Number',
  border: OutlineInputBorder(),
  prefixIcon: Icon(Icons.phone_outlined),
  ),
  ),
  const SizedBox(height: 24),

  // Job Details
  const Text(
  'Job Details',
  style: TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  ),
  ),
  const SizedBox(height: 16),
  TextFormField(
  controller: _companyController,
  decoration: const InputDecoration(
  labelText: 'Company Name *',
  border: OutlineInputBorder(),
  prefixIcon: Icon(Icons.business_outlined),
  ),
  validator: (value) {
  if (value == null || value.isEmpty) {
  return 'Please enter the company name';
  }
  return null;
  },
  ),
  const SizedBox(height: 16),
  TextFormField(
  controller: _positionController,
  decoration: const InputDecoration(
  labelText: 'Position/Job Title *',
  border: OutlineInputBorder(),
  prefixIcon: Icon(Icons.work_outline),
  ),
  validator: (value) {
  if (value == null || value.isEmpty) {
  return 'Please enter the position';
  }
  return null;
  },
  ),
  const SizedBox(height: 24),

  // Skills and Experience
  const Text(
  'Skills & Experience',
  style: TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  ),
  ),
  const SizedBox(height: 16),
  TextFormField(
  controller: _skillsController,
  decoration: const InputDecoration(
  labelText: 'Key Skills *',
  border: OutlineInputBorder(),
  prefixIcon: Icon(Icons.star_outline),
  hintText: 'e.g., Project Management, Python, Communication...',
  ),
  validator: (value) {
  if (value == null || value.isEmpty) {
  return 'Please enter your key skills';
  }
  return null;
  },
  ),
  const SizedBox(height: 16),
  TextFormField(
  controller: _experienceController,
  decoration: const InputDecoration(
  labelText: 'Relevant Experience *',
  border: OutlineInputBorder(),
  prefixIcon: Icon(Icons.history),
  hintText: 'Briefly describe your relevant experience...',
  ),
  maxLines: 4,
  validator: (value) {
  if (value == null || value.isEmpty) {
  return 'Please enter your relevant experience';
  }
  return null;
  },
  ),
  const SizedBox(height: 24),

  // Tone Selection
  const Text(
  'Cover Letter Tone',
  style: TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  ),
  ),
  const SizedBox(height: 16),
  Container(
  height: 100,
  child: ListView.builder(
  scrollDirection: Axis.horizontal,
  itemCount: _tones.length,
  itemBuilder: (context, index) {
  final tone = _tones[index];
  final isSelected = _selectedTone == tone;
  return GestureDetector(
  onTap: () => setState(() => _selectedTone = tone),
  child: Container(
  width: 120,
  margin: const EdgeInsets.only(right: 12),
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
  color: isSelected ? Colors.orange.withOpacity(0.1) : Colors.grey[100],
  borderRadius: BorderRadius.circular(12),
  border: Border.all(
  color: isSelected ? Colors.orange : Colors.grey[300]!,
  width: isSelected ? 2 : 1,
  ),
  ),
  child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
  Icon(
  _getToneIcon(tone),
  color: isSelected ? Colors.orange : Colors.grey[600],
  ),
  const SizedBox(height: 8),
  Text(
  tone,
  style: TextStyle(
  fontSize: 14,
  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
  color: isSelected ? Colors.orange : Colors.grey[700],
  ),
  ),
  ],
  ),
  ),
  );
  },
  ),
  ),
  const SizedBox(height: 32),

  // Generate Button
  SizedBox(
  width: double.infinity,
  height: 56,
  child: ElevatedButton(
  onPressed: _isGenerating ? null : _generateCoverLetter,
  style: ElevatedButton.styleFrom(
  backgroundColor: Colors.orange,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(12),
  ),
  ),
  child: _isGenerating
  ? Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: const [
  SizedBox(
  width: 20,
  height: 20,
  child: CircularProgressIndicator(
  strokeWidth: 2,
  color: Colors.white,
  ),
  ),
  SizedBox(width: 12),
  Text('Generating Cover Letter...'),
  ],
  )
      : Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: const [
  Icon(Icons.auto_awesome),
  SizedBox(width: 8),
  Text(
  'Generate AI Cover Letter',
  style: TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  ),
  ),
  ],
  ),
  ),
  ),
  const SizedBox(height: 16),

  // Tips Card
  Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
  color: Colors.blue[50],
  borderRadius: BorderRadius.circular(12),
  border: Border.all(color: Colors.blue[200]!),
  ),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Row(
  children: [
  Icon(Icons.lightbulb, color: Colors.blue[700]),
  const SizedBox(width: 8),
  const Text(
  'Cover Letter Tips',
  style: TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.black87,
  ),
  ),
  ],
  ),
  const SizedBox(height: 12),
  _buildTipItem('Customize for each job application'),
  _buildTipItem('Address the hiring manager by name if possible'),
  _buildTipItem('Keep it concise - one page maximum'),
  _buildTipItem('Highlight achievements, not just responsibilities'),
  ],
  ),
  ),
  ],
  ),
  ),
  ),
  );
  }

  IconData _getToneIcon(String tone) {
  switch (tone) {
  case 'Professional':
  return Icons.business_center;
  case 'Enthusiastic':
  return Icons.emoji_emotions;
  case 'Formal':
  return Icons.account_balance;
  case 'Creative':
  return Icons.palette;
  default:
  return Icons.description;
  }
  }

  Widget _buildTipItem(String tip) {
  return Padding(
  padding: const EdgeInsets.only(bottom: 8),
  child: Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Container(
  width: 6,
  height: 6,
  margin: const EdgeInsets.only(top: 6, right: 8),
  decoration: BoxDecoration(
  color: Colors.blue[700],
  shape: BoxShape.circle,
  ),
  ),
  Expanded(
  child: Text(
  tip,
  style: const TextStyle(fontSize: 14, height: 1.4),
  ),
  ),
  ],
  ),
  );
  }
  }

  class CoverLetterPreviewPage extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String company;
  final String position;
  final String skills;
  final String experience;
  final String tone;

  const CoverLetterPreviewPage({
  Key? key,
  required this.name,
  required this.email,
  required this.phone,
  required this.company,
  required this.position,
  required this.skills,
  required this.experience,
  required this.tone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
  title: const Text('Cover Letter Preview'),
  backgroundColor: Colors.transparent,
  elevation: 0,
  actions: [
  IconButton(
  icon: const Icon(Icons.edit),
  onPressed: () {
  Navigator.pop(context);
  },
  ),
  IconButton(
  icon: const Icon(Icons.download),
  onPressed: () {
  ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
  content: Text('Cover letter downloaded as PDF!'),
  backgroundColor: Colors.green,
  ),
  );
  },
  ),
  ],
  ),
  body: SingleChildScrollView(
  padding: const EdgeInsets.all(16.0),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  // Cover Letter Container
  Container(
  width: double.infinity,
  padding: const EdgeInsets.all(24),
  decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12),
  boxShadow: [
  BoxShadow(
  color: Colors.grey.withOpacity(0.2),
  blurRadius: 10,
  offset: const Offset(0, 4),
  ),
  ],
  ),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  // Header with name and contact info
  Text(
  name,
  style: const TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Color(0xFF1E3A8A),
  ),
  ),
  const SizedBox(height: 8),
  Text(
  email,
  style: const TextStyle(fontSize: 14),
  ),
  if (phone.isNotEmpty) Text(
  phone,
  style: const TextStyle(fontSize: 14),
  ),
  const SizedBox(height: 24),

  // Date
  Text(
  _getFormattedDate(),
  style: const TextStyle(fontSize: 14),
  ),
  const SizedBox(height: 16),

  // Recipient
  const Text(
  'Hiring Manager',
  style: TextStyle(fontSize: 14),
  ),
  Text(
  company,
  style: const TextStyle(fontSize: 14),
  ),
  const SizedBox(height: 24),

  // Salutation
  const Text(
  'Dear Hiring Manager,',
  style: TextStyle(fontSize: 16),
  ),
  const SizedBox(height: 16),

  // Opening paragraph
  Text(
  _getOpeningParagraph(),
  style: const TextStyle(fontSize: 14, height: 1.5),
  ),
  const SizedBox(height: 16),

  // Body paragraph about skills
  Text(
  _getSkillsParagraph(),
  style: const TextStyle(fontSize: 14, height: 1.5),
  ),
  const SizedBox(height: 16),

  // Body paragraph about experience
  Text(
  _getExperienceParagraph(),
  style: const TextStyle(fontSize: 14, height: 1.5),
  ),
  const SizedBox(height: 16),

  // Closing paragraph
  Text(
  _getClosingParagraph(),
  style: const TextStyle(fontSize: 14, height: 1.5),
  ),
  const SizedBox(height: 24),

  // Signature


   // Signature
  const Text(
  'Sincerely,',
  style: TextStyle(fontSize: 14),
  ),
  const SizedBox(height: 16),
  Text(
  name,
  style: const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  ),
  ),
  ],
  ),
  ),
  const SizedBox(height: 24),

  // AI Analysis Card
  Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
  color: Colors.green[50],
  borderRadius: BorderRadius.circular(12),
  border: Border.all(color: Colors.green[200]!),
  ),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Row(
  children: [
  Icon(Icons.check_circle, color: Colors.green[700]),
  const SizedBox(width: 8),
  const Text(
  'AI Analysis',
  style: TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.black87,
  ),
  ),
  ],
  ),
  const SizedBox(height: 12),
  const Text(
  'This cover letter is optimized for your target role. It highlights your relevant skills and experience while maintaining a professional tone.',
  style: TextStyle(
  fontSize: 14,
  height: 1.5,
  color: Colors.black87,
  ),
  ),
  const SizedBox(height: 12),
  Row(
  children: [
  _buildAnalysisItem('Relevance', 95),
  const SizedBox(width: 16),
  _buildAnalysisItem('Clarity', 90),
  const SizedBox(width: 16),
  _buildAnalysisItem('Tone', 92),
  ],
  ),
  ],
  ),
  ),
  const SizedBox(height: 24),

  // Action Buttons
  Row(
  children: [
  Expanded(
  child: OutlinedButton.icon(
  onPressed: () {
  // Share cover letter
  ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
  content: Text('Cover letter shared successfully!'),
  backgroundColor: Colors.green,
  ),
  );
  },
  icon: const Icon(Icons.share),
  label: const Text('Share'),
  style: OutlinedButton.styleFrom(
  padding: const EdgeInsets.symmetric(vertical: 16),
  ),
  ),
  ),
  const SizedBox(width: 16),
  Expanded(
  child: ElevatedButton.icon(
  onPressed: () {
  // Download as PDF
  ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
  content: Text('Cover letter downloaded as PDF!'),
  backgroundColor: Colors.green,
  ),
  );
  },
  icon: const Icon(Icons.download),
  label: const Text('Download PDF'),
  style: ElevatedButton.styleFrom(
  padding: const EdgeInsets.symmetric(vertical: 16),
  ),
  ),
  ),
  ],
  ),
  ],
  ),
  ),
  );
  }

  String _getFormattedDate() {
  final now = DateTime.now();
  final months = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December'
  ];
  return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  String _getOpeningParagraph() {
  switch (tone) {
  case 'Professional':
  return 'I am writing to express my interest in the $position position at $company. With a background in ${skills.split(',')[0]} and ${experience.split(' ')[0]} years of experience in the field, I am confident in my ability to contribute effectively to your team.';
  case 'Enthusiastic':
  return 'I am thrilled to apply for the $position role at $company! As someone passionate about ${skills.split(',')[0]} with ${experience.split(' ')[0]} years of hands-on experience, Im excited about the opportunity to bring my energy and expertise to your innovative team.';
  case 'Formal':
  return 'Please accept my application for the $position position advertised at $company. Having accumulated ${experience.split(' ')[0]} years of relevant experience and developed expertise in ${skills.split(',')[0]}, I believe my qualifications align well with the requirements of this role.';
  case 'Creative':
  return 'Imagine having a team member who combines ${experience.split(' ')[0]} years of experience with a passion for ${skills.split(',')[0]}. That s exactly what I bring to the table as a candidate for the $position role at $company.';
  default:
  return 'I am writing to apply for the $position position at $company. With my background in ${skills.split(',')[0]} and relevant experience, I am excited about the opportunity to join your team.';
  }
  }

  String _getSkillsParagraph() {
  final skillsList = skills.split(',').take(3).join(', ');

  switch (tone) {
  case 'Professional':
  return 'My expertise includes $skillsList, which I believe directly align with the requirements of this position. I have consistently applied these skills to deliver measurable results in my previous roles.';
  case 'Enthusiastic':
  return 'I m particularly excited to bring my skills in $skillsList'
  'to your team! These competencies have allowed me to make significant contributions in my previous positions, and i m eager to apply them to the challenges at $company.';
  case 'Formal':
  return 'The position requires proficiency in $skillsList, areas in which I have demonstrated considerable aptitude throughout my career. These skills have enabled me to perform effectively and contribute substantively to organizational objectives.';
  case 'Creative':
  return 'My toolkit includes $skillsList – the perfect combination for tackling the unique challenges of the $position '
  'role. These   just bullet points on my resume; they re passions Ive cultivated and applied to create real impact.';
  default:
  return 'My skills in $skillsList are well-suited for this position. I have used these abilities to achieve positive outcomes in my previous work.';
  }
  }

  String _getExperienceParagraph() {
  switch (tone) {
  case 'Professional':
  return 'In my previous roles, I have $experience. This experience has prepared me to understand the challenges and opportunities in the $position role at $company, and I am confident in my ability to make immediate contributions.';
  case 'Enthusiastic':
  return 'Throughout my career, Ive had the amazing opportunity to $experience. These experiences have given me valuable insights that i m excited to bring to the $position role at your company!';
  case 'Formal':
  return 'My professional history includes $experience. This background has equipped me with the necessary perspective and capabilities to fulfill the responsibilities of the $position position at $company with competence and diligence.';
  case 'Creative':
  return 'My journey has taken me through experiences where I $experience. Each step has been a building block, shaping me into the ideal candidate for the $position role at $company.';
  default:
  return 'My experience includes $experience. This background has prepared me well for the $position role at your company.';
  }
  }

  String _getClosingParagraph() {
  switch (tone) {
  case 'Professional':
  return 'I would welcome the opportunity to discuss how my background, skills, and experience would be beneficial to $company. Thank you for considering my application. I look forward to the possibility of working with your team.';
  case 'Enthusiastic':
  return 'I would love the chance to discuss how my skills and passion can contribute to $company'
  's success! Thank you so much for considering my application, and Im looking forward to potentially joining your amazing team!';
  case 'Formal':
  return 'I would appreciate the opportunity to further discuss my qualifications for the $position position at $company. Thank you for your consideration of my application. I await your response regarding the possibility of an interview.';
  case 'Creative':
  return 'Id be delighted to share more about how my unique perspective and skills could add a new dimension to $company'
  'Thank you for considering my application – Im eager to explore how we might create something extraordinary together.';
  default:
  return 'I would appreciate the opportunity to discuss my application further. Thank you for your consideration, and I look forward to hearing from you.';
  }
  }

  Widget _buildAnalysisItem(String label, int score) {
  return Expanded(
  child: Column(
  children: [
  Stack(
  alignment: Alignment.center,
  children: [
  SizedBox(
  width: 50,
  height: 50,
  child: CircularProgressIndicator(
  value: score / 100,
  strokeWidth: 5,
  backgroundColor: Colors.grey[200],
  valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]!),
  ),
  ),
  Text(
  '$score%',
  style: TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
  color: Colors.green[700],
  ),
  ),
  ],
  ),
  const SizedBox(height: 4),
  Text(
  label,
  style: TextStyle(
  fontSize: 12,
  color: Colors.grey[700],
  ),
  ),
  ],
  ),
  );
  }
  }
   class CareerTipsPage extends StatefulWidget {
  const CareerTipsPage({Key? key}) : super(key: key);

  @override
  State<CareerTipsPage> createState() => _CareerTipsPageState();
  }

  class _CareerTipsPageState extends State<CareerTipsPage> with SingleTickerProviderStateMixin {
    late TabController _tabController;
    final List<String> _categories = [
      'All',
      'Resume',
      'Interview',
      'Networking',
      'Job Search',
      'Career Growth'
    ];

    @override
    void initState() {
      super.initState();
      _tabController = TabController(length: _categories.length, vsync: this);
    }

    @override
    void dispose() {
      _tabController.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Career Tips'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Theme
                .of(context)
                .primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme
                .of(context)
                .primaryColor,
            tabs: _categories.map((category) => Tab(text: category)).toList(),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: _categories.map((category) {
            return _buildTipsList(category);
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Show AI personalized tip generator
            _showAITipGenerator();
          },
          backgroundColor: Theme
              .of(context)
              .primaryColor,
          child: const Icon(Icons.psychology),
          tooltip: 'Get AI Personalized Tips',
        ),
      );
    }

    Widget _buildTipsList(String category) {
      // Filter tips based on category
      List<Map<String, dynamic>> tips = _getAllTips();
      if (category != 'All') {
        tips = tips.where((tip) => tip['category'] == category).toList();
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tips.length + 1, // +1 for the header
        itemBuilder: (context, index) {
          if (index == 0) {
            // Header section
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.lightbulb,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Career Tips & Advice',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Expert insights for your career journey',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Browse our curated collection of career tips to help you navigate your professional journey with confidence.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  category == 'All' ? 'All Tips' : '$category Tips',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          }

          // Tip cards
          final tip = tips[index - 1];
          return _buildTipCard(tip);
        },
      );
    }

    Widget _buildTipCard(Map<String, dynamic> tip) {
      Color categoryColor;
      IconData categoryIcon;

      switch (tip['category']) {
        case 'Resume':
          categoryColor = Colors.blue;
          categoryIcon = Icons.description;
          break;
        case 'Interview':
          categoryColor = Colors.green;
          categoryIcon = Icons.record_voice_over;
          break;
        case 'Networking':
          categoryColor = Colors.purple;
          categoryIcon = Icons.people;
          break;
        case 'Job Search':
          categoryColor = Colors.orange;
          categoryIcon = Icons.search;
          break;
        case 'Career Growth':
          categoryColor = Colors.red;
          categoryIcon = Icons.trending_up;
          break;
        default:
          categoryColor = Colors.grey;
          categoryIcon = Icons.lightbulb;
      }

      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Container(
                   ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tip image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(
                  tip['imageUrl'],
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 50,
                            color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(categoryIcon, size: 14, color: categoryColor),
                          const SizedBox(width: 4),
                          Text(
                            tip['category'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: categoryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Title
                    Text(
                      tip['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Description
                    Text(
                      tip['description'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    // Author and date
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.grey[200],
                          child: Text(
                            tip['author'][0],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          tip['author'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          tip['date'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    void _showAITipGenerator() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery
                  .of(context)
                  .viewInsets
                  .bottom,
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Get Personalized Career Tips',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Ask our AI for personalized career advice based on your specific situation.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'E.g., How do I negotiate a salary increase?',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.psychology),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Show loading and then navigate to AI response
                      _showAIGeneratingDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.indigo,
                    ),
                    child: const Text('Generate AI Advice'),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      );
    }

    void _showAIGeneratingDialog() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Generating Personalized Advice',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Our AI is analyzing your question and creating tailored career advice...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      );

      // Simulate AI generation
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pop(context); // Close dialog
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
              Container(
             ),

          ),
        );
      });
    }

    List<Map<String, dynamic>> _getAllTips() {
      return [
        {
          'id': '1',
          'title': '10 Resume Tips to Get You Noticed by Recruiters',
          'description': 'Learn how to craft a resume that stands out from the crowd and catches the attention of hiring managers.',
          'category': 'Resume',
          'author': 'Emily Johnson',
          'date': 'May 15, 2023',
          'imageUrl': 'https://images.unsplash.com/photo-1586281380349-632531db7ed4?ixlib=rb-4.0.3',
          'content': '''
# 10 Resume Tips to Get You Noticed by Recruiters

In today's competitive job market, having a well-crafted resume is essential to stand out from the crowd. Recruiters often spend just 6-7 seconds scanning a resume before deciding whether to consider the candidate further. Here are ten proven tips to make your resume catch the attention of hiring managers:

## 1. Tailor Your Resume for Each Job Application

One of the most effective strategies is to customize your resume for each position you apply for. Analyze the job description and incorporate relevant keywords and skills that match the requirements. This not only helps you pass through Applicant Tracking Systems (ATS) but also shows recruiters that you're a good fit for the specific role.

## 2. Start with a Strong Professional Summary

Replace the outdated "objective statement" with a powerful professional summary that highlights your
// Career Tips Page
class CareerTipsPage extends StatefulWidget {
  const CareerTipsPage({Key? key}) : super(key: key);

  @override
  State<CareerTipsPage> createState() => _CareerTipsPageState();
}

class _CareerTipsPageState extends State<CareerTipsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = [
    'All',
    'Resume',
    'Interview',
    'Networking',
    'Job Search',
    'Career Growth'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Tips'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor,
          tabs: _categories.map((category) => Tab(text: category)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _categories.map((category) {
          return _buildTipsList(category);
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show AI personalized tip generator
          _showAITipGenerator();
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.psychology),
        tooltip: 'Get AI Personalized Tips',
      ),
    );
  }

  Widget _buildTipsList(String category) {
    // Filter tips based on category
    List<Map<String, dynamic>> tips = _getAllTips();
    if (category != 'All') {
      tips = tips.where((tip) => tip['category'] == category).toList();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tips.length + 1, // +1 for the header
      itemBuilder: (context, index) {
        if (index == 0) {
          // Header section
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.lightbulb,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Career Tips & Advice',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Expert insights for your career journey',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Browse our curated collection of career tips to help you navigate your professional journey with confidence.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                category == 'All' ? 'All Tips' : 'category Tips',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        }

        // Tip cards
        final tip = tips[index - 1];
        return _buildTipCard(tip);
      },
    );
  }

  Widget _buildTipCard(Map<String, dynamic> tip) {
    Color categoryColor;
    IconData categoryIcon;

    switch (tip['category']) {
      case 'Resume':
        categoryColor = Colors.blue;
        categoryIcon = Icons.description;
        break;
      case 'Interview':
        categoryColor = Colors.green;
        categoryIcon = Icons.record_voice_over;
        break;
      case 'Networking':
        categoryColor = Colors.purple;
        categoryIcon = Icons.people;
        break;
      case 'Job Search':
        categoryColor = Colors.orange;
        categoryIcon = Icons.search;
        break;
      case 'Career Growth':
        categoryColor = Colors.red;
        categoryIcon = Icons.trending_up;
        break;
      default:
        categoryColor = Colors.grey;
        categoryIcon = Icons.lightbulb;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TipDetailPage(tip: tip),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tip image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.network(
                tip['imageUrl'],
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(categoryIcon, size: 14, color: categoryColor),
                        const SizedBox(width: 4),
                        Text(
                          tip['category'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: categoryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Title
                  Text(
                    tip['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Description
                  Text(
                    tip['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  // Author and date
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.grey[200],
                        child: Text(
                          tip['author'][0],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        tip['author'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        tip['date'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAITipGenerator() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Get Personalized Career Tips',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ask our AI for personalized career advice based on your specific situation.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'E.g., How do I negotiate a salary increase?',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.psychology),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Show loading and then navigate to AI response
                    _showAIGeneratingDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.indigo,
                  ),
                  child: const Text('Generate AI Advice'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showAIGeneratingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Generating Personalized Advice',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Our AI is analyzing your question and creating tailored career advice...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );

    // Simulate AI generation
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context); // Close dialog
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AIAdvicePage(
            question: 'How do I negotiate a salary increase?',
          ),
        ),
      );
    });
  }

  List<Map<String, dynamic>> _getAllTips() {
    return [
      {
        'id': '1',
        'title': '10 Resume Tips to Get You Noticed by Recruiters',
        'description': 'Learn how to craft a resume that stands out from the crowd and catches the attention of hiring managers.',
        'category': 'Resume',
        'author': 'Emily Johnson',
        'date': 'May 15, 2023',
        'imageUrl': 'https://images.unsplash.com/photo-1586281380349-632531db7ed4?ixlib=rb-4.0.3',
        'content': '''
        }
      ];
    }


  }