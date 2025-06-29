// lib/core/utils/logger.dart
import 'package:flutter/foundation.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
  fatal,
}

class Logger {
  static const String _name = 'AICareerAssistant';
  static LogLevel _minimumLevel = kDebugMode ? LogLevel.debug : LogLevel.info;

  static void setMinimumLevel(LogLevel level) {
    _minimumLevel = level;
  }

  static void debug(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.debug, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  static void info(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.info, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  static void warning(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.warning, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  static void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  static void fatal(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.fatal, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  static void _log(
      LogLevel level,
      String message, {
        String? tag,
        Object? error,
        StackTrace? stackTrace,
      }) {
    if (level.index < _minimumLevel.index) return;

    final timestamp = DateTime.now().toIso8601String();
    final levelStr = level.toString().split('.').last.toUpperCase();
    final tagStr = tag != null ? '[$tag]' : '';

    String logMessage = '[$timestamp] $levelStr: $_name$tagStr $message';

    if (error != null) {
      logMessage += '\nError: $error';
    }

    if (stackTrace != null) {
      logMessage += '\nStackTrace: $stackTrace';
    }

    // In debug mode, use debugPrint for better visibility
    if (kDebugMode) {
      debugPrint(logMessage);
    } else {
      print(logMessage);
    }

    // In production, you might want to send logs to a remote service
    if (kReleaseMode && (level == LogLevel.error || level == LogLevel.fatal)) {
      _sendToRemoteLoggingService(level, message, error, stackTrace);
    }
  }

  static void _sendToRemoteLoggingService(
      LogLevel level,
      String message,
      Object? error,
      StackTrace? stackTrace,
      ) {
    // Implement remote logging service integration here
    // Examples: Firebase Crashlytics, Sentry, Bugsnag, etc.
  }

  // Convenience methods for common scenarios
  static void logApiCall(String endpoint, {Map<String, dynamic>? params}) {
    info('API Call: $endpoint${params != null ? ' with params: $params' : ''}', tag: 'API');
  }

  static void logApiResponse(String endpoint, int statusCode, {String? responseTime}) {
    info('API Response: $endpoint - Status: $statusCode${responseTime != null ? ' (${responseTime}ms)' : ''}', tag: 'API');
  }

  static void logApiError(String endpoint, Object error, {StackTrace? stackTrace}) {
    Logger.error('API Error: $endpoint', tag: 'API', error: error, stackTrace: stackTrace);
  }

  static void logUserAction(String action, {Map<String, dynamic>? context}) {
    info('User Action: $action${context != null ? ' - Context: $context' : ''}', tag: 'USER');
  }

  static void logNavigation(String from, String to) {
    debug('Navigation: $from -> $to', tag: 'NAV');
  }

  static void logPerformance(String operation, Duration duration) {
    info('Performance: $operation took ${duration.inMilliseconds}ms', tag: 'PERF');
  }

  static void logCacheHit(String key) {
    debug('Cache Hit: $key', tag: 'CACHE');
  }

  static void logCacheMiss(String key) {
    debug('Cache Miss: $key', tag: 'CACHE');
  }

  static void logAuthEvent(String event, {String? userId}) {
    info('Auth Event: $event${userId != null ? ' for user: $userId' : ''}', tag: 'AUTH');
  }

  static void logAIRequest(String service, String prompt) {
    info('AI Request: $service - Prompt length: ${prompt.length} chars', tag: 'AI');
  }

  static void logAIResponse(String service, String response, {Duration? processingTime}) {
    info('AI Response: $service - Response length: ${response.length} chars${processingTime != null ? ' (${processingTime.inMilliseconds}ms)' : ''}', tag: 'AI');
  }

  static void logFileOperation(String operation, String filename, {int? size}) {
    info('File Operation: $operation - $filename${size != null ? ' (${size} bytes)' : ''}', tag: 'FILE');
  }

  static void logSubscriptionEvent(String event, {String? plan, String? userId}) {
    info('Subscription Event: $event${plan != null ? ' - Plan: $plan' : ''}${userId != null ? ' - User: $userId' : ''}', tag: 'SUB');
  }
}