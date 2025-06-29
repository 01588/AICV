// lib/core/providers/auth_provider.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/analytics_service.dart';
import '../../services/api_service.dart';
import '../services/api_service.dart';
import '../services/analytics_service.dart';
import '../utils/exceptions.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class User {
  final String id;
  final String email;
  final String name;
  final String? profilePicture;
  final bool isEmailVerified;
  final DateTime createdAt;
  final String subscriptionPlan;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.profilePicture,
    required this.isEmailVerified,
    required this.createdAt,
    required this.subscriptionPlan,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      profilePicture: json['profilePicture'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      subscriptionPlan: json['subscriptionPlan'] as String? ?? 'free',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profilePicture': profilePicture,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt.toIso8601String(),
      'subscriptionPlan': subscriptionPlan,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? profilePicture,
    bool? isEmailVerified,
    DateTime? createdAt,
    String? subscriptionPlan,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
    );
  }
}

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService;
  final AnalyticsService _analyticsService;

  AuthStatus _status = AuthStatus.unknown;
  User? _user;
  String? _token;
  String? _refreshToken;

  AuthProvider({
    required ApiService apiService,
    required AnalyticsService analyticsService,
  })  : _apiService = apiService,
        _analyticsService = analyticsService;

  // Getters
  AuthStatus get status => _status;
  User? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isUnauthenticated => _status == AuthStatus.unauthenticated;

  // Initialize authentication state
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final refreshToken = prefs.getString('refresh_token');
      final userJson = prefs.getString('user_data');

      if (token != null && userJson != null) {
        _token = token;
        _refreshToken = refreshToken;
        _apiService.setAuthToken(token);

        try {
          _user = User.fromJson(Map<String, dynamic>.from(
              await _parseJson(userJson)
          ));
          _status = AuthStatus.authenticated;

          // Verify token is still valid
          await _verifyToken();

          await _analyticsService.setUserId(_user!.id);
        } catch (e) {
          // Token might be expired, try to refresh
          if (refreshToken != null) {
            await _refreshAccessToken();
          } else {
            await logout();
          }
        }
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
    }

    notifyListeners();
  }

  // Sign in with email and password
  Future<void> signInWithEmail(String email, String password) async {
    try {
      final response = await _apiService.post('/auth/login', body: {
        'email': email,
        'password': password,
      });

      await _handleAuthResponse(response);
      await _analyticsService.logLogin('email');
    } catch (e) {
      if (e is ApiException && e.code == '401') {
        throw const InvalidCredentialsException();
      }
      rethrow;
    }
  }

  // Sign up with email and password
  Future<void> signUpWithEmail(String email, String password, String name) async {
    try {
      final response = await _apiService.post('/auth/register', body: {
        'email': email,
        'password': password,
        'name': name,
      });

      await _handleAuthResponse(response);
      await _analyticsService.logSignUp('email');
    } catch (e) {
      if (e is ApiException && e.code == '409') {
        throw const EmailAlreadyExistsException();
      } else if (e is ApiException && e.code == '400') {
        throw const WeakPasswordException();
      }
      rethrow;
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      // Implement Google Sign-In logic here
      // This would typically involve Google Sign-In plugin

      await _analyticsService.logLogin('google');
    } catch (e) {
      throw AuthException('Google sign-in failed: $e');
    }
  }

  // Sign in with Apple
  Future<void> signInWithApple() async {
    try {
      // Implement Apple Sign-In logic here
      // This would typically involve Sign in with Apple plugin

      await _analyticsService.logLogin('apple');
    } catch (e) {
      throw AuthException('Apple sign-in failed: $e');
    }
  }

  // Forgot password
  Future<void> forgotPassword(String email) async {
    try {
      await _apiService.post('/auth/forgot-password', body: {
        'email': email,
      });
    } catch (e) {
      throw AuthException('Failed to send password reset email: $e');
    }
  }

  // Reset password
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      await _apiService.post('/auth/reset-password', body: {
        'token': token,
        'password': newPassword,
      });
    } catch (e) {
      throw AuthException('Failed to reset password: $e');
    }
  }

  // Change password
  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      await _apiService.put('/auth/change-password', body: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      });
    } catch (e) {
      throw AuthException('Failed to change password: $e');
    }
  }

  // Update profile
  Future<void> updateProfile({String? name, String? email}) async {
    try {
      final response = await _apiService.put('/auth/profile', body: {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
      });

      final updatedUser = User.fromJson(response['user']);
      _user = updatedUser;

      await _saveUserData();
      notifyListeners();
    } catch (e) {
      throw AuthException('Failed to update profile: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      if (_token != null) {
        await _apiService.post('/auth/logout');
      }
    } catch (e) {
      // Ignore logout errors
    } finally {
      await _clearAuthData();
      await _analyticsService.logLogout();
      notifyListeners();
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      await _apiService.delete('/auth/account');
      await _clearAuthData();
      notifyListeners();
    } catch (e) {
      throw AuthException('Failed to delete account: $e');
    }
  }

  // Refresh access token
  Future<void> _refreshAccessToken() async {
    if (_refreshToken == null) {
      await logout();
      return;
    }

    try {
      final response = await _apiService.post('/auth/refresh', body: {
        'refreshToken': _refreshToken,
      });

      await _handleAuthResponse(response);
    } catch (e) {
      await logout();
    }
  }

  // Verify token is still valid
  Future<void> _verifyToken() async {
    try {
      final response = await _apiService.get('/auth/me');
      final user = User.fromJson(response['user']);

      if (user.id != _user?.id) {
        await logout();
      }
    } catch (e) {
      if (_refreshToken != null) {
        await _refreshAccessToken();
      } else {
        await logout();
      }
    }
  }

  // Handle authentication response
  Future<void> _handleAuthResponse(Map<String, dynamic> response) async {
    _token = response['token'] as String;
    _refreshToken = response['refreshToken'] as String?;
    _user = User.fromJson(response['user']);
    _status = AuthStatus.authenticated;

    _apiService.setAuthToken(_token!);
    await _saveAuthData();
    await _analyticsService.setUserId(_user!.id);

    notifyListeners();
  }

  // Save authentication data to persistent storage
  Future<void> _saveAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', _token!);
    if (_refreshToken != null) {
      await prefs.setString('refresh_token', _refreshToken!);
    }
    await _saveUserData();
  }

  // Save user data to persistent storage
  Future<void> _saveUserData() async {
    if (_user == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', _user!.toJson().toString());
  }

  // Clear authentication data
  Future<void> _clearAuthData() async {
    _status = AuthStatus.unauthenticated;
    _user = null;
    _token = null;
    _refreshToken = null;

    _apiService.clearAuthToken();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user_data');
  }

  // Helper to parse JSON string
  Future<Map<String, dynamic>> _parseJson(String jsonString) async {
    return await compute(_parseJsonInIsolate, jsonString);
  }

  static Map<String, dynamic> _parseJsonInIsolate(String jsonString) {
    // This is a simplified parser - in real implementation you'd use json.decode
    // after properly formatting the stored JSON
    return {};
  }
}