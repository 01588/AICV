import 'package:equatable/equatable.dart';

// Main Resume Model
class ResumeModel extends Equatable {
  final String id;
  final PersonalInfo personalInfo;
  final ProfessionalInfo professionalInfo;
  final List<Skill> skills;
  final List<Education> education;
  final ResumeTemplate template;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ResumeSection> sections;
  final List<String> keywords;
  final int atsScore;
  final String? linkedinUrl;
  final String? portfolioUrl;

  const ResumeModel({
    required this.id,
    required this.personalInfo,
    required this.professionalInfo,
    required this.skills,
    required this.education,
    required this.template,
    required this.createdAt,
    required this.updatedAt,
    required this.sections,
    required this.keywords,
    this.atsScore = 0,
    this.linkedinUrl,
    this.portfolioUrl,
  });

  factory ResumeModel.fromJson(Map<String, dynamic> json) {
    return ResumeModel(
      id: json['id'] as String,
      personalInfo: PersonalInfo.fromJson(json['personalInfo'] as Map<String, dynamic>),
      professionalInfo: ProfessionalInfo.fromJson(json['professionalInfo'] as Map<String, dynamic>),
      skills: (json['skills'] as List<dynamic>)
          .map((skill) => Skill.fromJson(skill as Map<String, dynamic>))
          .toList(),
      education: (json['education'] as List<dynamic>)
          .map((edu) => Education.fromJson(edu as Map<String, dynamic>))
          .toList(),
      template: ResumeTemplate.fromJson(json['template'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      sections: (json['sections'] as List<dynamic>)
          .map((section) => ResumeSection.fromJson(section as Map<String, dynamic>))
          .toList(),
      keywords: (json['keywords'] as List<dynamic>).cast<String>(),
      atsScore: json['atsScore'] as int? ?? 0,
      linkedinUrl: json['linkedinUrl'] as String?,
      portfolioUrl: json['portfolioUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personalInfo': personalInfo.toJson(),
      'professionalInfo': professionalInfo.toJson(),
      'skills': skills.map((skill) => skill.toJson()).toList(),
      'education': education.map((edu) => edu.toJson()).toList(),
      'template': template.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'sections': sections.map((section) => section.toJson()).toList(),
      'keywords': keywords,
      'atsScore': atsScore,
      'linkedinUrl': linkedinUrl,
      'portfolioUrl': portfolioUrl,
    };
  }

  ResumeModel copyWith({
    String? id,
    PersonalInfo? personalInfo,
    ProfessionalInfo? professionalInfo,
    List<Skill>? skills,
    List<Education>? education,
    ResumeTemplate? template,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ResumeSection>? sections,
    List<String>? keywords,
    int? atsScore,
    String? linkedinUrl,
    String? portfolioUrl,
  }) {
    return ResumeModel(
      id: id ?? this.id,
      personalInfo: personalInfo ?? this.personalInfo,
      professionalInfo: professionalInfo ?? this.professionalInfo,
      skills: skills ?? this.skills,
      education: education ?? this.education,
      template: template ?? this.template,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sections: sections ?? this.sections,
      keywords: keywords ?? this.keywords,
      atsScore: atsScore ?? this.atsScore,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      portfolioUrl: portfolioUrl ?? this.portfolioUrl,
    );
  }

  @override
  List<Object?> get props => [
    id,
    personalInfo,
    professionalInfo,
    skills,
    education,
    template,
    createdAt,
    updatedAt,
    sections,
    keywords,
    atsScore,
    linkedinUrl,
    portfolioUrl,
  ];
}

// Personal Information Model
class PersonalInfo extends Equatable {
  final String fullName;
  final String email;
  final String phone;
  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;
  final String? linkedinUrl;
  final String? portfolioUrl;
  final String? githubUrl;
  final String? profilePhoto;

  const PersonalInfo({
    required this.fullName,
    required this.email,
    required this.phone,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.linkedinUrl,
    this.portfolioUrl,
    this.githubUrl,
    this.profilePhoto,
  });

  factory PersonalInfo.empty() {
    return const PersonalInfo(
      fullName: '',
      email: '',
      phone: '',
    );
  }

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zipCode: json['zipCode'] as String?,
      country: json['country'] as String?,
      linkedinUrl: json['linkedinUrl'] as String?,
      portfolioUrl: json['portfolioUrl'] as String?,
      githubUrl: json['githubUrl'] as String?,
      profilePhoto: json['profilePhoto'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'linkedinUrl': linkedinUrl,
      'portfolioUrl': portfolioUrl,
      'githubUrl': githubUrl,
      'profilePhoto': profilePhoto,
    };
  }

  PersonalInfo copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    String? linkedinUrl,
    String? portfolioUrl,
    String? githubUrl,
    String? profilePhoto,
  }) {
    return PersonalInfo(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      portfolioUrl: portfolioUrl ?? this.portfolioUrl,
      githubUrl: githubUrl ?? this.githubUrl,
      profilePhoto: profilePhoto ?? this.profilePhoto,
    );
  }

  @override
  List<Object?> get props => [
    fullName,
    email,
    phone,
    address,
    city,
    state,
    zipCode,
    country,
    linkedinUrl,
    portfolioUrl,
    githubUrl,
    profilePhoto,
  ];
}

// Professional Information Model
class ProfessionalInfo extends Equatable {
  final String summary;
  final String targetJobTitle;
  final String industry;
  final List<WorkExperience> workExperience;
  final List<String> certifications;
  final List<String> languages;
  final List<Project> projects;

  const ProfessionalInfo({
    required this.summary,
    required this.targetJobTitle,
    required this.industry,
    required this.workExperience,
    this.certifications = const [],
    this.languages = const [],
    this.projects = const [],
  });

  factory ProfessionalInfo.empty() {
    return const ProfessionalInfo(
      summary: '',
      targetJobTitle: '',
      industry: '',
      workExperience: [],
    );
  }

  factory ProfessionalInfo.fromJson(Map<String, dynamic> json) {
    return ProfessionalInfo(
      summary: json['summary'] as String,
      targetJobTitle: json['targetJobTitle'] as String,
      industry: json['industry'] as String,
      workExperience: (json['workExperience'] as List<dynamic>)
          .map((exp) => WorkExperience.fromJson(exp as Map<String, dynamic>))
          .toList(),
      certifications: (json['certifications'] as List<dynamic>?)?.cast<String>() ?? [],
      languages: (json['languages'] as List<dynamic>?)?.cast<String>() ?? [],
      projects: (json['projects'] as List<dynamic>?)
          ?.map((proj) => Project.fromJson(proj as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary,
      'targetJobTitle': targetJobTitle,
      'industry': industry,
      'workExperience': workExperience.map((exp) => exp.toJson()).toList(),
      'certifications': certifications,
      'languages': languages,
      'projects': projects.map((proj) => proj.toJson()).toList(),
    };
  }

  ProfessionalInfo copyWith({
    String? summary,
    String? targetJobTitle,
    String? industry,
    List<WorkExperience>? workExperience,
    List<String>? certifications,
    List<String>? languages,
    List<Project>? projects,
  }) {
    return ProfessionalInfo(
      summary: summary ?? this.summary,
      targetJobTitle: targetJobTitle ?? this.targetJobTitle,
      industry: industry ?? this.industry,
      workExperience: workExperience ?? this.workExperience,
      certifications: certifications ?? this.certifications,
      languages: languages ?? this.languages,
      projects: projects ?? this.projects,
    );
  }

  @override
  List<Object?> get props => [
    summary,
    targetJobTitle,
    industry,
    workExperience,
    certifications,
    languages,
    projects,
  ];
}

// Work Experience Model
class WorkExperience extends Equatable {
  final String id;
  final String company;
  final String position;
  final String location;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrent;
  final String description;
  final List<String> responsibilities;
  final List<String> achievements;
  final List<String> technologies;

  const WorkExperience({
    required this.id,
    required this.company,
    required this.position,
    required this.location,
    required this.startDate,
    this.endDate,
    this.isCurrent = false,
    required this.description,
    this.responsibilities = const [],
    this.achievements = const [],
    this.technologies = const [],
  });

  factory WorkExperience.fromJson(Map<String, dynamic> json) {
    return WorkExperience(
      id: json['id'] as String,
      company: json['company'] as String,
      position: json['position'] as String,
      location: json['location'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
      isCurrent: json['isCurrent'] as bool? ?? false,
      description: json['description'] as String,
      responsibilities: (json['responsibilities'] as List<dynamic>?)?.cast<String>() ?? [],
      achievements: (json['achievements'] as List<dynamic>?)?.cast<String>() ?? [],
      technologies: (json['technologies'] as List<dynamic>?)?.cast<String>() ?? [],
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
      'responsibilities': responsibilities,
      'achievements': achievements,
      'technologies': technologies,
    };
  }

  WorkExperience copyWith({
    String? id,
    String? company,
    String? position,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCurrent,
    String? description,
    List<String>? responsibilities,
    List<String>? achievements,
    List<String>? technologies,
  }) {
    return WorkExperience(
      id: id ?? this.id,
      company: company ?? this.company,
      position: position ?? this.position,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCurrent: isCurrent ?? this.isCurrent,
      description: description ?? this.description,
      responsibilities: responsibilities ?? this.responsibilities,
      achievements: achievements ?? this.achievements,
      technologies: technologies ?? this.technologies,
    );
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
    responsibilities,
    achievements,
    technologies,
  ];
}

// Skill Model
class Skill extends Equatable {
  final String id;
  final String name;
  final SkillLevel level;
  final SkillCategory category;
  final int yearsOfExperience;
  final bool isFeatured;

  const Skill({
    required this.id,
    required this.name,
    required this.level,
    required this.category,
    this.yearsOfExperience = 0,
    this.isFeatured = false,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] as String,
      name: json['name'] as String,
      level: SkillLevel.values.firstWhere(
            (level) => level.toString() == json['level'],
        orElse: () => SkillLevel.intermediate,
      ),
      category: SkillCategory.values.firstWhere(
            (category) => category.toString() == json['category'],
        orElse: () => SkillCategory.technical,
      ),
      yearsOfExperience: json['yearsOfExperience'] as int? ?? 0,
      isFeatured: json['isFeatured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level.toString(),
      'category': category.toString(),
      'yearsOfExperience': yearsOfExperience,
      'isFeatured': isFeatured,
    };
  }

  Skill copyWith({
    String? id,
    String? name,
    SkillLevel? level,
    SkillCategory? category,
    int? yearsOfExperience,
    bool? isFeatured,
  }) {
    return Skill(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      category: category ?? this.category,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    level,
    category,
    yearsOfExperience,
    isFeatured,
  ];
}

// Education Model
class Education extends Equatable {
  final String id;
  final String institution;
  final String degree;
  final String fieldOfStudy;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrent;
  final double? gpa;
  final String? description;
  final List<String> achievements;
  final List<String> coursework;

  const Education({
    required this.id,
    required this.institution,
    required this.degree,
    required this.fieldOfStudy,
    required this.startDate,
    this.endDate,
    this.isCurrent = false,
    this.gpa,
    this.description,
    this.achievements = const [],
    this.coursework = const [],
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'] as String,
      institution: json['institution'] as String,
      degree: json['degree'] as String,
      fieldOfStudy: json['fieldOfStudy'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
      isCurrent: json['isCurrent'] as bool? ?? false,
      gpa: json['gpa'] as double?,
      description: json['description'] as String?,
      achievements: (json['achievements'] as List<dynamic>?)?.cast<String>() ?? [],
      coursework: (json['coursework'] as List<dynamic>?)?.cast<String>() ?? [],
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
      'achievements': achievements,
      'coursework': coursework,
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
    achievements,
    coursework,
  ];
}

// Project Model
class Project extends Equatable {
  final String id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrent;
  final String? url;
  final String? repositoryUrl;
  final List<String> technologies;
  final List<String> achievements;

  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    this.endDate,
    this.isCurrent = false,
    this.url,
    this.repositoryUrl,
    this.technologies = const [],
    this.achievements = const [],
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
      isCurrent: json['isCurrent'] as bool? ?? false,
      url: json['url'] as String?,
      repositoryUrl: json['repositoryUrl'] as String?,
      technologies: (json['technologies'] as List<dynamic>?)?.cast<String>() ?? [],
      achievements: (json['achievements'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isCurrent': isCurrent,
      'url': url,
      'repositoryUrl': repositoryUrl,
      'technologies': technologies,
      'achievements': achievements,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    startDate,
    endDate,
    isCurrent,
    url,
    repositoryUrl,
    technologies,
    achievements,
  ];
}

// Resume Template Model
class ResumeTemplate extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category;
  final String previewImageUrl;
  final Map<String, dynamic> styling;
  final List<String> supportedSections;
  final bool isPremium;
  final double rating;
  final int usageCount;

  const ResumeTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.previewImageUrl,
    required this.styling,
    required this.supportedSections,
    this.isPremium = false,
    this.rating = 0.0,
    this.usageCount = 0,
  });

  factory ResumeTemplate.fromJson(Map<String, dynamic> json) {
    return ResumeTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      previewImageUrl: json['previewImageUrl'] as String,
      styling: json['styling'] as Map<String, dynamic>,
      supportedSections: (json['supportedSections'] as List<dynamic>).cast<String>(),
      isPremium: json['isPremium'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      usageCount: json['usageCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'previewImageUrl': previewImageUrl,
      'styling': styling,
      'supportedSections': supportedSections,
      'isPremium': isPremium,
      'rating': rating,
      'usageCount': usageCount,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    category,
    previewImageUrl,
    styling,
    supportedSections,
    isPremium,
    rating,
    usageCount,
  ];
}

// Resume Section Model
class ResumeSection extends Equatable {
  final String id;
  final SectionType type;
  final String title;
  final Map<String, dynamic> content;
  final int order;
  final bool isVisible;
  final Map<String, dynamic>? styling;

  const ResumeSection({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.order,
    this.isVisible = true,
    this.styling,
  });

  factory ResumeSection.fromJson(Map<String, dynamic> json) {
    return ResumeSection(
      id: json['id'] as String,
      type: SectionType.values.firstWhere(
            (type) => type.toString() == json['type'],
        orElse: () => SectionType.custom,
      ),
      title: json['title'] as String,
      content: json['content'] as Map<String, dynamic>,
      order: json['order'] as int,
      isVisible: json['isVisible'] as bool? ?? true,
      styling: json['styling'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString(),
      'title': title,
      'content': content,
      'order': order,
      'isVisible': isVisible,
      'styling': styling,
    };
  }

  @override
  List<Object?> get props => [
    id,
    type,
    title,
    content,
    order,
    isVisible,
    styling,
  ];
}

// AI Suggestion Model
class AISuggestion extends Equatable {
  final String id;
  final SuggestionType type;
  final String title;
  final String content;
  final String reasoning;
  final double confidence;
  final String? targetSection;
  final Map<String, dynamic>? metadata;

  const AISuggestion({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.reasoning,
    required this.confidence,
    this.targetSection,
    this.metadata,
  });

  factory AISuggestion.fromJson(Map<String, dynamic> json) {
    return AISuggestion(
      id: json['id'] as String,
      type: SuggestionType.values.firstWhere(
            (type) => type.toString() == json['type'],
        orElse: () => SuggestionType.general,
      ),
      title: json['title'] as String,
      content: json['content'] as String,
      reasoning: json['reasoning'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      targetSection: json['targetSection'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString(),
      'title': title,
      'content': content,
      'reasoning': reasoning,
      'confidence': confidence,
      'targetSection': targetSection,
      'metadata': metadata,
    };
  }

  @override
  List<Object?> get props => [
    id,
    type,
    title,
    content,
    reasoning,
    confidence,
    targetSection,
    metadata,
  ];
}

// Resume Analytics Model
class ResumeAnalytics extends Equatable {
  final int atsScore;
  final Map<String, double> sectionScores;
  final List<String> strengthAreas;
  final List<String> improvementAreas;
  final Map<String, int> keywordDensity;
  final double readabilityScore;
  final int estimatedReadingTime;
  final List<AISuggestion> recommendations;

  const ResumeAnalytics({
    required this.atsScore,
    required this.sectionScores,
    required this.strengthAreas,
    required this.improvementAreas,
    required this.keywordDensity,
    required this.readabilityScore,
    required this.estimatedReadingTime,
    required this.recommendations,
  });

  factory ResumeAnalytics.empty() {
    return const ResumeAnalytics(
      atsScore: 0,
      sectionScores: {},
      strengthAreas: [],
      improvementAreas: [],
      keywordDensity: {},
      readabilityScore: 0.0,
      estimatedReadingTime: 0,
      recommendations: [],
    );
  }

  factory ResumeAnalytics.fromJson(Map<String, dynamic> json) {
    return ResumeAnalytics(
      atsScore: json['atsScore'] as int,
      sectionScores: Map<String, double>.from(json['sectionScores'] as Map),
      strengthAreas: (json['strengthAreas'] as List<dynamic>).cast<String>(),
      improvementAreas: (json['improvementAreas'] as List<dynamic>).cast<String>(),
      keywordDensity: Map<String, int>.from(json['keywordDensity'] as Map),
      readabilityScore: (json['readabilityScore'] as num).toDouble(),
      estimatedReadingTime: json['estimatedReadingTime'] as int,
      recommendations: (json['recommendations'] as List<dynamic>)
          .map((rec) => AISuggestion.fromJson(rec as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'atsScore': atsScore,
      'sectionScores': sectionScores,
      'strengthAreas': strengthAreas,
      'improvementAreas': improvementAreas,
      'keywordDensity': keywordDensity,
      'readabilityScore': readabilityScore,
      'estimatedReadingTime': estimatedReadingTime,
      'recommendations': recommendations.map((rec) => rec.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
    atsScore,
    sectionScores,
    strengthAreas,
    improvementAreas,
    keywordDensity,
    readabilityScore,
    estimatedReadingTime,
    recommendations,
  ];
}

// Enums
enum SkillLevel {
  beginner,
  intermediate,
  advanced,
  expert,
}

enum SkillCategory {
  technical,
  soft,
  language,
  certification,
  tool,
}

enum SectionType {
  header,
  summary,
  experience,
  education,
  skills,
  projects,
  certifications,
  languages,
  references,
  custom,
}

enum SuggestionType {
  summary,
  skill,
  achievement,
  education,
  keyword,
  formatting,
  general,
}

// Extension methods for enums
extension SkillLevelExtension on SkillLevel {
  String get displayName {
    switch (this) {
      case SkillLevel.beginner:
        return 'Beginner';
      case SkillLevel.intermediate:
        return 'Intermediate';
      case SkillLevel.advanced:
        return 'Advanced';
      case SkillLevel.expert:
        return 'Expert';
    }
  }

  double get progressValue {
    switch (this) {
      case SkillLevel.beginner:
        return 0.25;
      case SkillLevel.intermediate:
        return 0.5;
      case SkillLevel.advanced:
        return 0.75;
      case SkillLevel.expert:
        return 1.0;
    }
  }
}

extension SkillCategoryExtension on SkillCategory {
  String get displayName {
    switch (this) {
      case SkillCategory.technical:
        return 'Technical';
      case SkillCategory.soft:
        return 'Soft Skills';
      case SkillCategory.language:
        return 'Languages';
      case SkillCategory.certification:
        return 'Certifications';
      case SkillCategory.tool:
        return 'Tools';
    }
  }
}

extension SectionTypeExtension on SectionType {
  String get displayName {
    switch (this) {
      case SectionType.header:
        return 'Header';
      case SectionType.summary:
        return 'Professional Summary';
      case SectionType.experience:
        return 'Work Experience';
      case SectionType.education:
        return 'Education';
      case SectionType.skills:
        return 'Skills';
      case SectionType.projects:
        return 'Projects';
      case SectionType.certifications:
        return 'Certifications';
      case SectionType.languages:
        return 'Languages';
      case SectionType.references:
        return 'References';
      case SectionType.custom:
        return 'Custom Section';
    }
  }
}