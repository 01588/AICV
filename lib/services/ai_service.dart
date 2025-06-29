// lib/core/services/ai_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/utils/exceptions.dart';
import '../core/utils/logger.dart';
import '../features/interview/models/interview_models.dart';


class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  static const String _openAIBaseUrl = 'https://api.openai.com/v1';
  static const Duration _timeout = Duration(seconds: 30);

  String? _apiKey;
  final http.Client _client = http.Client();

  void initialize(String apiKey) {
    _apiKey = apiKey;
    Logger.info('AI Service initialized', tag: 'AI');
  }

  Map<String, String> get _headers {
    if (_apiKey == null) {
      throw AIException('AI API key not configured');
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
    };
  }

  // Resume optimization
  Future<Map<String, dynamic>> optimizeResume({
    required Map<String, dynamic> resumeData,
    required String jobDescription,
    String? industry,
  }) async {
    try {
      Logger.info('Starting resume optimization', tag: 'AI');

      final prompt = _buildResumeOptimizationPrompt(resumeData, jobDescription, industry);

      final response = await _makeChatCompletionRequest(
        prompt: prompt,
        maxTokens: 2000,
        temperature: 0.7,
      );

      Logger.info('Resume optimization completed successfully', tag: 'AI');
      return _parseResumeOptimizationResponse(response);
    } catch (e) {
      Logger.error('Resume optimization failed', tag: 'AI', error: e);
      throw AIException('Failed to optimize resume: $e');
    }
  }

  // Cover letter generation
  Future<String> generateCoverLetter({
    required Map<String, dynamic> userProfile,
    required String companyName,
    required String jobTitle,
    required String jobDescription,
    String tone = 'professional',
  }) async {
    try {
      Logger.info('Generating cover letter for $jobTitle at $companyName', tag: 'AI');

      final prompt = _buildCoverLetterPrompt(
          userProfile, companyName, jobTitle, jobDescription, tone
      );

      final response = await _makeChatCompletionRequest(
        prompt: prompt,
        maxTokens: 1500,
        temperature: 0.8,
      );

      final coverLetter = response['choices'][0]['message']['content'] as String;
      Logger.info('Cover letter generated successfully', tag: 'AI');
      return coverLetter.trim();
    } catch (e) {
      Logger.error('Cover letter generation failed', tag: 'AI', error: e);
      throw AIException('Failed to generate cover letter: $e');
    }
  }

  // Interview question generation
  Future<List<InterviewQuestion>> generateInterviewQuestions({
    required String jobTitle,
    required String company,
    required InterviewType type,
    required DifficultyLevel difficulty,
    int count = 10,
  }) async {
    try {
      Logger.info('Generating $count ${type.name} interview questions for $jobTitle', tag: 'AI');

      final prompt = _buildInterviewQuestionsPrompt(jobTitle, company, type, difficulty, count);

      final response = await _makeChatCompletionRequest(
        prompt: prompt,
        maxTokens: 2500,
        temperature: 0.9,
      );

      final questions = _parseInterviewQuestionsResponse(response, type, difficulty);
      Logger.info('Generated ${questions.length} interview questions', tag: 'AI');
      return questions;
    } catch (e) {
      Logger.error('Interview question generation failed', tag: 'AI', error: e);
      throw AIException('Failed to generate interview questions: $e');
    }
  }

  // Interview answer evaluation
  Future<InterviewFeedback> evaluateInterviewAnswer({
    required InterviewQuestion question,
    required String answer,
    String? jobContext,
  }) async {
    try {
      Logger.info('Evaluating answer for question: ${question.id}', tag: 'AI');

      final prompt = _buildAnswerEvaluationPrompt(question, answer, jobContext);

      final response = await _makeChatCompletionRequest(
        prompt: prompt,
        maxTokens: 1000,
        temperature: 0.3,
      );

      final feedback = _parseAnswerEvaluationResponse(response, question.id);
      Logger.info('Answer evaluation completed', tag: 'AI');
      return feedback;
    } catch (e) {
      Logger.error('Answer evaluation failed', tag: 'AI', error: e);
      return InterviewFeedback.empty(question.id);
    }
  }

  // Career advice generation
  Future<String> generateCareerAdvice({
    required Map<String, dynamic> userProfile,
    required String query,
    List<String>? context,
  }) async {
    try {
      Logger.info('Generating career advice', tag: 'AI');

      final prompt = _buildCareerAdvicePrompt(userProfile, query, context);

      final response = await _makeChatCompletionRequest(
        prompt: prompt,
        maxTokens: 1200,
        temperature: 0.7,
      );

      final advice = response['choices'][0]['message']['content'] as String;
      Logger.info('Career advice generated successfully', tag: 'AI');
      return advice.trim();
    } catch (e) {
      Logger.error('Career advice generation failed', tag: 'AI', error: e);
      throw AIException('Failed to generate career advice: $e');
    }
  }

  // Skill gap analysis
  Future<Map<String, dynamic>> analyzeSkillGap({
    required List<String> currentSkills,
    required String targetRole,
    String? industry,
  }) async {
    try {
      Logger.info('Analyzing skill gap for $targetRole', tag: 'AI');

      final prompt = _buildSkillGapAnalysisPrompt(currentSkills, targetRole, industry);

      final response = await _makeChatCompletionRequest(
        prompt: prompt,
        maxTokens: 1500,
        temperature: 0.6,
      );

      final analysis = _parseSkillGapAnalysisResponse(response);
      Logger.info('Skill gap analysis completed', tag: 'AI');
      return analysis;
    } catch (e) {
      Logger.error('Skill gap analysis failed', tag: 'AI', error: e);
      throw AIException('Failed to analyze skill gap: $e');
    }
  }

  // Job description analysis
  Future<Map<String, dynamic>> analyzeJobDescription(String jobDescription) async {
    try {
      Logger.info('Analyzing job description', tag: 'AI');

      final prompt = _buildJobDescriptionAnalysisPrompt(jobDescription);

      final response = await _makeChatCompletionRequest(
        prompt: prompt,
        maxTokens: 1000,
        temperature: 0.4,
      );

      final analysis = _parseJobDescriptionAnalysisResponse(response);
      Logger.info('Job description analysis completed', tag: 'AI');
      return analysis;
    } catch (e) {
      Logger.error('Job description analysis failed', tag: 'AI', error: e);
      throw AIException('Failed to analyze job description: $e');
    }
  }

  // Private helper methods
  Future<Map<String, dynamic>> _makeChatCompletionRequest({
    required String prompt,
    int maxTokens = 1000,
    double temperature = 0.7,
    String model = 'gpt-3.5-turbo',
  }) async {
    final body = {
      'model': model,
      'messages': [
        {'role': 'user', 'content': prompt}
      ],
      'max_tokens': maxTokens,
      'temperature': temperature,
    };

    final response = await _client
        .post(
      Uri.parse('$_openAIBaseUrl/chat/completions'),
      headers: _headers,
      body: json.encode(body),
    )
        .timeout(_timeout);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      Logger.error('AI API request failed', tag: 'AI', error: 'Status: ${response.statusCode}, Body: ${response.body}');
      throw AIException('AI API request failed: ${response.statusCode}');
    }
  }

  String _buildResumeOptimizationPrompt(
      Map<String, dynamic> resumeData,
      String jobDescription,
      String? industry,
      ) {
    return '''
Optimize this resume for the following job description. Provide suggestions for improvements, keyword optimization, and ATS compatibility.

Resume Data: ${json.encode(resumeData)}

Job Description: $jobDescription

${industry != null ? 'Industry: $industry' : ''}

Please provide a JSON response with the following structure:
{
  "ats_score": 85,
  "suggestions": [
    {
      "type": "keyword",
      "section": "skills",
      "original": "JavaScript",
      "suggested": "JavaScript, React.js, Node.js",
      "reason": "Include related technologies mentioned in job description"
    }
  ],
  "missing_keywords": ["keyword1", "keyword2"],
  "optimization_tips": ["tip1", "tip2"]
}
''';
  }

  String _buildCoverLetterPrompt(
      Map<String, dynamic> userProfile,
      String companyName,
      String jobTitle,
      String jobDescription,
      String tone,
      ) {
    return '''
Generate a compelling cover letter for the following position:

Company: $companyName
Position: $jobTitle
Tone: $tone

User Profile: ${json.encode(userProfile)}

Job Description: $jobDescription

The cover letter should be:
- Tailored to the specific role and company
- Highlight relevant experience and skills
- Show enthusiasm and cultural fit
- Be concise (2-3 paragraphs)
- Professional yet engaging
''';
  }

  String _buildInterviewQuestionsPrompt(
      String jobTitle,
      String company,
      InterviewType type,
      DifficultyLevel difficulty,
      int count,
      ) {
    return '''
Generate $count ${type.name} interview questions for a $jobTitle position at $company.
Difficulty level: ${difficulty.name}

Requirements:
- Questions should be relevant to the role and industry
- Vary in complexity and focus areas
- Include follow-up questions where appropriate
- Provide context and expectations for each question

Format as JSON array:
[
  {
    "question": "Tell me about a challenging project you worked on",
    "category": "behavioral",
    "keywords": ["leadership", "problem-solving"],
    "tips": "Use the STAR method to structure your answer",
    "estimatedTimeMinutes": 5
  }
]
''';
  }

  String _buildAnswerEvaluationPrompt(
      InterviewQuestion question,
      String answer,
      String? jobContext,
      ) {
    return '''
Evaluate this interview answer and provide detailed feedback.

Question: ${question.question}
Category: ${question.category}
Expected Keywords: ${question.keywords.join(', ')}

Answer: $answer

${jobContext != null ? 'Job Context: $jobContext' : ''}

Provide feedback in JSON format:
{
  "overallScore": 85,
  "relevanceScore": 90,
  "clarityScore": 80,
  "completenessScore": 85,
  "strengths": "Clear structure and relevant examples",
  "areasForImprovement": "Could provide more specific metrics",
  "suggestions": ["Include quantifiable results", "Add more technical details"]
}
''';
  }

  String _buildCareerAdvicePrompt(
      Map<String, dynamic> userProfile,
      String query,
      List<String>? context,
      ) {
    return '''
Provide personalized career advice based on the user's profile and query.

User Profile: ${json.encode(userProfile)}

Query: $query

${context != null ? 'Additional Context: ${context.join(', ')}' : ''}

Provide actionable, specific advice that considers:
- Current career stage and goals
- Industry trends and opportunities
- Skill development recommendations
- Practical next steps
''';
  }

  String _buildSkillGapAnalysisPrompt(
      List<String> currentSkills,
      String targetRole,
      String? industry,
      ) {
    return '''
Analyze the skill gap between current skills and target role requirements.

Current Skills: ${currentSkills.join(', ')}
Target Role: $targetRole
${industry != null ? 'Industry: $industry' : ''}

Provide analysis in JSON format:
{
  "matchingSkills": ["skill1", "skill2"],
  "missingSkills": ["skill3", "skill4"],
  "skillsToImprove": ["skill5", "skill6"],
  "recommendations": [
    {
      "skill": "Python",
      "priority": "high",
      "timeline": "3-6 months",
      "resources": ["online courses", "projects"]
    }
  ],
  "overallReadiness": 70
}
''';
  }

  String _buildJobDescriptionAnalysisPrompt(String jobDescription) {
    return '''
Analyze this job description and extract key information.

Job Description: $jobDescription

Provide analysis in JSON format:
{
  "requiredSkills": ["skill1", "skill2"],
  "preferredSkills": ["skill3", "skill4"],
  "experienceLevel": "mid-level",
  "keyResponsibilities": ["responsibility1", "responsibility2"],
  "companySize": "medium",
  "workType": "remote",
  "benefits": ["benefit1", "benefit2"],
  "redFlags": ["flag1"],
  "matchScore": 85
}
''';
  }

  // Response parsing methods
  Map<String, dynamic> _parseResumeOptimizationResponse(Map<String, dynamic> response) {
    try {
      final content = response['choices'][0]['message']['content'] as String;
      return json.decode(content);
    } catch (e) {
      Logger.error('Failed to parse resume optimization response', tag: 'AI', error: e);
      return {
        'ats_score': 70,
        'suggestions': [],
        'missing_keywords': [],
        'optimization_tips': ['Unable to generate specific suggestions at this time']
      };
    }
  }

  List<InterviewQuestion> _parseInterviewQuestionsResponse(
      Map<String, dynamic> response,
      InterviewType type,
      DifficultyLevel difficulty,
      ) {
    try {
      final content = response['choices'][0]['message']['content'] as String;
      final questionsJson = json.decode(content) as List;

      return questionsJson.map((questionData) {
        return InterviewQuestion(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          question: questionData['question'] as String,
          type: type,
          difficulty: difficulty,
          category: questionData['category'] as String? ?? type.name,
          keywords: List<String>.from(questionData['keywords'] ?? []),
          tips: questionData['tips'] as String?,
          estimatedTimeMinutes: questionData['estimatedTimeMinutes'] as int? ?? 5, keyPoints: [],
        );
      }).toList();
    } catch (e) {
      Logger.error('Failed to parse interview questions response', tag: 'AI', error: e);
      return [];
    }
  }

  InterviewFeedback _parseAnswerEvaluationResponse(
      Map<String, dynamic> response,
      String questionId,
      ) {
    try {
      final content = response['choices'][0]['message']['content'] as String;
      final feedbackData = json.decode(content);

      return InterviewFeedback(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        questionId: questionId,
        overallScore: (feedbackData['overallScore'] as num).toDouble(),
        relevanceScore: (feedbackData['relevanceScore'] as num).toDouble(),
        clarityScore: (feedbackData['clarityScore'] as num).toDouble(),
        completenessScore: (feedbackData['completenessScore'] as num).toDouble(),
        strengths: feedbackData['strengths'] as String,
        areasForImprovement: feedbackData['areasForImprovement'] as String,
        suggestions: List<String>.from(feedbackData['suggestions'] ?? []),
        createdAt: DateTime.now(),
      );
    } catch (e) {
      Logger.error('Failed to parse answer evaluation response', tag: 'AI', error: e);
      return InterviewFeedback.empty(questionId);
    }
  }

  Map<String, dynamic> _parseSkillGapAnalysisResponse(Map<String, dynamic> response) {
    try {
      final content = response['choices'][0]['message']['content'] as String;
      return json.decode(content);
    } catch (e) {
      Logger.error('Failed to parse skill gap analysis response', tag: 'AI', error: e);
      return {
        'matchingSkills': [],
        'missingSkills': [],
        'skillsToImprove': [],
        'recommendations': [],
        'overallReadiness': 0
      };
    }
  }

  Map<String, dynamic> _parseJobDescriptionAnalysisResponse(Map<String, dynamic> response) {
    try {
      final content = response['choices'][0]['message']['content'] as String;
      return json.decode(content);
    } catch (e) {
      Logger.error('Failed to parse job description analysis response', tag: 'AI', error: e);
      return {
        'requiredSkills': [],
        'preferredSkills': [],
        'experienceLevel': 'unknown',
        'keyResponsibilities': [],
        'matchScore': 0
      };
    }
  }

  void dispose() {
    _client.close();
  }
}