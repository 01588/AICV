// lib/core/services/storage_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/utils/exceptions.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
      if (kDebugMode) {
        print('Storage service initialized');
      }
    } catch (e) {
      throw StorageException('Failed to initialize storage: $e');
    }
  }

  SharedPreferences get _preferences {
    if (!_isInitialized || _prefs == null) {
      throw StorageException('Storage service not initialized');
    }
    return _prefs!;
  }

  // String operations
  Future<bool> setString(String key, String value) async {
    try {
      return await _preferences.setString(key, value);
    } catch (e) {
      throw StorageException('Failed to store string: $e');
    }
  }

  String? getString(String key, {String? defaultValue}) {
    try {
      return _preferences.getString(key) ?? defaultValue;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get string: $e');
      }
      return defaultValue;
    }
  }

  // Integer operations
  Future<bool> setInt(String key, int value) async {
    try {
      return await _preferences.setInt(key, value);
    } catch (e) {
      throw StorageException('Failed to store integer: $e');
    }
  }

  int? getInt(String key, {int? defaultValue}) {
    try {
      return _preferences.getInt(key) ?? defaultValue;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get integer: $e');
      }
      return defaultValue;
    }
  }

  // Boolean operations
  Future<bool> setBool(String key, bool value) async {
    try {
      return await _preferences.setBool(key, value);
    } catch (e) {
      throw StorageException('Failed to store boolean: $e');
    }
  }

  bool? getBool(String key, {bool? defaultValue}) {
    try {
      return _preferences.getBool(key) ?? defaultValue;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get boolean: $e');
      }
      return defaultValue;
    }
  }

  // Double operations
  Future<bool> setDouble(String key, double value) async {
    try {
      return await _preferences.setDouble(key, value);
    } catch (e) {
      throw StorageException('Failed to store double: $e');
    }
  }

  double? getDouble(String key, {double? defaultValue}) {
    try {
      return _preferences.getDouble(key) ?? defaultValue;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get double: $e');
      }
      return defaultValue;
    }
  }

  // List operations
  Future<bool> setStringList(String key, List<String> value) async {
    try {
      return await _preferences.setStringList(key, value);
    } catch (e) {
      throw StorageException('Failed to store string list: $e');
    }
  }

  List<String>? getStringList(String key, {List<String>? defaultValue}) {
    try {
      return _preferences.getStringList(key) ?? defaultValue;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get string list: $e');
      }
      return defaultValue;
    }
  }

  // JSON operations
  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = json.encode(value);
      return await setString(key, jsonString);
    } catch (e) {
      throw StorageException('Failed to store JSON: $e');
    }
  }

  Map<String, dynamic>? getJson(String key, {Map<String, dynamic>? defaultValue}) {
    try {
      final jsonString = getString(key);
      if (jsonString == null) return defaultValue;
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get JSON: $e');
      }
      return defaultValue;
    }
  }

  // Remove operations
  Future<bool> remove(String key) async {
    try {
      return await _preferences.remove(key);
    } catch (e) {
      throw StorageException('Failed to remove key: $e');
    }
  }

  Future<bool> clear() async {
    try {
      return await _preferences.clear();
    } catch (e) {
      throw StorageException('Failed to clear storage: $e');
    }
  }

  // Check if key exists
  bool containsKey(String key) {
    try {
      return _preferences.containsKey(key);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to check key existence: $e');
      }
      return false;
    }
  }

  // Get all keys
  Set<String> getKeys() {
    try {
      return _preferences.getKeys();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get keys: $e');
      }
      return <String>{};
    }
  }

  // File operations
  Future<Directory> getApplicationDocumentsDirectory() async {
    try {
      return await getApplicationDocumentsDirectory();
    } catch (e) {
      throw StorageException('Failed to get documents directory: $e');
    }
  }

  Future<Directory> getTemporaryDirectory() async {
    try {
      return await getTemporaryDirectory();
    } catch (e) {
      throw StorageException('Failed to get temporary directory: $e');
    }
  }

  Future<Directory?> getExternalStorageDirectory() async {
    try {
      if (Platform.isAndroid) {
        return await getExternalStorageDirectory();
      }
      return null;
    } catch (e) {
      throw StorageException('Failed to get external storage directory: $e');
    }
  }

  // Save file to documents directory
  Future<File> saveFileToDocuments(String filename, List<int> bytes) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      return await file.writeAsBytes(bytes);
    } catch (e) {
      throw StorageException('Failed to save file: $e');
    }
  }

  // Save text file to documents directory
  Future<File> saveTextFileToDocuments(String filename, String content) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      return await file.writeAsString(content);
    } catch (e) {
      throw StorageException('Failed to save text file: $e');
    }
  }

  // Read file from documents directory
  Future<List<int>> readFileFromDocuments(String filename) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');

      if (!await file.exists()) {
        throw FileNotFoundException(filename);
      }

      return await file.readAsBytes();
    } catch (e) {
      if (e is FileNotFoundException) rethrow;
      throw StorageException('Failed to read file: $e');
    }
  }

  // Read text file from documents directory
  Future<String> readTextFileFromDocuments(String filename) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');

      if (!await file.exists()) {
        throw FileNotFoundException(filename);
      }

      return await file.readAsString();
    } catch (e) {
      if (e is FileNotFoundException) rethrow;
      throw StorageException('Failed to read text file: $e');
    }
  }

  // Delete file from documents directory
  Future<void> deleteFileFromDocuments(String filename) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');

      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw StorageException('Failed to delete file: $e');
    }
  }

  // Check if file exists in documents directory
  Future<bool> fileExistsInDocuments(String filename) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      return await file.exists();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to check file existence: $e');
      }
      return false;
    }
  }

  // Get file size
  Future<int> getFileSize(String filename) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');

      if (!await file.exists()) {
        throw FileNotFoundException(filename);
      }

      return await file.length();
    } catch (e) {
      if (e is FileNotFoundException) rethrow;
      throw StorageException('Failed to get file size: $e');
    }
  }

  // List files in documents directory
  Future<List<String>> listFilesInDocuments() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final entities = await directory.list().toList();

      return entities
          .where((entity) => entity is File)
          .map((entity) => entity.path.split('/').last)
          .toList();
    } catch (e) {
      throw StorageException('Failed to list files: $e');
    }
  }

  // Calculate storage usage
  Future<int> calculateStorageUsage() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final entities = await directory.list(recursive: true).toList();

      int totalSize = 0;
      for (final entity in entities) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }

      return totalSize;
    } catch (e) {
      throw StorageException('Failed to calculate storage usage: $e');
    }
  }

  // Clean up temporary files
  Future<void> cleanupTemporaryFiles() async {
    try {
      final directory = await getTemporaryDirectory();
      final entities = await directory.list().toList();

      for (final entity in entities) {
        try {
          await entity.delete(recursive: true);
        } catch (e) {
          // Continue cleaning up other files even if one fails
          if (kDebugMode) {
            print('Failed to delete ${entity.path}: $e');
          }
        }
      }
    } catch (e) {
      throw StorageException('Failed to cleanup temporary files: $e');
    }
  }

  // Backup data to JSON
  Future<Map<String, dynamic>> exportData() async {
    try {
      final keys = getKeys();
      final data = <String, dynamic>{};

      for (final key in keys) {
        // Skip sensitive keys
        if (_isSensitiveKey(key)) continue;

        final value = _preferences.get(key);
        if (value != null) {
          data[key] = value;
        }
      }

      return {
        'timestamp': DateTime.now().toIso8601String(),
        'version': '1.0.0',
        'data': data,
      };
    } catch (e) {
      throw StorageException('Failed to export data: $e');
    }
  }

  // Import data from JSON
  Future<void> importData(Map<String, dynamic> backupData) async {
    try {
      final data = backupData['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw StorageException('Invalid backup data format');
      }

      for (final entry in data.entries) {
        final key = entry.key;
        final value = entry.value;

        // Skip sensitive keys during import
        if (_isSensitiveKey(key)) continue;

        if (value is String) {
          await setString(key, value);
        } else if (value is int) {
          await setInt(key, value);
        } else if (value is bool) {
          await setBool(key, value);
        } else if (value is double) {
          await setDouble(key, value);
        } else if (value is List<String>) {
          await setStringList(key, value);
        }
      }
    } catch (e) {
      throw StorageException('Failed to import data: $e');
    }
  }

  // Check if a key contains sensitive data
  bool _isSensitiveKey(String key) {
    const sensitiveKeys = [
      'auth_token',
      'refresh_token',
      'password',
      'pin',
      'biometric',
      'payment',
      'credit_card',
    ];

    return sensitiveKeys.any((sensitive) => key.toLowerCase().contains(sensitive));
  }

  // Career-specific storage methods
  Future<bool> saveResumeData(String resumeId, Map<String, dynamic> data) async {
    return await setJson('resume_$resumeId', data);
  }

  Map<String, dynamic>? getResumeData(String resumeId) {
    return getJson('resume_$resumeId');
  }

  Future<bool> saveInterviewSession(String sessionId, Map<String, dynamic> data) async {
    return await setJson('interview_$sessionId', data);
  }

  Map<String, dynamic>? getInterviewSession(String sessionId) {
    return getJson('interview_$sessionId');
  }

  Future<bool> saveCoverLetterData(String letterId, Map<String, dynamic> data) async {
    return await setJson('cover_letter_$letterId', data);
  }

  Map<String, dynamic>? getCoverLetterData(String letterId) {
    return getJson('cover_letter_$letterId');
  }

  Future<bool> saveUserPreferences(Map<String, dynamic> preferences) async {
    return await setJson('user_preferences', preferences);
  }

  Map<String, dynamic>? getUserPreferences() {
    return getJson('user_preferences');
  }

  Future<bool> saveAppSettings(Map<String, dynamic> settings) async {
    return await setJson('app_settings', settings);
  }

  Map<String, dynamic>? getAppSettings() {
    return getJson('app_settings', defaultValue: {
      'theme': 'system',
      'notifications_enabled': true,
      'analytics_enabled': true,
      'auto_save': true,
    });
  }

  // Cache management
  Future<bool> setCacheData(String key, Map<String, dynamic> data, {Duration? expiry}) async {
    final cacheItem = {
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'expiry': expiry?.inMilliseconds,
    };
    return await setJson('cache_$key', cacheItem);
  }

  Map<String, dynamic>? getCacheData(String key) {
    final cacheItem = getJson('cache_$key');
    if (cacheItem == null) return null;

    final timestamp = cacheItem['timestamp'] as int?;
    final expiryMs = cacheItem['expiry'] as int?;

    if (timestamp != null && expiryMs != null) {
      final expiry = DateTime.fromMillisecondsSinceEpoch(timestamp + expiryMs);
      if (DateTime.now().isAfter(expiry)) {
        // Cache expired, remove it
        remove('cache_$key');
        return null;
      }
    }

    return cacheItem['data'] as Map<String, dynamic>?;
  }

  Future<void> clearCache() async {
    final keys = getKeys();
    for (final key in keys) {
      if (key.startsWith('cache_')) {
        await remove(key);
      }
    }
  }

  Future<void> clearExpiredCache() async {
    final keys = getKeys();
    final now = DateTime.now();

    for (final key in keys) {
      if (key.startsWith('cache_')) {
        final cacheItem = getJson(key);
        if (cacheItem != null) {
          final timestamp = cacheItem['timestamp'] as int?;
          final expiryMs = cacheItem['expiry'] as int?;

          if (timestamp != null && expiryMs != null) {
            final expiry = DateTime.fromMillisecondsSinceEpoch(timestamp + expiryMs);
            if (now.isAfter(expiry)) {
              await remove(key);
            }
          }
        }
      }
    }
  }
}