

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import '../services/analytics_service.dart';
import '../models/user_model.dart';
import '../utils/exceptions.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _currentUser;
  UserModel? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get currentUser => _currentUser;
  UserModel? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    _currentUser = _firebaseAuth.currentUser;
    if (_currentUser != null) {
      await _loadUserProfile();
    }
    notifyListeners();
  }

  Future<bool> checkAuthStatus() async {
    try {
      await _firebaseAuth.authStateChanges().first;
      _currentUser = _firebaseAuth.currentUser;

      if (_currentUser != null) {
        await _loadUserProfile();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Auth status check error: $e');
      return false;
    }
  }

  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('is_first_launch') ?? true;

    if (isFirstLaunch) {
      await prefs.setBool('is_first_launch', false);
    }

    return !isFirstLaunch;
  }

  Future<void> _loadUserProfile() async {
    if (_currentUser == null) return;

    try {
      final profileData = await ApiService.instance.getUserProfile(_currentUser!.uid);
      _userProfile = UserModel.fromJson(profileData);
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Email/Password Authentication
  Future<AuthResult> signInWithEmailPassword(String email, String password) async {
    try {
      _setLoading(true);
      _setError(null);

      final UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      _currentUser = credential.user;
      await _loadUserProfile();

      AnalyticsService.instance.logEvent('user_sign_in', parameters: {
        'method': 'email',
      });

      _setLoading(false);
      return AuthResult.success();
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      final errorMessage = _getAuthErrorMessage(e.code);
      _setError(errorMessage);
      return AuthResult.failure(errorMessage);
    } catch (e) {
      _setLoading(false);
      const errorMessage = 'An unexpected error occurred. Please try again.';
      _setError(errorMessage);
      return AuthResult.failure(errorMessage);
    }
  }

  Future<AuthResult> signUpWithEmailPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      _currentUser = credential.user;

      // Update display name
      await _currentUser!.updateDisplayName(fullName);

      // Create user profile
      await _createUserProfile(fullName, email);

      AnalyticsService.instance.logEvent('user_sign_up', parameters: {
        'method': 'email',
      });

      _setLoading(false);
      return AuthResult.success();
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      final errorMessage = _getAuthErrorMessage(e.code);
      _setError(errorMessage);
      return AuthResult.failure(errorMessage);
    } catch (e) {
      _setLoading(false);
      const errorMessage = 'Failed to create account. Please try again.';
      _setError(errorMessage);
      return AuthResult.failure(errorMessage);
    }
  }

  // Google Sign In
  Future<AuthResult> signInWithGoogle() async {
    try {
      _setLoading(true);
      _setError(null);

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _setLoading(false);
        return AuthResult.failure('Google sign in was cancelled');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      _currentUser = userCredential.user;

      // Check if this is a new user
      if (userCredential.additionalUserInfo?.isNewUser == true) {
        await _createUserProfile(
          _currentUser!.displayName ?? 'User',
          _currentUser!.email ?? '',
        );
      } else {
        await _loadUserProfile();
      }

      AnalyticsService.instance.logEvent('user_sign_in', parameters: {
        'method': 'google',
      });

      _setLoading(false);
      return AuthResult.success();
    } catch (e) {
      _setLoading(false);
      const errorMessage = 'Google sign in failed. Please try again.';
      _setError(errorMessage);
      return AuthResult.failure(errorMessage);
    }
  }

  // Apple Sign In
  Future<AuthResult> signInWithApple() async {
    try {
      _setLoading(true);
      _setError(null);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(oauthCredential);
      _currentUser = userCredential.user;

      // Check if this is a new user
      if (userCredential.additionalUserInfo?.isNewUser == true) {
        final fullName = appleCredential.givenName != null && appleCredential.familyName != null
            ? '${appleCredential.givenName} ${appleCredential.familyName}'
            : _currentUser!.displayName ?? 'User';

        await _createUserProfile(fullName, _currentUser!.email ?? '');
      } else {
        await _loadUserProfile();
      }

      AnalyticsService.instance.logEvent('user_sign_in', parameters: {
        'method': 'apple',
      });

      _setLoading(false);
      return AuthResult.success();
    } catch (e) {
      _setLoading(false);
      const errorMessage = 'Apple sign in failed. Please try again.';
      _setError(errorMessage);
      return AuthResult.failure(errorMessage);
    }
  }

  // Password Reset
  Future<AuthResult> resetPassword(String email) async {
    try {
      _setLoading(true);
      _setError(null);

      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());

      AnalyticsService.instance.logEvent('password_reset_requested');

      _setLoading(false);
      return AuthResult.success();
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      final errorMessage = _getAuthErrorMessage(e.code);
      _setError(errorMessage);
      return AuthResult.failure(errorMessage);
    } catch (e) {
      _setLoading(false);
      const errorMessage = 'Failed to send reset email. Please try again.';
      _setError(errorMessage);
      return AuthResult.failure(errorMessage);
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      _setLoading(true);

      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);

      _currentUser = null;
      _userProfile = null;

      AnalyticsService.instance.logEvent('user_sign_out');

      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      debugPrint('Error signing out: $e');
    }
  }

  // Update Profile
  Future<AuthResult> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      if (_currentUser == null) {
        return AuthResult.failure('No authenticated user');
      }

      if (displayName != null) {
        await _currentUser!.updateDisplayName(displayName);
      }

      if (photoURL != null) {
        await _currentUser!.updatePhotoURL(photoURL);
      }

      await _currentUser!.reload();
      _currentUser = _firebaseAuth.currentUser;

      // Update user profile in database
      if (_userProfile != null) {
        _userProfile = _userProfile!.copyWith(
          displayName: displayName ?? _userProfile!.displayName,
          photoURL: photoURL ?? _userProfile!.photoURL,
        );

        await ApiService.instance.updateUserProfile(_currentUser!.uid, _userProfile!.toJson());
      }

      _setLoading(false);
      return AuthResult.success();
    } catch (e) {
      _setLoading(false);
      const errorMessage = 'Failed to update profile. Please try again.';
      _setError(errorMessage);
      return AuthResult.failure(errorMessage);
    }
  }

  // Change Password
  Future<AuthResult> changePassword(String currentPassword, String newPassword) async {
    try {
      _setLoading(true);
      _setError(null);

      if (_currentUser == null || _currentUser!.email == null) {
        return AuthResult.failure('No authenticated user');
      }

      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: _currentUser!.email!,
        password: currentPassword,
      );

      await _currentUser!.reauthenticateWithCredential(credential);

      // Update password
      await _currentUser!.updatePassword(newPassword);

      AnalyticsService.instance.logEvent('password_changed');

      _setLoading(false);
      return AuthResult.success();
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      final errorMessage = _getAuthErrorMessage(e.code);
      _setError(errorMessage);
      return AuthResult.failure(errorMessage);
    } catch (e) {
      _setLoading(false);
      const errorMessage = 'Failed to change password. Please try again.';
      _setError(errorMessage);
      return AuthResult.failure(errorMessage);
    }
  }

  // Delete Account
  Future<AuthResult> deleteAccount() async {
    try {
      _setLoading(true);
      _setError(null);

      if (_currentUser == null) {
        return AuthResult.failure('No authenticated user');
      }

      // Delete user data from database
      await ApiService.instance.deleteUserData(_currentUser!.uid);

      // Delete Firebase user
      await _currentUser!.delete();

      _currentUser = null;
      _userProfile = null;

      AnalyticsService.instance.logEvent('account_deleted');

      _setLoading(false);
      return AuthResult.success();
    } catch (e) {
      _setLoading(false);
      const errorMessage = 'Failed to delete account. Please try again.';
      _setError(errorMessage);
      return AuthResult.failure(errorMessage);
    }
  }

  Future<void> _createUserProfile(String displayName, String email) async {
    if (_currentUser == null) return;

    _userProfile = UserModel(
      id: _currentUser!.uid,
      email: email,
      displayName: displayName,
      photoURL: _currentUser!.photoURL,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
      isPremium: false,
      settings: UserSettings(),
    );

    try {
      await ApiService.instance.createUserProfile(_currentUser!.uid, _userProfile!.toJson());
    } catch (e) {
      debugPrint('Error creating user profile: $e');
    }
  }

  String _getAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'requires-recent-login':
        return 'Please sign in again to complete this action.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  void clearError() {
    _setError(null);
  }
}

class AuthResult {
  final bool isSuccess;
  final String? errorMessage;

  AuthResult._(this.isSuccess, this.errorMessage);

  factory AuthResult.success() => AuthResult._(true, null);
  factory AuthResult.failure(String message) => AuthResult._(false, message);
}