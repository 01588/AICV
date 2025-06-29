class AppConfig {
  static const String appName = 'AI Career Assistant';
  static const String appVersion = '1.0.0';
  static const bool isProduction = false;

  // API Keys (should be loaded from environment or secure storage)
  static const String openAIApiKey = 'YOUR_OPENAI_API_KEY';
  static const String claudeApiKey = 'YOUR_CLAUDE_API_KEY';
  static const String stripePublishableKey = 'YOUR_STRIPE_PUBLISHABLE_KEY';
  static const String revenueCatAppleApiKey = 'YOUR_REVENUECAT_APPLE_API_KEY';
  static const String revenueCatGoogleApiKey = 'YOUR_REVENUECAT_GOOGLE_API_KEY';

  // API Endpoints
  static const String baseUrl = isProduction
      ? 'https://api.aicareerassistant.com'
      : 'https://dev-api.aicareerassistant.com';

  // Subscription Plans
  static const String monthlyPlanId = 'monthly_premium';
  static const String yearlyPlanId = 'yearly_premium';
  static const double monthlyPrice = 9.99;
  static const double yearlyPrice = 79.99;

  // Feature Limits
  static const int freeResumeLimit = 2;
  static const int freeInterviewLimit = 5;
  static const int freeCoverLetterLimit = 1;

  // Firebase Config
  static const String firebaseProjectId = 'ai-career-assistant';
  static const String firebaseWebApiKey = 'YOUR_FIREBASE_WEB_API_KEY';

  // App Settings
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> supportedImageFormats = ['jpg', 'jpeg', 'png'];
  static const List<String> supportedDocumentFormats = ['pdf', 'doc', 'docx'];
}