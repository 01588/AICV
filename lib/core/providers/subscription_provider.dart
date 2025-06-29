// lib/core/providers/subscription_provider.dart
import 'package:flutter/foundation.dart';
import '../../services/analytics_service.dart';
import '../../services/api_service.dart';
import '../services/api_service.dart';
import '../services/analytics_service.dart';
import '../utils/exceptions.dart';

enum SubscriptionPlan {
  free,
  premium,
  pro,
}

enum SubscriptionStatus {
  active,
  expired,
  cancelled,
  pending,
}

class SubscriptionFeature {
  final String id;
  final String name;
  final String description;
  final bool isAvailable;
  final int? limit;
  final int? usage;

  const SubscriptionFeature({
    required this.id,
    required this.name,
    required this.description,
    required this.isAvailable,
    this.limit,
    this.usage,
  });

  factory SubscriptionFeature.fromJson(Map<String, dynamic> json) {
    return SubscriptionFeature(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      isAvailable: json['isAvailable'] as bool,
      limit: json['limit'] as int?,
      usage: json['usage'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isAvailable': isAvailable,
      'limit': limit,
      'usage': usage,
    };
  }

  bool get hasUsageLimit => limit != null;
  bool get isLimitReached => hasUsageLimit && (usage ?? 0) >= limit!;
  int get remainingUsage => hasUsageLimit ? (limit! - (usage ?? 0)).clamp(0, limit!) : -1;
}

class Subscription {
  final String id;
  final String userId;
  final SubscriptionPlan plan;
  final SubscriptionStatus status;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? cancelledAt;
  final double price;
  final String currency;
  final String interval; // monthly, yearly
  final Map<String, SubscriptionFeature> features;
  final DateTime? trialEndDate;
  final bool autoRenew;

  const Subscription({
    required this.id,
    required this.userId,
    required this.plan,
    required this.status,
    required this.startDate,
    this.endDate,
    this.cancelledAt,
    required this.price,
    required this.currency,
    required this.interval,
    required this.features,
    this.trialEndDate,
    required this.autoRenew,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] as String,
      userId: json['userId'] as String,
      plan: SubscriptionPlan.values.firstWhere(
            (e) => e.toString().split('.').last == json['plan'],
      ),
      status: SubscriptionStatus.values.firstWhere(
            (e) => e.toString().split('.').last == json['status'],
      ),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
      cancelledAt: json['cancelledAt'] != null ? DateTime.parse(json['cancelledAt'] as String) : null,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      interval: json['interval'] as String,
      features: (json['features'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, SubscriptionFeature.fromJson(value)),
      ),
      trialEndDate: json['trialEndDate'] != null ? DateTime.parse(json['trialEndDate'] as String) : null,
      autoRenew: json['autoRenew'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'plan': plan.toString().split('.').last,
      'status': status.toString().split('.').last,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
      'price': price,
      'currency': currency,
      'interval': interval,
      'features': features.map((key, value) => MapEntry(key, value.toJson())),
      'trialEndDate': trialEndDate?.toIso8601String(),
      'autoRenew': autoRenew,
    };
  }

  bool get isActive => status == SubscriptionStatus.active;
  bool get isExpired => status == SubscriptionStatus.expired;
  bool get isCancelled => status == SubscriptionStatus.cancelled;
  bool get isInTrial => trialEndDate != null && DateTime.now().isBefore(trialEndDate!);
  bool get isPremium => plan != SubscriptionPlan.free;

  int get daysUntilExpiry {
    if (endDate == null) return -1;
    return endDate!.difference(DateTime.now()).inDays;
  }
}

class SubscriptionProvider extends ChangeNotifier {
  final ApiService _apiService;
  final AnalyticsService _analyticsService;

  Subscription? _subscription;
  bool _isLoading = false;
  String? _error;

  SubscriptionProvider({
    required ApiService apiService,
    required AnalyticsService analyticsService,
  })  : _apiService = apiService,
        _analyticsService = analyticsService;

  // Getters
  Subscription? get subscription => _subscription;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isPremium => _subscription?.isPremium ?? false;
  bool get isActive => _subscription?.isActive ?? false;
  SubscriptionPlan get currentPlan => _subscription?.plan ?? SubscriptionPlan.free;

  // Load subscription data
  Future<void> loadSubscription() async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _apiService.get('/subscription');
      _subscription = Subscription.fromJson(response['subscription']);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load subscription: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Check if feature is available
  bool isFeatureAvailable(String featureId) {
    if (_subscription == null) return false;

    final feature = _subscription!.features[featureId];
    return feature?.isAvailable ?? false;
  }

  // Check if feature has usage limit
  bool hasFeatureUsageLimit(String featureId) {
    if (_subscription == null) return true;

    final feature = _subscription!.features[featureId];
    return feature?.hasUsageLimit ?? true;
  }

  // Check if feature limit is reached
  bool isFeatureLimitReached(String featureId) {
    if (_subscription == null) return true;

    final feature = _subscription!.features[featureId];
    return feature?.isLimitReached ?? true;
  }

  // Get remaining usage for a feature
  int getFeatureRemainingUsage(String featureId) {
    if (_subscription == null) return 0;

    final feature = _subscription!.features[featureId];
    return feature?.remainingUsage ?? 0;
  }

  // Upgrade subscription
  Future<void> upgradeSubscription(SubscriptionPlan plan, String interval) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _apiService.post('/subscription/upgrade', body: {
        'plan': plan.toString().split('.').last,
        'interval': interval,
      });

      _subscription = Subscription.fromJson(response['subscription']);

      await _analyticsService.logSubscriptionUpgrade(plan.toString().split('.').last);

      notifyListeners();
    } catch (e) {
      _setError('Failed to upgrade subscription: $e');
      throw SubscriptionException('Failed to upgrade subscription: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Cancel subscription
  Future<void> cancelSubscription({String? reason}) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _apiService.post('/subscription/cancel', body: {
        if (reason != null) 'reason': reason,
      });

      _subscription = Subscription.fromJson(response['subscription']);

      await _analyticsService.logSubscriptionCancel();

      notifyListeners();
    } catch (e) {
      _setError('Failed to cancel subscription: $e');
      throw SubscriptionException('Failed to cancel subscription: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Resume subscription
  Future<void> resumeSubscription() async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _apiService.post('/subscription/resume');
      _subscription = Subscription.fromJson(response['subscription']);

      await _analyticsService.logEvent('subscription_resumed');

      notifyListeners();
    } catch (e) {
      _setError('Failed to resume subscription: $e');
      throw SubscriptionException('Failed to resume subscription: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Update payment method
  Future<void> updatePaymentMethod(String paymentMethodId) async {
    _setLoading(true);
    _setError(null);

    try {
      await _apiService.put('/subscription/payment-method', body: {
        'paymentMethodId': paymentMethodId,
      });

      await _analyticsService.logEvent('payment_method_updated');

      // Reload subscription to get updated info
      await loadSubscription();
    } catch (e) {
      _setError('Failed to update payment method: $e');
      throw SubscriptionException('Failed to update payment method: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Get available plans
  Future<List<Map<String, dynamic>>> getAvailablePlans() async {
    try {
      final response = await _apiService.get('/subscription/plans');
      return List<Map<String, dynamic>>.from(response['plans']);
    } catch (e) {
      throw SubscriptionException('Failed to load available plans: $e');
    }
  }

  // Track feature usage
  Future<void> trackFeatureUsage(String featureId) async {
    try {
      await _apiService.post('/subscription/usage', body: {
        'featureId': featureId,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Update local feature usage
      if (_subscription != null && _subscription!.features.containsKey(featureId)) {
        final feature = _subscription!.features[featureId]!;
        final updatedFeature = SubscriptionFeature(
          id: feature.id,
          name: feature.name,
          description: feature.description,
          isAvailable: feature.isAvailable,
          limit: feature.limit,
          usage: (feature.usage ?? 0) + 1,
        );

        _subscription = _subscription!.copyWith(
          features: Map.from(_subscription!.features)..[featureId] = updatedFeature,
        );

        notifyListeners();
      }

      await _analyticsService.logFeatureUsed(featureId);
    } catch (e) {
      // Don't throw error for usage tracking
      if (kDebugMode) {
        print('Failed to track feature usage: $e');
      }
    }
  }

  // Check if user can use a feature
  Future<bool> canUseFeature(String featureId) async {
    if (_subscription == null) {
      await loadSubscription();
    }

    if (!isFeatureAvailable(featureId)) {
      throw FeatureNotAvailableException(featureId);
    }

    if (isFeatureLimitReached(featureId)) {
      throw SubscriptionException('Feature usage limit reached for: $featureId');
    }

    return true;
  }

  // Use a feature (checks availability and tracks usage)
  Future<void> useFeature(String featureId) async {
    await canUseFeature(featureId);
    await trackFeatureUsage(featureId);
  }

  // Get subscription billing history
  Future<List<Map<String, dynamic>>> getBillingHistory() async {
    try {
      final response = await _apiService.get('/subscription/billing-history');
      return List<Map<String, dynamic>>.from(response['history']);
    } catch (e) {
      throw SubscriptionException('Failed to load billing history: $e');
    }
  }

  // Apply promo code
  Future<void> applyPromoCode(String code) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _apiService.post('/subscription/promo-code', body: {
        'code': code,
      });

      _subscription = Subscription.fromJson(response['subscription']);

      await _analyticsService.logEvent('promo_code_applied', parameters: {'code': code});

      notifyListeners();
    } catch (e) {
      _setError('Failed to apply promo code: $e');
      throw SubscriptionException('Failed to apply promo code: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Clear subscription data (for logout)
  void clearSubscriptionData() {
    _subscription = null;
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

// Extension to add copyWith method to Subscription
extension SubscriptionCopyWith on Subscription {
  Subscription copyWith({
    String? id,
    String? userId,
    SubscriptionPlan? plan,
    SubscriptionStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? cancelledAt,
    double? price,
    String? currency,
    String? interval,
    Map<String, SubscriptionFeature>? features,
    DateTime? trialEndDate,
    bool? autoRenew,
  }) {
    return Subscription(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      plan: plan ?? this.plan,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      interval: interval ?? this.interval,
      features: features ?? this.features,
      trialEndDate: trialEndDate ?? this.trialEndDate,
      autoRenew: autoRenew ?? this.autoRenew,
    );
  }
}

// Common feature IDs
class SubscriptionFeatures {
  static const String resumeBuilder = 'resume_builder';
  static const String mockInterviews = 'mock_interviews';
  static const String coverLetterGenerator = 'cover_letter_generator';
  static const String aiAnalysis = 'ai_analysis';
  static const String premiumTemplates = 'premium_templates';
  static const String unlimitedDownloads = 'unlimited_downloads';
  static const String prioritySupport = 'priority_support';
  static const String advancedAnalytics = 'advanced_analytics';
  static const String careerCoaching = 'career_coaching';
  static const String jobRecommendations = 'job_recommendations';
}