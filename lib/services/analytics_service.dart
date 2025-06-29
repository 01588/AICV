// lib/core/services/analytics_service.dart
import 'package:flutter/foundation.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize analytics SDK here (Firebase Analytics, Mixpanel, etc.)
      _isInitialized = true;
      if (kDebugMode) {
        print('Analytics service initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to initialize analytics: $e');
      }
    }
  }

  Future<void> logEvent(String eventName, {Map<String, dynamic>? parameters}) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Log event to analytics service
      if (kDebugMode) {
        print('Analytics Event: $eventName${parameters != null ? ' - $parameters' : ''}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to log event $eventName: $e');
      }
    }
  }

  Future<void> setUserId(String userId) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Set user ID in analytics
      if (kDebugMode) {
        print('Analytics: Set user ID - $userId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to set user ID: $e');
      }
    }
  }

  Future<void> setUserProperty(String name, String value) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Set user property in analytics
      if (kDebugMode) {
        print('Analytics: Set user property - $name: $value');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to set user property: $e');
      }
    }
  }

  // Screen tracking
  Future<void> logScreenView(String screenName) async {
    await logEvent('screen_view', parameters: {'screen_name': screenName});
  }

  // Authentication events
  Future<void> logSignUp(String method) async {
    await logEvent('sign_up', parameters: {'method': method});
  }

  Future<void> logLogin(String method) async {
    await logEvent('login', parameters: {'method': method});
  }

  Future<void> logLogout() async {
    await logEvent('logout');
  }

  // Resume events
  Future<void> logResumeCreated(String template) async {
    await logEvent('resume_created', parameters: {'template': template});
  }

  Future<void> logResumeDownloaded(String format) async {
    await logEvent('resume_downloaded', parameters: {'format': format});
  }

  // Interview events
  Future<void> logInterviewStarted(String type, String role) async {
    await logEvent('interview_started', parameters: {
      'interview_type': type,
      'job_role': role,
    });
  }

  Future<void> logInterviewCompleted(String type, int score) async {
    await logEvent('interview_completed', parameters: {
      'interview_type': type,
      'score': score,
    });
  }

  // Cover letter events
  Future<void> logCoverLetterGenerated(String tone) async {
    await logEvent('cover_letter_generated', parameters: {'tone': tone});
  }

  // Subscription events
  Future<void> logSubscriptionUpgrade(String plan) async {
    await logEvent('subscription_upgrade', parameters: {'plan': plan});
  }

  Future<void> logSubscriptionCancel() async {
    await logEvent('subscription_cancel');
  }

  // Feature usage
  Future<void> logFeatureUsed(String feature) async {
    await logEvent('feature_used', parameters: {'feature_name': feature});
  }

  // Error tracking
  Future<void> logError(String error, {String? context}) async {
    await logEvent('error_occurred', parameters: {
      'error_message': error,
      if (context != null) 'context': context,
    });
  }
}