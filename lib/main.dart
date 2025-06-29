// lib/main.dart
import 'package:ai_career_assistant/services/analytics_service.dart';
import 'package:ai_career_assistant/services/api_service.dart';
import 'package:ai_career_assistant/services/notification_service.dart';
import 'package:ai_career_assistant/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Core providers
import 'core/providers/auth_provider.dart';
import 'core/providers/user_provider.dart';
import 'core/providers/subscription_provider.dart';
import 'core/providers/theme_provider.dart';

// Core services
import 'core/services/api_service.dart';
import 'core/services/analytics_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/storage_service.dart';

// Screens
import 'features/splash/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize core services
  final storageService = StorageService();
  await storageService.initialize();

  final analyticsService = AnalyticsService();
  await analyticsService.initialize();

  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(AICareerAssistantApp(
    storageService: storageService,
    analyticsService: analyticsService,
    notificationService: notificationService,
  ));
}

class AICareerAssistantApp extends StatelessWidget {
  final StorageService storageService;
  final AnalyticsService analyticsService;
  final NotificationService notificationService;

  const AICareerAssistantApp({
    Key? key,
    required this.storageService,
    required this.analyticsService,
    required this.notificationService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return MultiProvider(
      providers: [
        // Services
        Provider<StorageService>.value(value: storageService),
        Provider<AnalyticsService>.value(value: analyticsService),
        Provider<NotificationService>.value(value: notificationService),
        Provider<ApiService>.value(value: apiService),

        // Providers
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider()..initialize(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            apiService: apiService,
            analyticsService: analyticsService,
          )..initialize(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, UserProvider>(
          create: (context) => UserProvider(
            apiService: apiService,
            analyticsService: analyticsService,
          ),
          update: (context, auth, previous) {
            if (auth.isAuthenticated) {
              previous?.loadUserData();
            } else {
              previous?.clearUserData();
            }
            return previous ?? UserProvider(
              apiService: apiService,
              analyticsService: analyticsService,
            );
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, SubscriptionProvider>(
          create: (context) => SubscriptionProvider(
            apiService: apiService,
            analyticsService: analyticsService,
          ),
          update: (context, auth, previous) {
            if (auth.isAuthenticated) {
              previous?.loadSubscription();
            } else {
              previous?.clearSubscriptionData();
            }
            return previous ?? SubscriptionProvider(
              apiService: apiService,
              analyticsService: analyticsService,
            );
          },
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'AI Career Assistant',
            debugShowCheckedModeBanner: false,
            theme: ThemeProvider.lightTheme,
            darkTheme: ThemeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const SplashScreen(),
            onGenerateRoute: (settings) {
              // Add your route generation logic here
              switch (settings.name) {
                case '/':
                  return MaterialPageRoute(builder: (_) => const SplashScreen());
                default:
                  return MaterialPageRoute(builder: (_) => const SplashScreen());
              }
            },
          );
        },
      ),
    );
  }
}