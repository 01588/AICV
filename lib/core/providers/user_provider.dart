// lib/core/providers/user_provider.dart
import 'package:flutter/foundation.dart';
import '../../services/analytics_service.dart';
import '../../services/api_service.dart';
import '../services/api_service.dart';
import '../services/analytics_service.dart';
import '../utils/exceptions.dart';
import 'auth_provider.dart';

class UserStats {
  final int resumesCreated;
  final int interviewsCompleted;
  final int coverLettersGenerated;
  final double averageInterviewScore;
  final int totalTimeSpentMinutes;
  final DateTime lastActivity;

  const UserStats({
    required this.resumesCreated,
    required this.interviewsCompleted,
    required this.coverLettersGenerated,
    required this.averageInterviewScore,
    required this.totalTimeSpentMinutes,
    required this.lastActivity,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      resumesCreated: json['resumesCreated'] as int,
      interviewsCompleted: json['interviewsCompleted'] as int,
      coverLettersGenerated: json['coverLettersGenerated'] as int,
      averageInterviewScore: (json['averageInterviewScore'] as num).toDouble(),
      totalTimeSpentMinutes: json['totalTimeSpentMinutes'] as int,
      lastActivity: DateTime.parse(json['lastActivity'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resumesCreated': resumesCreated,
      'interviewsCompleted': interviewsCompleted,
      'coverLettersGenerated': coverLettersGenerated,
      'averageInterviewScore': averageInterviewScore,
      'totalTimeSpentMinutes': totalTimeSpentMinutes,
      'lastActivity': lastActivity.toIso8601String(),
    };
  }
}

class UserPreferences {
  final String language;
  final bool notificationsEnabled;
  final bool emailUpdatesEnabled;
  final String preferredJobRole;
  final List<String> skillsOfInterest;
  final String experienceLevel;
  final bool darkModeEnabled;

  const UserPreferences({
    required this.language,
    required this.notificationsEnabled,
    required this.emailUpdatesEnabled,
    required this.preferredJobRole,
    required this.skillsOfInterest,
    required this.experienceLevel,
    required this.darkModeEnabled,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      language: json['language'] as String? ?? 'en',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      emailUpdatesEnabled: json['emailUpdatesEnabled'] as bool? ?? true,
      preferredJobRole: json['preferredJobRole'] as String? ?? '',
      skillsOfInterest: List<String>.from(json['skillsOfInterest'] as List? ?? []),
      experienceLevel: json['experienceLevel'] as String? ?? 'mid',
      darkModeEnabled: json['darkModeEnabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'notificationsEnabled': notificationsEnabled,
      'emailUpdatesEnabled': emailUpdatesEnabled,
      'preferredJobRole': preferredJobRole,
      'skillsOfInterest': skillsOfInterest,
      'experienceLevel': experienceLevel,
      'darkModeEnabled': darkModeEnabled,
    };
  }

  UserPreferences copyWith({
    String? language,
    bool? notificationsEnabled,
    bool? emailUpdatesEnabled,
    String? preferredJobRole,
    List<String>? skillsOfInterest,
    String? experienceLevel,
    bool? darkModeEnabled,
  }) {
    return UserPreferences(
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailUpdatesEnabled: emailUpdatesEnabled ?? this.emailUpdatesEnabled,
      preferredJobRole: preferredJobRole ?? this.preferredJobRole,
      skillsOfInterest: skillsOfInterest ?? this.skillsOfInterest,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
    );
  }
}

class UserProvider extends ChangeNotifier {
  final ApiService _apiService;
  final AnalyticsService _analyticsService;

  UserStats? _stats;
  UserPreferences? _preferences;
  bool _isLoading = false;
  String? _error;

  UserProvider({
    required ApiService apiService,
    required AnalyticsService analyticsService,
  })  : _apiService = apiService,
        _analyticsService = analyticsService;

  // Getters
  UserStats? get stats => _stats;
  UserPreferences? get preferences => _preferences;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load user data
  Future<void> loadUserData() async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.wait([
        loadUserStats(),
        loadUserPreferences(),
      ]);
    } catch (e) {
      _setError('Failed to load user data: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load user statistics
  Future<void> loadUserStats() async {
    try {
      final response = await _apiService.get('/user/stats');
      _stats = UserStats.fromJson(response['stats']);
      notifyListeners();
    } catch (e) {
      throw UserException('Failed to load user stats: $e');
    }
  }

  // Load user preferences
  Future<void> loadUserPreferences() async {
    try {
      final response = await _apiService.get('/user/preferences');
      _preferences = UserPreferences.fromJson(response['preferences']);
      notifyListeners();
    } catch (e) {
      throw UserException('Failed to load user preferences: $e');
    }
  }

  // Update user preferences
  Future<void> updatePreferences(UserPreferences newPreferences) async {
    _setLoading(true);
    _setError(null);

    try {
      await _apiService.put('/user/preferences', body: newPreferences.toJson());
      _preferences = newPreferences;

      await _analyticsService.logEvent('preferences_updated', parameters: {
        'language': newPreferences.language,
        'notifications_enabled': newPreferences.notificationsEnabled,
        'dark_mode_enabled': newPreferences.darkModeEnabled,
      });

      notifyListeners();
    } catch (e) {
      _setError('Failed to update preferences: $e');
      throw UserException('Failed to update preferences: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Update specific preference
  Future<void> updatePreference(String key, dynamic value) async {
    if (_preferences == null) return;

    UserPreferences updatedPreferences;

    switch (key) {
      case 'language':
        updatedPreferences = _preferences!.copyWith(language: value as String);
        break;
      case 'notificationsEnabled':
        updatedPreferences = _preferences!.copyWith(notificationsEnabled: value as bool);
        break;
      case 'emailUpdatesEnabled':
        updatedPreferences = _preferences!.copyWith(emailUpdatesEnabled: value as bool);
        break;
      case 'preferredJobRole':
        updatedPreferences = _preferences!.copyWith(preferredJobRole: value as String);
        break;
      case 'skillsOfInterest':
        updatedPreferences = _preferences!.copyWith(skillsOfInterest: value as List<String>);
        break;
      case 'experienceLevel':
        updatedPreferences = _preferences!.copyWith(experienceLevel: value as String);
        break;
      case 'darkModeEnabled':
        updatedPreferences = _preferences!.copyWith(darkModeEnabled: value as bool);
        break;
      default:
        throw ArgumentError('Unknown preference key: $key');
    }

    await updatePreferences(updatedPreferences);
  }

  // Update profile picture
  Future<void> updateProfilePicture(String imagePath) async {
    _setLoading(true);
    _setError(null);

    try {
      // In a real implementation, you'd upload the image file
      final response = await _apiService.post('/user/profile-picture', body: {
        'imagePath': imagePath,
      });

      await _analyticsService.logEvent('profile_picture_updated');

      notifyListeners();
    } catch (e) {
      _setError('Failed to update profile picture: $e');
      throw UserException('Failed to update profile picture: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Delete user account
  Future<void> deleteAccount() async {
    _setLoading(true);
    _setError(null);

    try {
      await _apiService.delete('/user/account');

      await _analyticsService.logEvent('account_deleted');

      // Clear all user data
      _stats = null;
      _preferences = null;

      notifyListeners();
    } catch (e) {
      _setError('Failed to delete account: $e');
      throw UserException('Failed to delete account: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Export user data
  Future<Map<String, dynamic>> exportUserData() async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _apiService.get('/user/export');

      await _analyticsService.logEvent('data_exported');

      return response['data'];
    } catch (e) {
      _setError('Failed to export user data: $e');
      throw UserException('Failed to export user data: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Track user activity
  Future<void> trackActivity(String activity, {Map<String, dynamic>? metadata}) async {
    try {
      await _apiService.post('/user/activity', body: {
        'activity': activity,
        'timestamp': DateTime.now().toIso8601String(),
        if (metadata != null) 'metadata': metadata,
      });

      await _analyticsService.logUserAction(activity, context: metadata);
    } catch (e) {
      // Don't throw errors for activity tracking
      if (kDebugMode) {
        print('Failed to track activity: $e');
      }
    }
  }

  // Update usage statistics
  Future<void> updateUsageStats({
    bool? resumeCreated,
    bool? interviewCompleted,
    bool? coverLetterGenerated,
    double? interviewScore,
    int? timeSpentMinutes,
  }) async {
    try {
      await _apiService.post('/user/usage-stats', body: {
        if (resumeCreated == true) 'resumeCreated': true,
        if (interviewCompleted == true) 'interviewCompleted': true,
        if (coverLetterGenerated == true) 'coverLetterGenerated': true,
        if (interviewScore != null) 'interviewScore': interviewScore,
        if (timeSpentMinutes != null) 'timeSpentMinutes': timeSpentMinutes,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Refresh stats after update
      await loadUserStats();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to update usage stats: $e');
      }
    }
  }

  // Clear user data (for logout)
  void clearUserData() {
    _stats = null;
    _preferences = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }
}

// Custom exception for user-related errors
class UserException extends AppException {
  const UserException(String message, [String? code]) : super(message, code);

  @override
  String toString() => 'UserException: $message${code != null ? ' (Code: $code)' : ''}';
}