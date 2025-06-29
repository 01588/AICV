// lib/core/services/notification_service.dart
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

enum NotificationType {
  reminder,
  achievement,
  subscription,
  interview,
  resume,
  general,
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize timezone data
      tz.initializeTimeZones();

      // Android initialization - Fixed const issue
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization - Fixed const issue
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      _isInitialized = true;
      if (kDebugMode) {
        print('Notification service initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to initialize notifications: $e');
      }
    }
  }

  Future<bool> requestPermissions() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Request Android notification permission
      final androidPermission = await _notifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      // Request iOS permissions
      final iosPermission = await _notifications
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

      return androidPermission ?? iosPermission ?? true;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to request notification permissions: $e');
      }
      return false;
    }
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    NotificationType type = NotificationType.general,
    String? payload,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final androidDetails = AndroidNotificationDetails(
        _getChannelId(type),
        _getChannelName(type),
        channelDescription: _getChannelDescription(type),
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        color: _getNotificationColor(type),
        playSound: true,
        enableVibration: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.active,
      );

      var details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        id,
        title,
        body,
        details,
        payload: payload,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to show notification: $e');
      }
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    NotificationType type = NotificationType.general,
    String? payload,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

      final androidDetails = AndroidNotificationDetails(
        _getChannelId(type),
        _getChannelName(type),
        channelDescription: _getChannelDescription(type),
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        color: _getNotificationColor(type),
        playSound: true,
        enableVibration: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.active,
      );

      var details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.zonedSchedule(
        id,
        title,
        body,
        tzScheduledTime,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Fixed missing parameter
        payload: payload,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to schedule notification: $e');
      }
    }
  }

  Future<void> scheduleRepeatingNotification({
    required int id,
    required String title,
    required String body,
    required RepeatInterval repeatInterval,
    NotificationType type = NotificationType.general,
    String? payload,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final androidDetails = AndroidNotificationDetails(
        _getChannelId(type),
        _getChannelName(type),
        channelDescription: _getChannelDescription(type),
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        color: _getNotificationColor(type),
        playSound: true,
        enableVibration: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.active,
      );

      var details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.periodicallyShow(
        id,
        title,
        body,
        repeatInterval,
        details,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Fixed missing parameter
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to schedule repeating notification: $e');
      }
    }
  }

  Future<void> cancelNotification(int id) async {
    try {
      await _notifications.cancel(id);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to cancel notification: $e');
      }
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await _notifications.cancelAll();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to cancel all notifications: $e');
      }
    }
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _notifications.pendingNotificationRequests();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get pending notifications: $e');
      }
      return [];
    }
  }

  // Career-specific notification methods
  Future<void> scheduleInterviewReminder({
    required int id,
    required String companyName,
    required String position,
    required DateTime interviewTime,
  }) async {
    final reminderTime = interviewTime.subtract(const Duration(hours: 1));

    await scheduleNotification(
      id: id,
      title: 'Interview Reminder',
      body: 'Your $position interview with $companyName is starting in 1 hour',
      scheduledTime: reminderTime,
      type: NotificationType.interview,
      payload: 'interview_reminder_$id',
    );
  }

  Future<void> scheduleResumeBuildingReminder({
    required int id,
    required DateTime reminderTime,
  }) async {
    await scheduleNotification(
      id: id,
      title: 'Resume Builder Reminder',
      body: 'Don\'t forget to complete your resume! A great resume is key to landing interviews.',
      scheduledTime: reminderTime,
      type: NotificationType.resume,
      payload: 'resume_reminder_$id',
    );
  }

  Future<void> showSubscriptionExpiredNotification() async {
    await showNotification(
      id: 999,
      title: 'Subscription Expired',
      body: 'Your premium subscription has expired. Upgrade now to continue accessing premium features.',
      type: NotificationType.subscription,
      payload: 'subscription_expired',
    );
  }

  Future<void> showAchievementNotification({
    required String achievement,
    required String description,
  }) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      title: 'Achievement Unlocked! 🎉',
      body: '$achievement - $description',
      type: NotificationType.achievement,
      payload: 'achievement_$achievement',
    );
  }

  Future<void> scheduleDailyPracticeReminder() async {
    await scheduleRepeatingNotification(
      id: 1001,
      title: 'Daily Practice Reminder',
      body: 'Take 10 minutes to practice interview questions today!',
      repeatInterval: RepeatInterval.daily,
      type: NotificationType.reminder,
      payload: 'daily_practice',
    );
  }

  Future<void> scheduleWeeklyGoalReminder() async {
    await scheduleRepeatingNotification(
      id: 1002,
      title: 'Weekly Goal Check-in',
      body: 'How are you progressing with your career goals this week?',
      repeatInterval: RepeatInterval.weekly,
      type: NotificationType.reminder,
      payload: 'weekly_goals',
    );
  }

  // Private helper methods
  String _getChannelId(NotificationType type) {
    switch (type) {
      case NotificationType.reminder:
        return 'reminder_channel';
      case NotificationType.achievement:
        return 'achievement_channel';
      case NotificationType.subscription:
        return 'subscription_channel';
      case NotificationType.interview:
        return 'interview_channel';
      case NotificationType.resume:
        return 'resume_channel';
      case NotificationType.general:
        return 'general_channel';
    }
  }

  String _getChannelName(NotificationType type) {
    switch (type) {
      case NotificationType.reminder:
        return 'Reminders';
      case NotificationType.achievement:
        return 'Achievements';
      case NotificationType.subscription:
        return 'Subscription';
      case NotificationType.interview:
        return 'Interviews';
      case NotificationType.resume:
        return 'Resume';
      case NotificationType.general:
        return 'General';
    }
  }

  String _getChannelDescription(NotificationType type) {
    switch (type) {
      case NotificationType.reminder:
        return 'Practice and goal reminders';
      case NotificationType.achievement:
        return 'Achievement notifications';
      case NotificationType.subscription:
        return 'Subscription-related notifications';
      case NotificationType.interview:
        return 'Interview reminders and updates';
      case NotificationType.resume:
        return 'Resume building reminders';
      case NotificationType.general:
        return 'General app notifications';
    }
  }

  Color? _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.reminder:
        return const Color(0xFF3B82F6); // Blue
      case NotificationType.achievement:
        return const Color(0xFFF59E0B); // Amber
      case NotificationType.subscription:
        return const Color(0xFF8B5CF6); // Purple
      case NotificationType.interview:
        return const Color(0xFF10B981); // Green
      case NotificationType.resume:
        return const Color(0xFF1E3A8A); // Dark blue
      case NotificationType.general:
        return const Color(0xFF6B7280); // Gray
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null) {
      if (kDebugMode) {
        print('Notification tapped with payload: $payload');
      }

      // Handle notification tap based on payload
      _handleNotificationAction(payload);
    }
  }

  void _handleNotificationAction(String payload) {
    // This would typically navigate to specific screens based on the payload
    // For example:
    if (payload.startsWith('interview_reminder_')) {
      // Navigate to interview screen
    } else if (payload.startsWith('resume_reminder_')) {
      // Navigate to resume builder
    } else if (payload == 'subscription_expired') {
      // Navigate to subscription screen
    } else if (payload.startsWith('achievement_')) {
      // Show achievement details
    }

    // The actual navigation would be handled by the app's router/navigator
  }
}