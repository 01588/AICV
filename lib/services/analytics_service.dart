// lib/core/services/analytics_service.dart
import 'package:flutter/foundation.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  // Added static instance getter for backward compatibility
  static AnalyticsService get instance => _instance;

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

  // User action tracking - Added missing method
  Future<void> logUserAction(String action, {Map<String, dynamic>? context}) async {
    await logEvent('user_action', parameters: {
      'action': action,
      if (context != null) ...context,
    });
  }

  // Navigation tracking
  Future<void> logNavigation(String from, String to) async {
    await logEvent('navigation', parameters: {
      'from': from,
      'to': to,
    });
  }

  // Performance tracking
  Future<void> logPerformance(String operation, Duration duration) async {
    await logEvent('performance', parameters: {
      'operation': operation,
      'duration_ms': duration.inMilliseconds,
    });
  }

  // Cache tracking
  Future<void> logCacheHit(String key) async {
    await logEvent('cache_hit', parameters: {'key': key});
  }

  Future<void> logCacheMiss(String key) async {
    await logEvent('cache_miss', parameters: {'key': key});
  }

  // Auth event tracking
  Future<void> logAuthEvent(String event, {String? userId}) async {
    await logEvent('auth_event', parameters: {
      'event': event,
      if (userId != null) 'user_id': userId,
    });
  }

  // AI request tracking
  Future<void> logAIRequest(String service, String prompt) async {
    await logEvent('ai_request', parameters: {
      'service': service,
      'prompt_length': prompt.length,
    });
  }

  Future<void> logAIResponse(String service, String response, {Duration? processingTime}) async {
    await logEvent('ai_response', parameters: {
      'service': service,
      'response_length': response.length,
      if (processingTime != null) 'processing_time_ms': processingTime.inMilliseconds,
    });
  }

  // File operation tracking
  Future<void> logFileOperation(String operation, String filename, {int? size}) async {
    await logEvent('file_operation', parameters: {
      'operation': operation,
      'filename': filename,
      if (size != null) 'size_bytes': size,
    });
  }

  // Subscription event tracking
  Future<void> logSubscriptionEvent(String event, {String? plan, String? userId}) async {
    await logEvent('subscription_event', parameters: {
      'event': event,
      if (plan != null) 'plan': plan,
      if (userId != null) 'user_id': userId,
    });
  }

  // Error tracking
  Future<void> logError(String error, {String? context}) async {
    await logEvent('error_occurred', parameters: {
      'error_message': error,
      if (context != null) 'context': context,
    });
  }

  // Custom event tracking with flexible parameters
  Future<void> trackEvent(String eventName, [Map<String, dynamic>? parameters]) async {
    await logEvent(eventName, parameters: parameters);
  }

  // Batch event tracking
  Future<void> logEvents(List<Map<String, dynamic>> events) async {
    for (final event in events) {
      final eventName = event['name'] as String;
      final parameters = event['parameters'] as Map<String, dynamic>?;
      await logEvent(eventName, parameters: parameters);
    }
  }

  // Session tracking
  Future<void> logSessionStart() async {
    await logEvent('session_start');
  }

  Future<void> logSessionEnd(Duration sessionDuration) async {
    await logEvent('session_end', parameters: {
      'duration_ms': sessionDuration.inMilliseconds,
    });
  }
}