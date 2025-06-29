// lib/features/interview/models/interview_model.dart

enum InterviewType {
  technical,
  behavioral,
  mixed,
  phone,
  video,
  panel,
}

enum DifficultyLevel {
  entry,
  mid,
  senior,
  executive,
}

enum InterviewStatus {
  scheduled,
  inProgress,
  completed,
  cancelled,
}

class InterviewQuestion {
  final String id;
  final String question;
  final InterviewType type;
  final DifficultyLevel difficulty;
  final String category;
  final List<String> keywords;
  final String? tips;
  final int estimatedTimeMinutes;

  const InterviewQuestion({
    required this.id,
    required this.question,
    required this.type,
    required this.difficulty,
    required this.category,
    required this.keywords,
    this.tips,
    required this.estimatedTimeMinutes,
  });

  factory InterviewQuestion.fromJson(Map<String, dynamic> json) {
    return InterviewQuestion(
      id: json['id'] as String,
      question: json['question'] as String,
      type: InterviewType.values.firstWhere(
            (e) => e.toString().split('.').last == json['type'],
      ),
      difficulty: DifficultyLevel.values.firstWhere(
            (e) => e.toString().split('.').last == json['difficulty'],
      ),
      category: json['category'] as String,
      keywords: List<String>.from(json['keywords'] as List),
      tips: json['tips'] as String?,
      estimatedTimeMinutes: json['estimatedTimeMinutes'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'type': type.toString().split('.').last,
      'difficulty': difficulty.toString().split('.').last,
      'category': category,
      'keywords': keywords,
      'tips': tips,
      'estimatedTimeMinutes': estimatedTimeMinutes,
    };
  }

  InterviewQuestion copyWith({
    String? id,
    String? question,
    InterviewType? type,
    DifficultyLevel? difficulty,
    String? category,
    List<String>? keywords,
    String? tips,
    int? estimatedTimeMinutes,
  }) {
    return InterviewQuestion(
      id: id ?? this.id,
      question: question ?? this.question,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
      keywords: keywords ?? this.keywords,
      tips: tips ?? this.tips,
      estimatedTimeMinutes: estimatedTimeMinutes ?? this.estimatedTimeMinutes,
    );
  }
}

class InterviewAnswer {
  final String questionId;
  final String answer;
  final DateTime timestamp;
  final Duration responseTime;
  final double? confidenceScore;
  final List<String>? detectedKeywords;

  const InterviewAnswer({
    required this.questionId,
    required this.answer,
    required this.timestamp,
    required this.responseTime,
    this.confidenceScore,
    this.detectedKeywords,
  });

  factory InterviewAnswer.fromJson(Map<String, dynamic> json) {
    return InterviewAnswer(
      questionId: json['questionId'] as String,
      answer: json['answer'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      responseTime: Duration(milliseconds: json['responseTimeMs'] as int),
      confidenceScore: json['confidenceScore'] as double?,
      detectedKeywords: json['detectedKeywords'] != null
          ? List<String>.from(json['detectedKeywords'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'answer': answer,
      'timestamp': timestamp.toIso8601String(),
      'responseTimeMs': responseTime.inMilliseconds,
      'confidenceScore': confidenceScore,
      'detectedKeywords': detectedKeywords,
    };
  }
}

class InterviewFeedback {
  final String id;
  final String questionId;
  final double overallScore;
  final double relevanceScore;
  final double clarityScore;
  final double completenessScore;
  final String strengths;
  final String areasForImprovement;
  final List<String> suggestions;
  final DateTime createdAt;

  const InterviewFeedback({
    required this.id,
    required this.questionId,
    required this.overallScore,
    required this.relevanceScore,
    required this.clarityScore,
    required this.completenessScore,
    required this.strengths,
    required this.areasForImprovement,
    required this.suggestions,
    required this.createdAt,
  });

  factory InterviewFeedback.fromJson(Map<String, dynamic> json) {
    return InterviewFeedback(
      id: json['id'] as String,
      questionId: json['questionId'] as String,
      overallScore: (json['overallScore'] as num).toDouble(),
      relevanceScore: (json['relevanceScore'] as num).toDouble(),
      clarityScore: (json['clarityScore'] as num).toDouble(),
      completenessScore: (json['completenessScore'] as num).toDouble(),
      strengths: json['strengths'] as String,
      areasForImprovement: json['areasForImprovement'] as String,
      suggestions: List<String>.from(json['suggestions'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionId': questionId,
      'overallScore': overallScore,
      'relevanceScore': relevanceScore,
      'clarityScore': clarityScore,
      'completenessScore': completenessScore,
      'strengths': strengths,
      'areasForImprovement': areasForImprovement,
      'suggestions': suggestions,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class InterviewSession {
  final String id;
  final String userId;
  final String jobTitle;
  final String company;
  final InterviewType type;
  final DifficultyLevel difficulty;
  final InterviewStatus status;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final List<InterviewQuestion> questions;
  final List<InterviewAnswer> answers;
  final List<InterviewFeedback> feedback;
  final double? overallScore;
  final Duration? totalDuration;

  const InterviewSession({
    required this.id,
    required this.userId,
    required this.jobTitle,
    required this.company,
    required this.type,
    required this.difficulty,
    required this.status,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
    required this.questions,
    required this.answers,
    required this.feedback,
    this.overallScore,
    this.totalDuration,
  });

  factory InterviewSession.fromJson(Map<String, dynamic> json) {
    return InterviewSession(
      id: json['id'] as String,
      userId: json['userId'] as String,
      jobTitle: json['jobTitle'] as String,
      company: json['company'] as String,
      type: InterviewType.values.firstWhere(
            (e) => e.toString().split('.').last == json['type'],
      ),
      difficulty: DifficultyLevel.values.firstWhere(
            (e) => e.toString().split('.').last == json['difficulty'],
      ),
      status: InterviewStatus.values.firstWhere(
            (e) => e.toString().split('.').last == json['status'],
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'] as String)
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      questions: (json['questions'] as List)
          .map((q) => InterviewQuestion.fromJson(q as Map<String, dynamic>))
          .toList(),
      answers: (json['answers'] as List)
          .map((a) => InterviewAnswer.fromJson(a as Map<String, dynamic>))
          .toList(),
      feedback: (json['feedback'] as List)
          .map((f) => InterviewFeedback.fromJson(f as Map<String, dynamic>))
          .toList(),
      overallScore: json['overallScore'] as double?,
      totalDuration: json['totalDurationMs'] != null
          ? Duration(milliseconds: json['totalDurationMs'] as int)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'jobTitle': jobTitle,
      'company': company,
      'type': type.toString().split('.').last,
      'difficulty': difficulty.toString().split('.').last,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'startedAt': startedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'questions': questions.map((q) => q.toJson()).toList(),
      'answers': answers.map((a) => a.toJson()).toList(),
      'feedback': feedback.map((f) => f.toJson()).toList(),
      'overallScore': overallScore,
      'totalDurationMs': totalDuration?.inMilliseconds,
    };
  }

  InterviewSession copyWith({
    String? id,
    String? userId,
    String? jobTitle,
    String? company,
    InterviewType? type,
    DifficultyLevel? difficulty,
    InterviewStatus? status,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
    List<InterviewQuestion>? questions,
    List<InterviewAnswer>? answers,
    List<InterviewFeedback>? feedback,
    double? overallScore,
    Duration? totalDuration,
  }) {
    return InterviewSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      jobTitle: jobTitle ?? this.jobTitle,
      company: company ?? this.company,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      feedback: feedback ?? this.feedback,
      overallScore: overallScore ?? this.overallScore,
      totalDuration: totalDuration ?? this.totalDuration,
    );
  }

  bool get isCompleted => status == InterviewStatus.completed;
  bool get isInProgress => status == InterviewStatus.inProgress;

  int get answeredQuestions => answers.length;
  int get totalQuestions => questions.length;

  double get progressPercentage =>
      totalQuestions > 0 ? (answeredQuestions / totalQuestions) * 100 : 0;
}