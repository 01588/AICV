// lib/features/resume/models/template_model.dart

enum TemplateCategory {
  modern,
  classic,
  creative,
  minimal,
  professional,
  academic,
}

enum SuggestionType {
  skill,
  experience,
  education,
  achievement,
  keyword,
  formatting,
}

class ResumeTemplate {
  final String id;
  final String name;
  final String description;
  final TemplateCategory category;
  final String previewImageUrl;
  final bool isPremium;
  final double rating;
  final int usageCount;
  final List<String> tags;
  final Map<String, dynamic> layout;
  final Map<String, dynamic> styling;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ResumeTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.previewImageUrl,
    required this.isPremium,
    required this.rating,
    required this.usageCount,
    required this.tags,
    required this.layout,
    required this.styling,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ResumeTemplate.fromJson(Map<String, dynamic> json) {
    return ResumeTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: TemplateCategory.values.firstWhere(
            (e) => e.toString().split('.').last == json['category'],
      ),
      previewImageUrl: json['previewImageUrl'] as String,
      isPremium: json['isPremium'] as bool,
      rating: (json['rating'] as num).toDouble(),
      usageCount: json['usageCount'] as int,
      tags: List<String>.from(json['tags'] as List),
      layout: Map<String, dynamic>.from(json['layout'] as Map),
      styling: Map<String, dynamic>.from(json['styling'] as Map),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category.toString().split('.').last,
      'previewImageUrl': previewImageUrl,
      'isPremium': isPremium,
      'rating': rating,
      'usageCount': usageCount,
      'tags': tags,
      'layout': layout,
      'styling': styling,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ResumeTemplate copyWith({
    String? id,
    String? name,
    String? description,
    TemplateCategory? category,
    String? previewImageUrl,
    bool? isPremium,
    double? rating,
    int? usageCount,
    List<String>? tags,
    Map<String, dynamic>? layout,
    Map<String, dynamic>? styling,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ResumeTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      previewImageUrl: previewImageUrl ?? this.previewImageUrl,
      isPremium: isPremium ?? this.isPremium,
      rating: rating ?? this.rating,
      usageCount: usageCount ?? this.usageCount,
      tags: tags ?? this.tags,
      layout: layout ?? this.layout,
      styling: styling ?? this.styling,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ResumeSuggestion {
  final String id;
  final SuggestionType type;
  final String title;
  final String description;
  final String content;
  final double confidence;
  final List<String> keywords;
  final bool isApplied;
  final DateTime createdAt;

  const ResumeSuggestion({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.content,
    required this.confidence,
    required this.keywords,
    required this.isApplied,
    required this.createdAt,
  });

  factory ResumeSuggestion.fromJson(Map<String, dynamic> json) {
    return ResumeSuggestion(
      id: json['id'] as String,
      type: SuggestionType.values.firstWhere(
            (e) => e.toString().split('.').last == json['type'],
      ),
      title: json['title'] as String,
      description: json['description'] as String,
      content: json['content'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      keywords: List<String>.from(json['keywords'] as List),
      isApplied: json['isApplied'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'title': title,
      'description': description,
      'content': content,
      'confidence': confidence,
      'keywords': keywords,
      'isApplied': isApplied,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  ResumeSuggestion copyWith({
    String? id,
    SuggestionType? type,
    String? title,
    String? description,
    String? content,
    double? confidence,
    List<String>? keywords,
    bool? isApplied,
    DateTime? createdAt,
  }) {
    return ResumeSuggestion(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      confidence: confidence ?? this.confidence,
      keywords: keywords ?? this.keywords,
      isApplied: isApplied ?? this.isApplied,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ResumeSection {
  final String id;
  final String name;
  final String type;
  final int order;
  final bool isRequired;
  final bool isVisible;
  final Map<String, dynamic> content;
  final Map<String, dynamic> styling;

  const ResumeSection({
    required this.id,
    required this.name,
    required this.type,
    required this.order,
    required this.isRequired,
    required this.isVisible,
    required this.content,
    required this.styling,
  });

  factory ResumeSection.fromJson(Map<String, dynamic> json) {
    return ResumeSection(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      order: json['order'] as int,
      isRequired: json['isRequired'] as bool,
      isVisible: json['isVisible'] as bool,
      content: Map<String, dynamic>.from(json['content'] as Map),
      styling: Map<String, dynamic>.from(json['styling'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'order': order,
      'isRequired': isRequired,
      'isVisible': isVisible,
      'content': content,
      'styling': styling,
    };
  }

  ResumeSection copyWith({
    String? id,
    String? name,
    String? type,
    int? order,
    bool? isRequired,
    bool? isVisible,
    Map<String, dynamic>? content,
    Map<String, dynamic>? styling,
  }) {
    return ResumeSection(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      order: order ?? this.order,
      isRequired: isRequired ?? this.isRequired,
      isVisible: isVisible ?? this.isVisible,
      content: content ?? this.content,
      styling: styling ?? this.styling,
    );
  }
}

class Resume {
  final String id;
  final String userId;
  final String name;
  final String templateId;
  final Map<String, dynamic> personalInfo;
  final List<ResumeSection> sections;
  final List<ResumeSuggestion> suggestions;
  final double atsScore;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPublic;
  final List<String> tags;

  const Resume({
    required this.id,
    required this.userId,
    required this.name,
    required this.templateId,
    required this.personalInfo,
    required this.sections,
    required this.suggestions,
    required this.atsScore,
    required this.createdAt,
    required this.updatedAt,
    required this.isPublic,
    required this.tags,
  });

  factory Resume.fromJson(Map<String, dynamic> json) {
    return Resume(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      templateId: json['templateId'] as String,
      personalInfo: Map<String, dynamic>.from(json['personalInfo'] as Map),
      sections: (json['sections'] as List)
          .map((section) => ResumeSection.fromJson(section as Map<String, dynamic>))
          .toList(),
      suggestions: (json['suggestions'] as List)
          .map((suggestion) => ResumeSuggestion.fromJson(suggestion as Map<String, dynamic>))
          .toList(),
      atsScore: (json['atsScore'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isPublic: json['isPublic'] as bool,
      tags: List<String>.from(json['tags'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'templateId': templateId,
      'personalInfo': personalInfo,
      'sections': sections.map((section) => section.toJson()).toList(),
      'suggestions': suggestions.map((suggestion) => suggestion.toJson()).toList(),
      'atsScore': atsScore,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isPublic': isPublic,
      'tags': tags,
    };
  }

  Resume copyWith({
    String? id,
    String? userId,
    String? name,
    String? templateId,
    Map<String, dynamic>? personalInfo,
    List<ResumeSection>? sections,
    List<ResumeSuggestion>? suggestions,
    double? atsScore,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPublic,
    List<String>? tags,
  }) {
    return Resume(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      templateId: templateId ?? this.templateId,
      personalInfo: personalInfo ?? this.personalInfo,
      sections: sections ?? this.sections,
      suggestions: suggestions ?? this.suggestions,
      atsScore: atsScore ?? this.atsScore,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPublic: isPublic ?? this.isPublic,
      tags: tags ?? this.tags,
    );
  }

  // Helper methods
  ResumeSection? getSectionByType(String type) {
    try {
      return sections.firstWhere((section) => section.type == type);
    } catch (e) {
      return null;
    }
  }

  List<ResumeSection> getVisibleSections() {
    return sections.where((section) => section.isVisible).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  List<ResumeSuggestion> getUnappliedSuggestions() {
    return suggestions.where((suggestion) => !suggestion.isApplied).toList();
  }

  List<ResumeSuggestion> getSuggestionsByType(SuggestionType type) {
    return suggestions.where((suggestion) => suggestion.type == type).toList();
  }

  bool get isComplete {
    final requiredSections = sections.where((section) => section.isRequired);
    return requiredSections.every((section) =>
    section.content.isNotEmpty &&
        section.content.values.any((value) => value != null && value.toString().isNotEmpty)
    );
  }

  int get completionPercentage {
    if (sections.isEmpty) return 0;

    final completedSections = sections.where((section) {
      if (!section.isRequired) return true;
      return section.content.isNotEmpty &&
          section.content.values.any((value) => value != null && value.toString().isNotEmpty);
    }).length;

    return ((completedSections / sections.length) * 100).round();
  }
}