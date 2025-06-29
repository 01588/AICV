import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String? photoURL;
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final bool isPremium;
  final DateTime? premiumExpiresAt;
  final UserProfile? profile;
  final UserSettings settings;
  final UserStats stats;

  const UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoURL,
    this.phoneNumber,
    required this.createdAt,
    required this.lastLoginAt,
    this.isPremium = false,
    this.premiumExpiresAt,
    this.profile,
    required this.settings,
    this.stats = const UserStats(),
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      photoURL: json['photoURL'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: DateTime.parse(json['lastLoginAt'] as String),
      isPremium: json['isPremium'] as bool? ?? false,
      premiumExpiresAt: json['premiumExpiresAt'] != null
          ? DateTime.parse(json['premiumExpiresAt'] as String)
          : null,
      profile: json['profile'] != null
          ? UserProfile.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
      settings: json['settings'] != null
          ? UserSettings.fromJson(json['settings'] as Map<String, dynamic>)
          : UserSettings(),
      stats: json['stats'] != null
          ? UserStats.fromJson(json['stats'] as Map<String, dynamic>)
          : const UserStats(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
      'isPremium': isPremium,
      'premiumExpiresAt': premiumExpiresAt?.toIso8601String(),
      'profile': profile?.toJson(),
      'settings': settings.toJson(),
      'stats': stats.toJson(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoURL,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isPremium,
    DateTime? premiumExpiresAt,
    UserProfile? profile,
    UserSettings? settings,
    UserStats? stats,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isPremium: isPremium ?? this.isPremium,
      premiumExpiresAt: premiumExpiresAt ?? this.premiumExpiresAt,
      profile: profile ?? this.profile,
      settings: settings ?? this.settings,
      stats: stats ?? this.stats,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    displayName,
    photoURL,
    phoneNumber,
    createdAt,
    lastLoginAt,
    isPremium,
    premiumExpiresAt,
    profile,
    settings,
    stats,
  ];
}

class UserProfile extends Equatable {
  final String? jobTitle;
  final String? company;
  final String? industry;
  final String? location;
  final String? bio;
  final List<String> skills;
  final List<WorkExperience> workExperience;
  final List<Education> education;
  final List<String> certifications;
  final String? linkedinUrl;
  final String? portfolioUrl;
  final int experienceYears;

  const UserProfile({
    this.jobTitle,
    this.company,
    this.industry,
    this.location,
    this.bio,
    this.skills = const [],
    this.workExperience = const [],
    this.education = const [],
    this.certifications = const [],
    this.linkedinUrl,
    this.portfolioUrl,
    this.experienceYears = 0,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      jobTitle: json['jobTitle'] as String?,
      company: json['company'] as String?,
      industry: json['industry'] as String?,
      location: json['location'] as String?,
      bio: json['bio'] as String?,
      skills: (json['skills'] as List<dynamic>?)?.cast<String>() ?? [],
      workExperience: (json['workExperience'] as List<dynamic>?)
          ?.map((e) => WorkExperience.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      education: (json['education'] as List<dynamic>?)
          ?.map((e) => Education.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      certifications: (json['certifications'] as List<dynamic>?)?.cast<String>() ?? [],
      linkedinUrl: json['linkedinUrl'] as String?,
      portfolioUrl: json['portfolioUrl'] as String?,
      experienceYears: json['experienceYears'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobTitle': jobTitle,
      'company': company,
      'industry': industry,
      'location': location,
      'bio': bio,
      'skills': skills,
      'workExperience': workExperience.map((e) => e.toJson()).toList(),
      'education': education.map((e) => e.toJson()).toList(),
      'certifications': certifications,
      'linkedinUrl': linkedinUrl,
      'portfolioUrl': portfolioUrl,
      'experienceYears': experienceYears,
    };
  }

  UserProfile copyWith({
    String? jobTitle,
    String? company,
    String? industry,
    String? location,
    String? bio,
    List<String>? skills,
    List<WorkExperience>? workExperience,
    List<Education>? education,
    List<String>? certifications,
    String? linkedinUrl,
    String? portfolioUrl,
    int? experienceYears,
  }) {
    return UserProfile(
      jobTitle: jobTitle ?? this.jobTitle,
      company: company ?? this.company,
      industry: industry ?? this.industry,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      skills: skills ?? this.skills,
      workExperience: workExperience ?? this.workExperience,
      education: education ?? this.education,
      certifications: certifications ?? this.certifications,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      portfolioUrl: portfolioUrl ?? this.portfolioUrl,
      experienceYears: experienceYears ?? this.experienceYears,
    );
  }

  @override
  List<Object?> get props => [
    jobTitle,
    company,
    industry,
    location,
    bio,
    skills,
    workExperience,
    education,
    certifications,
    linkedinUrl,
    portfolioUrl,
    experienceYears,
  ];
}

class WorkExperience extends Equatable {
  final String id;
  final String company;
  final String position;
  final String? location;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrent;
  final String? description;
  final List<String> achievements;

  const WorkExperience({
    required this.id,
    required this.company,
    required this.position,
    this.location,
    required this.startDate,
    this.endDate,
    this.isCurrent = false,
    this.description,
    this.achievements = const [],
  });

  factory WorkExperience.fromJson(Map<String, dynamic> json) {
    return WorkExperience(
      id: json['id'] as String,
      company: json['company'] as String,
      position: json['position'] as String,
      location: json['location'] as String?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
      isCurrent: json['isCurrent'] as bool? ?? false,
      description: json['description'] as String?,
      achievements: (json['achievements'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company': company,
      'position': position,
      'location': location,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isCurrent': isCurrent,
      'description': description,
      'achievements': achievements,
    };
  }

  @override
  List<Object?> get props => [
    id,
    company,
    position,
    location,
    startDate,
    endDate,
    isCurrent,
    description,
    achievements,
  ];
}

class Education extends Equatable {
  final String id;
  final String institution;
  final String degree;
  final String? fieldOfStudy;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrent;
  final double? gpa;
  final String? description;

  const Education({
    required this.id,
    required this.institution,
    required this.degree,
    this.fieldOfStudy,
    required this.startDate,
    this.endDate,
    this.isCurrent = false,
    this.gpa,
    this.description,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'] as String,
      institution: json['institution'] as String,
      degree: json['degree'] as String,
      fieldOfStudy: json['fieldOfStudy'] as String?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
      isCurrent: json['isCurrent'] as bool? ?? false,
      gpa: json['gpa'] as double?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'institution': institution,
      'degree': degree,
      'fieldOfStudy': fieldOfStudy,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isCurrent': isCurrent,
      'gpa': gpa,
      'description': description,
    };
  }

  @override
  List<Object?> get props => [
    id,
    institution,
    degree,
    fieldOfStudy,
    startDate,
    endDate,
    isCurrent,
    gpa,
    description,
  ];
}

class UserSettings extends Equatable {
  final bool darkMode;
  final bool notificationsEnabled;
  final bool emailNotifications;
  final bool pushNotifications;
  final String language;
  final String timezone;
  final bool analyticsEnabled;
  final bool biometricEnabled;

  const UserSettings({
    this.darkMode = false,
    this.notificationsEnabled = true,
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.language = 'en',
    this.timezone = 'UTC',
    this.analyticsEnabled = true,
    this.biometricEnabled = false,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      darkMode: json['darkMode'] as bool? ?? false,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      emailNotifications: json['emailNotifications'] as bool? ?? true,
      pushNotifications: json['pushNotifications'] as bool? ?? true,
      language: json['language'] as String? ?? 'en',
      timezone: json['timezone'] as String? ?? 'UTC',
      analyticsEnabled: json['analyticsEnabled'] as bool? ?? true,
      biometricEnabled: json['biometricEnabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'darkMode': darkMode,
      'notificationsEnabled': notificationsEnabled,
      'emailNotifications': emailNotifications,
      'pushNotifications': pushNotifications,
      'language': language,
      'timezone': timezone,
      'analyticsEnabled': analyticsEnabled,
      'biometricEnabled': biometricEnabled,
    };
  }

  UserSettings copyWith({
    bool? darkMode,
    bool? notificationsEnabled,
    bool? emailNotifications,
    bool? pushNotifications,
    String? language,
    String? timezone,
    bool? analyticsEnabled,
    bool? biometricEnabled,
  }) {
    return UserSettings(
      darkMode: darkMode ?? this.darkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      language: language ?? this.language,
      timezone: timezone ?? this.timezone,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    );
  }

  @override
  List<Object?> get props => [
    darkMode,
    notificationsEnabled,
    emailNotifications,
    pushNotifications,
    language,
    timezone,
    analyticsEnabled,
    biometricEnabled,
  ];
}

class UserStats extends Equatable {
  final int resumesCreated;
  final int interviewsSessions;
  final int coverLettersGenerated;
  final int jobApplications;
  final double averageInterviewScore;
  final int streakDays;
  final DateTime? lastActivityDate;
  final Map<String, int> skillPracticeCount;

  const UserStats({
    this.resumesCreated = 0,
    this.interviewsSessions = 0,
    this.coverLettersGenerated = 0,
    this.jobApplications = 0,
    this.averageInterviewScore = 0.0,
    this.streakDays = 0,
    this.lastActivityDate,
    this.skillPracticeCount = const {},
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      resumesCreated: json['resumesCreated'] as int? ?? 0,
      interviewsSessions: json['interviewsSessions'] as int? ?? 0,
      coverLettersGenerated: json['coverLettersGenerated'] as int? ?? 0,
      jobApplications: json['jobApplications'] as int? ?? 0,
      averageInterviewScore: (json['averageInterviewScore'] as num?)?.toDouble() ?? 0.0,
      streakDays: json['streakDays'] as int? ?? 0,
      lastActivityDate: json['lastActivityDate'] != null
          ? DateTime.parse(json['lastActivityDate'] as String)
          : null,
      skillPracticeCount: Map<String, int>.from(json['skillPracticeCount'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resumesCreated': resumesCreated,
      'interviewsSessions': interviewsSessions,
      'coverLettersGenerated': coverLettersGenerated,
      'jobApplications': jobApplications,
      'averageInterviewScore': averageInterviewScore,
      'streakDays': streakDays,
      'lastActivityDate': lastActivityDate?.toIso8601String(),
      'skillPracticeCount': skillPracticeCount,
    };
  }

  UserStats copyWith({
    int? resumesCreated,
    int? interviewsSessions,
    int? coverLettersGenerated,
    int? jobApplications,
    double? averageInterviewScore,
    int? streakDays,
    DateTime? lastActivityDate,
    Map<String, int>? skillPracticeCount,
  }) {
    return UserStats(
      resumesCreated: resumesCreated ?? this.resumesCreated,
      interviewsSessions: interviewsSessions ?? this.interviewsSessions,
      coverLettersGenerated: coverLettersGenerated ?? this.coverLettersGenerated,
      jobApplications: jobApplications ?? this.jobApplications,
      averageInterviewScore: averageInterviewScore ?? this.averageInterviewScore,
      streakDays: streakDays ?? this.streakDays,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      skillPracticeCount: skillPracticeCount ?? this.skillPracticeCount,
    );
  }

  @override
  List<Object?> get props => [
    resumesCreated,
    interviewsSessions,
    coverLettersGenerated,
    jobApplications,
    averageInterviewScore,
    streakDays,
    lastActivityDate,
    skillPracticeCount,
  ];
}