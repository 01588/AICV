import 'package:equatable/equatable.dart';

// Main Interview Session Model
class InterviewSession extends Equatable {
  final String id;
  final String userId;
  final String jobTitle;
  final String industry;
  final InterviewType type;
  final DifficultyLevel difficulty;
  final InterviewMode mode;
  final DateTime createdAt;
  final DateTime? completedAt;
  final InterviewStatus status;
  final List<InterviewQuestion> questions;
  final List<InterviewResponse> responses;
  final InterviewResults? results;
  final Duration? totalDuration;
  final Map<String, dynamic>? settings;

  const InterviewSession({
    required this.id,
    required this.userId,
    required this.jobTitle,
    required this.industry,
    required this.type,
    required this.difficulty,
    required this.mode,
    required this.createdAt,
    this.completedAt,
    required this.status,
    required this.questions,
    required this.responses,
    this.results,
    this.totalDuration,
    this.settings,
  });

  factory InterviewSession.fromJson(Map<String, dynamic> json) {
    return InterviewSession(
      id: json['id'] as String,
      userId: json['userId'] as String,
      jobTitle: json['jobTitle'] as String,
      industry: json['industry'] as String,
      type: InterviewType.values.firstWhere(
            (type) => type.toString() == json['type'],
        orElse: () => InterviewType.behavioral,
      ),
      difficulty: DifficultyLevel.values.firstWhere(
            (level) => level.toString() == json['difficulty'],
        orElse: () => DifficultyLevel.intermediate,
      ),
      mode: InterviewMode.values.firstWhere(
            (mode) => mode.toString() == json['mode'],
        orElse: () => InterviewMode.text,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      status: InterviewStatus.values.firstWhere(
            (status) => status.toString() == json['status'],
        orElse: () => InterviewStatus.pending,
      ),
      questions: (json['questions'] as List<dynamic>)
          .map((q) => InterviewQuestion.fromJson(q as Map<String, dynamic>))
          .toList(),
      responses: (json['responses'] as List<dynamic>)
          .map((r) => InterviewResponse.fromJson(r as Map<String, dynamic>))
          .toList(),
      results: json['results'] != null
          ? InterviewResults.fromJson(json['results'] as Map<String, dynamic>)
          : null,
      totalDuration: json['totalDuration'] != null
          ? Duration(milliseconds: json['totalDuration'] as int)
          : null,
      settings: json['settings'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'jobTitle': jobTitle,
      'industry': industry,
      'type': type.toString(),
      'difficulty': difficulty.toString(),
      'mode': mode.toString(),
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'status': status.toString(),
      'questions': questions.map((q) => q.toJson()).toList(),
      'responses': responses.map((r) => r.toJson()).toList(),
      'results': results?.toJson(),
      'totalDuration': totalDuration?.inMilliseconds,
      'settings': settings,
    };
  }

  InterviewSession copyWith({
    String? id,
    String? userId,
    String? jobTitle,
    String? industry,
    InterviewType? type,
    DifficultyLevel? difficulty,
    InterviewMode? mode,
    DateTime? createdAt,
    DateTime? completedAt,
    InterviewStatus? status,
    List<InterviewQuestion>? questions,
    List<InterviewResponse>? responses,
    InterviewResults? results,
    Duration? totalDuration,
    Map<String, dynamic>? settings,
  }) {
    return InterviewSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      jobTitle: jobTitle ?? this.jobTitle,
      industry: industry ?? this.industry,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      mode: mode ?? this.mode,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      status: status ?? this.status,
      questions: questions ?? this.questions,
      responses: responses ?? this.responses,
      results: results ?? this.results,
      totalDuration: totalDuration ?? this.totalDuration,
      settings: settings ?? this.settings,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    jobTitle,
    industry,
    type,
    difficulty,
    mode,
    createdAt,
    completedAt,
    status,
    questions,
    responses,
    results,
    totalDuration,
    settings,
  ];
}

// Interview Question Model
class InterviewQuestion extends Equatable {
  final String id;
  final String question;
  final String category;
  final DifficultyLevel difficulty;
  final List<String> keyPoints;
  final List<String> followUpQuestions;
  final List<String> evaluationCriteria;
  final Duration expectedDuration;
  final Map<String, dynamic>? metadata;
  final List<String>? sampleAnswers;
  final String? context;

  const InterviewQuestion({
    required this.id,
    required this.question,
    required this.category,
    required this.difficulty,
    required this.keyPoints,
    this.followUpQuestions = const [],
    required this.evaluationCriteria,
    required this.expectedDuration,
    this.metadata,
    this.sampleAnswers,
    this.context,
  });

  factory InterviewQuestion.fromJson(Map<String, dynamic> json) {
    return InterviewQuestion(
      id: json['id'] as String,
      question: json['question'] as String,
      category: json['category'] as String,
      difficulty: DifficultyLevel.values.firstWhere(
            (level) => level.toString() == json['difficulty'],
        orElse: () => DifficultyLevel.intermediate,
      ),
      keyPoints: (json['keyPoints'] as List<dynamic>).cast<String>(),
      followUpQuestions: (json['followUpQuestions'] as List<dynamic>?)?.cast<String>() ?? [],
      evaluationCriteria: (json['evaluationCriteria'] as List<dynamic>).cast<String>(),
      expectedDuration: Duration(minutes: json['expectedDuration'] as int),
      metadata: json['metadata'] as Map<String, dynamic>?,
      sampleAnswers: (json['sampleAnswers'] as List<dynamic>?)?.cast<String>(),
      context: json['context'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'category': category,
      'difficulty': difficulty.toString(),
      'keyPoints': keyPoints,
      'followUpQuestions': followUpQuestions,
      'evaluationCriteria': evaluationCriteria,
      'expectedDuration': expectedDuration.inMinutes,
      'metadata': metadata,
      'sampleAnswers': sampleAnswers,
      'context': context,
    };
  }

  @override
  List<Object?> get props => [
    id,
    question,
    category,
    difficulty,
    keyPoints,
    followUpQuestions,
    evaluationCriteria,
    expectedDuration,
    metadata,
    sampleAnswers,
    context,
  ];
}

// Interview Response Model
class InterviewResponse extends Equatable {
  final String id;
  final String questionId;
  final String sessionId;
  final String response;
  final DateTime timestamp;
  final Duration responseTime;
  final InterviewMode mode;
  final double? confidenceLevel;
  final String? audioFilePath;
  final String? transcription;
  final Map<String, dynamic>? metadata;

  const InterviewResponse({
    required this.id,
    required this.questionId,
    required this.sessionId,
    required this.response,
    required this.timestamp,
    required this.responseTime,
    required this.mode,
    this.confidenceLevel,
    this.audioFilePath,
    this.transcription,
    this.metadata,
  });

  factory InterviewResponse.fromJson(Map<String, dynamic> json) {
    return InterviewResponse(
      id: json['id'] as String,
      questionId: json['questionId'] as String,
      sessionId: json['sessionId'] as String,
      response: json['response'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      responseTime: Duration(milliseconds: json['responseTime'] as int),
      mode: InterviewMode.values.firstWhere(
            (mode) => mode.toString() == json['mode'],
        orElse: () => InterviewMode.text,
      ),
      confidenceLevel: json['confidenceLevel'] as double?,
      audioFilePath: json['audioFilePath'] as String?,
      transcription: json['transcription'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionId': questionId,
      'sessionId': sessionId,
      'response': response,
      'timestamp': timestamp.toIso8601String(),
      'responseTime': responseTime.inMilliseconds,
      'mode': mode.toString(),
      'confidenceLevel': confidenceLevel,
      'audioFilePath': audioFilePath,
      'transcription': transcription,
      'metadata': metadata,
    };
  }

  @override
  List<Object?> get props => [
    id,
    questionId,
    sessionId,
    response,
    timestamp,
    responseTime,
    mode,
    confidenceLevel,
    audioFilePath,
    transcription,
    metadata,
  ];
}

// Interview Results Model
class InterviewResults extends Equatable {
  final String sessionId;
  final int overallScore;
  final Map<String, int> categoryScores;
  final Map<String, InterviewFeedback> questionFeedback;
  final List<String> strengths;
  final List<String> improvements;
  final List<String> recommendations;
  final Duration totalTime;
  final DateTime generatedAt;
  final Map<String, dynamic>? analytics;

  const InterviewResults({
    required this.sessionId,
    required this.overallScore,
    required this.categoryScores,
    required this.questionFeedback,
    required this.strengths,
    required this.improvements,
    required this.recommendations,
    required this.totalTime,
    required this.generatedAt,
    this.analytics,
  });

  factory InterviewResults.fromJson(Map<String, dynamic> json) {
    return InterviewResults(
      sessionId: json['sessionId'] as String,
      overallScore: json['overallScore'] as int,
      categoryScores: Map<String, int>.from(json['categoryScores'] as Map),
      questionFeedback: (json['questionFeedback'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(
        key,
        InterviewFeedback.fromJson(value as Map<String, dynamic>),
      )),
      strengths: (json['strengths'] as List<dynamic>).cast<String>(),
      improvements: (json['improvements'] as List<dynamic>).cast<String>(),
      recommendations: (json['recommendations'] as List<dynamic>).cast<String>(),
      totalTime: Duration(milliseconds: json['totalTime'] as int),
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      analytics: json['analytics'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'overallScore': overallScore,
      'categoryScores': categoryScores,
      'questionFeedback': questionFeedback
          .map((key, value) => MapEntry(key, value.toJson())),
      'strengths': strengths,
      'improvements': improvements,
      'recommendations': recommendations,
      'totalTime': totalTime.inMilliseconds,
      'generatedAt': generatedAt.toIso8601String(),
      'analytics': analytics,
    };
  }

  @override
  List<Object?> get props => [
    sessionId,
    overallScore,
    categoryScores,
    questionFeedback,
    strengths,
    improvements,
    recommendations,
    totalTime,
    generatedAt,
    analytics,
  ];
}

// Interview Feedback Model
class InterviewFeedback extends Equatable {
  final String questionId;
  final int overallScore;
  final int contentScore;
  final int clarityScore;
  final int completenessScore;
  final List<String> strengths;
  final List<String> improvements;
  final List<String> suggestions;
  final List<String> keyPointsCovered;
  final List<String> keyPointsMissed;
  final String? detailedFeedback;

  const InterviewFeedback({
    required this.questionId,
    required this.overallScore,
    required this.contentScore,
    required this.clarityScore,
    required this.completenessScore,
    required this.strengths,
    required this.improvements,
    required this.suggestions,
    required this.keyPointsCovered,
    required this.keyPointsMissed,
    this.detailedFeedback,
  });

  factory InterviewFeedback.empty() {
    return const InterviewFeedback(
      questionId: '',
      overallScore: 0,
      contentScore: 0,
      clarityScore: 0,
      completenessScore: 0,
      strengths: [],
      improvements: [],
      suggestions: [],
      keyPointsCovered: [],
      keyPointsMissed: [],
    );
  }

  factory InterviewFeedback.fromJson(Map<String, dynamic> json) {
    return InterviewFeedback(
      questionId: json['questionId'] as String? ?? '',
      overallScore: json['overallScore'] as int,
      contentScore: json['contentScore'] as int,
      clarityScore: json['clarityScore'] as int,
      completenessScore: json['completenessScore'] as int,
      strengths: (json['strengths'] as List<dynamic>).cast<String>(),
      improvements: (json['improvements'] as List<dynamic>).cast<String>(),
      suggestions: (json['suggestions'] as List<dynamic>).cast<String>(),
      keyPointsCovered: (json['keyPointsCovered'] as List<dynamic>).cast<String>(),
      keyPointsMissed: (json['keyPointsMissed'] as List<dynamic>).cast<String>(),
      detailedFeedback: json['detailedFeedback'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'overallScore': overallScore,
      'contentScore': contentScore,
      'clarityScore': clarityScore,
      'completenessScore': completenessScore,
      'strengths': strengths,
      'improvements': improvements,
      'suggestions': suggestions,
      'keyPointsCovered': keyPointsCovered,
      'keyPointsMissed': keyPointsMissed,
      'detailedFeedback': detailedFeedback,
    };
  }

  @override
  List<Object?> get props => [
    questionId,
    overallScore,
    contentScore,
    clarityScore,
    completenessScore,
    strengths,
    improvements,
    suggestions,
    keyPointsCovered,
    keyPointsMissed,
    detailedFeedback,
  ];
}

// Interview Statistics Model
class InterviewStatistics extends Equatable {
  final String userId;
  final int totalSessions;
  final int completedSessions;
  final double averageScore;
  final Map<String, double> categoryAverages;
  final Map<String, int> difficultyBreakdown;
  final Duration totalPracticeTime;
  final DateTime lastSessionDate;
  final List<String> improvementTrends;
  final Map<String, int> questionTypeStats;

  const InterviewStatistics({
    required this.userId,
    required this.totalSessions,
    required this.completedSessions,
    required this.averageScore,
    required this.categoryAverages,
    required this.difficultyBreakdown,
    required this.totalPracticeTime,
    required this.lastSessionDate,
    required this.improvementTrends,
    required this.questionTypeStats,
  });

  factory InterviewStatistics.fromJson(Map<String, dynamic> json) {
    return InterviewStatistics(
      userId: json['userId'] as String,
      totalSessions: json['totalSessions'] as int,
      completedSessions: json['completedSessions'] as int,
      averageScore: (json['averageScore'] as num).toDouble(),
      categoryAverages: Map<String, double>.from(json['categoryAverages'] as Map),
      difficultyBreakdown: Map<String, int>.from(json['difficultyBreakdown'] as Map),
      totalPracticeTime: Duration(milliseconds: json['totalPracticeTime'] as int),
      lastSessionDate: DateTime.parse(json['lastSessionDate'] as String),
      improvementTrends: (json['improvementTrends'] as List<dynamic>).cast<String>(),
      questionTypeStats: Map<String, int>.from(json['questionTypeStats'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'totalSessions': totalSessions,
      'completedSessions': completedSessions,
      'averageScore': averageScore,
      'categoryAverages': categoryAverages,
      'difficultyBreakdown': difficultyBreakdown,
      'totalPracticeTime': totalPracticeTime.inMilliseconds,
      'lastSessionDate': lastSessionDate.toIso8601String(),
      'improvementTrends': improvementTrends,
      'questionTypeStats': questionTypeStats,
    };
  }

  @override
  List<Object?> get props => [
    userId,
    totalSessions,
    completedSessions,
    averageScore,
    categoryAverages,
    difficultyBreakdown,
    totalPracticeTime,
    lastSessionDate,
    improvementTrends,
    questionTypeStats,
  ];
}

// Enums
enum InterviewType {
  technical,
  behavioral,
  situational,
  competency,
  mixed,
}

enum InterviewMode {
  text,
  voice,
  video,
}

enum DifficultyLevel {
  beginner,
  intermediate,
  advanced,
  expert,
}

enum InterviewStatus {
  pending,
  inProgress,
  completed,
  abandoned,
  paused,
}

// Extension methods for enums
extension InterviewTypeExtension on InterviewType {
  String get displayName {
    switch (this) {
      case InterviewType.technical:
        return 'Technical';
      case InterviewType.behavioral:
        return 'Behavioral';
      case InterviewType.situational:
        return 'Situational';
      case InterviewType.competency:
        return 'Competency-Based';
      case InterviewType.mixed:
        return 'Mixed';
    }
  }

  String get description {
    switch (this) {
      case InterviewType.technical:
        return 'Focus on technical skills and problem-solving abilities';
      case InterviewType.behavioral:
        return 'Questions about past experiences and behavior patterns';
      case InterviewType.situational:
        return 'Hypothetical scenarios and how you would handle them';
      case InterviewType.competency:
        return 'Specific competencies required for the role';
      case InterviewType.mixed:
        return 'Combination of different interview question types';
    }
  }
}

extension InterviewModeExtension on InterviewMode {
  String get displayName {
    switch (this) {
      case InterviewMode.text:
        return 'Text Response';
      case InterviewMode.voice:
        return 'Voice Response';
      case InterviewMode.video:
        return 'Video Response';
    }
  }

  String get description {
    switch (this) {
      case InterviewMode.text:
        return 'Type your responses to interview questions';
      case InterviewMode.voice:
        return 'Speak your responses aloud for voice analysis';
      case InterviewMode.video:
        return 'Record video responses for comprehensive feedback';
    }
  }
}

extension DifficultyLevelExtension on DifficultyLevel {
  String get displayName {
    switch (this) {
      case DifficultyLevel.beginner:
        return 'Beginner';
      case DifficultyLevel.intermediate:
        return 'Intermediate';
      case DifficultyLevel.advanced:
        return 'Advanced';
      case DifficultyLevel.expert:
        return 'Expert';
    }
  }

  String get description {
    switch (this) {
      case DifficultyLevel.beginner:
        return 'Entry-level questions for new professionals';
      case DifficultyLevel.intermediate:
        return 'Mid-level questions for experienced professionals';
      case DifficultyLevel.advanced:
        return 'Senior-level questions requiring deep expertise';
      case DifficultyLevel.expert:
        return 'Executive-level questions for leadership roles';
    }
  }

  int get experienceYears {
    switch (this) {
      case DifficultyLevel.beginner:
        return 1;
      case DifficultyLevel.intermediate:
        return 3;
      case DifficultyLevel.advanced:
        return 7;
      case DifficultyLevel.expert:
        return 12;
    }
  }
}

extension InterviewStatusExtension on InterviewStatus {
  String get displayName {
    switch (this) {
      case InterviewStatus.pending:
        return 'Pending';
      case InterviewStatus.inProgress:
        return 'In Progress';
      case InterviewStatus.completed:
        return 'Completed';
      case InterviewStatus.abandoned:
        return 'Abandoned';
      case InterviewStatus.paused:
        return 'Paused';
    }
  }

  bool get isActive {
    return this == InterviewStatus.inProgress || this == InterviewStatus.paused;
  }

  bool get isCompleted {
    return this == InterviewStatus.completed;
  }
}