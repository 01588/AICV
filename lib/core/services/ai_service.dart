import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../utils/logger.dart';
import '../../features/resume/models/resume_model.dart';
import '../../features/interview/models/interview_model.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  static AIService get instance => _instance;
  AIService._internal();

  final http.Client _httpClient = http.Client();
  final Logger _logger = Logger('AIService');

  // Base URLs for different AI services
  static const String _openAIBaseUrl = 'https://api.openai.com/v1';
  static const String _claudeBaseUrl = 'https://api.anthropic.com/v1';

  // API Keys (should be stored securely)
  String? _openAIApiKey;
  String? _claudeApiKey;

  Future<void> initialize() async {
    _openAIApiKey = AppConfig.openAIApiKey;
    _claudeApiKey = AppConfig.claudeApiKey;
    _logger.info('AI Service initialized');
  }

  // Resume Enhancement
  Future<ResumeModel> enhanceResume(ResumeModel resume) async {
    try {
      _logger.info('Enhancing resume for user: ${resume.id}');

      final prompt = _buildResumeEnhancementPrompt(resume);
      final response = await _callOpenAI(
        'chat/completions',
        {
          'model': 'gpt-4',
          'messages': [
            {
              'role': 'system',
              'content': '''You are an expert resume writer and career coach. Your task is to enhance resumes to be more effective, ATS-friendly, and compelling to recruiters. Focus on:
              
1. Improving action verbs and impact statements
2. Quantifying achievements where possible
3. Optimizing for ATS keywords
4. Ensuring clear, professional language
5. Maintaining authenticity while maximizing impact

Return the enhanced content in the same JSON structure provided.'''
            },
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.3,
          'max_tokens': 2000,
        },
      );

      final enhancedContent = json.decode(response['choices'][0]['message']['content']);

      return _applyEnhancements(resume, enhancedContent);
    } catch (e) {
      _logger.error('Failed to enhance resume', error: e);
      rethrow;
    }
  }

  // ATS Score Calculation
  Future<int> calculateATSScore(ResumeModel resume) async {
    try {
      _logger.info('Calculating ATS score for resume: ${resume.id}');

      final prompt = _buildATSAnalysisPrompt(resume);
      final response = await _callOpenAI(
        'chat/completions',
        {
          'model': 'gpt-4',
          'messages': [
            {
              'role': 'system',
              'content': '''You are an ATS (Applicant Tracking System) analyzer. Evaluate resumes based on:

1. Keyword optimization (25 points)
2. Format compatibility (20 points)
3. Section organization (15 points)
4. Contact information completeness (10 points)
5. Skills relevance (15 points)
6. Experience quantification (15 points)

Return only a JSON object with:
{
  "atsScore": <number 0-100>,
  "breakdown": {
    "keywords": <score>,
    "format": <score>,
    "organization": <score>,
    "contact": <score>,
    "skills": <score>,
    "experience": <score>
  },
  "improvements": ["list", "of", "suggestions"]
}'''
            },
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.1,
          'max_tokens': 1000,
        },
      );

      final result = json.decode(response['choices'][0]['message']['content']);
      return result['atsScore'] as int;
    } catch (e) {
      _logger.error('Failed to calculate ATS score', error: e);
      return 75; // Default score
    }
  }

  // Resume Analytics
  Future<ResumeAnalytics> analyzeResume(ResumeModel resume) async {
    try {
      _logger.info('Analyzing resume: ${resume.id}');

      final prompt = _buildResumeAnalysisPrompt(resume);
      final response = await _callClaude(
        'messages',
        {
          'model': 'claude-3-sonnet-20240229',
          'max_tokens': 2000,
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
        },
      );

      final analysis = json.decode(response['content'][0]['text']);
      return ResumeAnalytics.fromJson(analysis);
    } catch (e) {
      _logger.error('Failed to analyze resume', error: e);
      return ResumeAnalytics.empty();
    }
  }

  // Generate AI Suggestions
  Future<List<AISuggestion>> generatePersonalInfoSuggestions(PersonalInfo personalInfo) async {
    try {
      final prompt = '''
Analyze this personal information and provide suggestions for improvement:

Name: ${personalInfo.fullName}
Email: ${personalInfo.email}
Phone: ${personalInfo.phone}
LinkedIn: ${personalInfo.linkedinUrl ?? 'Not provided'}
Portfolio: ${personalInfo.portfolioUrl ?? 'Not provided'}

Provide 2-3 specific suggestions for enhancing the professional presentation.
      ''';

      return await _generateSuggestions(prompt, SuggestionType.general);
    } catch (e) {
      _logger.error('Failed to generate personal info suggestions', error: e);
      return [];
    }
  }

  Future<List<AISuggestion>> generateProfessionalSuggestions(ProfessionalInfo professionalInfo) async {
    try {
      final prompt = '''
Analyze this professional summary and work experience, then provide specific suggestions:

Summary: ${professionalInfo.summary}
Target Job Title: ${professionalInfo.targetJobTitle}
Industry: ${professionalInfo.industry}

Work Experience:
${professionalInfo.workExperience.map((exp) => '''
Company: ${exp.company}
Position: ${exp.position}
Description: ${exp.description}
Achievements: ${exp.achievements.join(', ')}
''').join('\n')}

Provide 3-5 suggestions for improving impact, clarity, and ATS optimization.
      ''';

      return await _generateSuggestions(prompt, SuggestionType.summary);
    } catch (e) {
      _logger.error('Failed to generate professional suggestions', error: e);
      return [];
    }
  }

  Future<List<AISuggestion>> generateSkillsSuggestions(List<Skill> skills, ProfessionalInfo professionalInfo) async {
    try {
      final prompt = '''
Based on the target role "${professionalInfo.targetJobTitle}" in "${professionalInfo.industry}", 
analyze these current skills and suggest improvements:

Current Skills:
${skills.map((skill) => '${skill.name} (${skill.level.displayName})').join(', ')}

Provide suggestions for:
1. Missing important skills for the target role
2. Skills that should be emphasized more
3. Skills that might be less relevant
      ''';

      return await _generateSuggestions(prompt, SuggestionType.skill);
    } catch (e) {
      _logger.error('Failed to generate skills suggestions', error: e);
      return [];
    }
  }

  Future<List<AISuggestion>> generateEducationSuggestions(List<Education> education) async {
    try {
      final prompt = '''
Analyze this education information and provide suggestions:

${education.map((edu) => '''
Institution: ${edu.institution}
Degree: ${edu.degree}
Field: ${edu.fieldOfStudy}
GPA: ${edu.gpa ?? 'Not provided'}
Achievements: ${edu.achievements.join(', ')}
''').join('\n')}

Provide suggestions for better presenting educational background.
      ''';

      return await _generateSuggestions(prompt, SuggestionType.education);
    } catch (e) {
      _logger.error('Failed to generate education suggestions', error: e);
      return [];
    }
  }

  // Interview Question Generation
  Future<List<InterviewQuestion>> generateInterviewQuestions({
    required String jobTitle,
    required String industry,
    required InterviewType type,
    required DifficultyLevel difficulty,
    int count = 10,
  }) async {
    try {
      _logger.info('Generating interview questions for $jobTitle position');

      final prompt = '''
Generate $count ${type.name} interview questions for a $jobTitle position in the $industry industry.
Difficulty level: ${difficulty.name}

For each question, provide:
1. The question text
2. Key points that should be covered in a good answer
3. Follow-up questions if applicable
4. Evaluation criteria

Return as JSON array with this structure:
[
  {
    "id": "unique_id",
    "question": "question text",
    "category": "category",
    "difficulty": "${difficulty.name}",
    "keyPoints": ["point1", "point2"],
    "followUpQuestions": ["follow1", "follow2"],
    "evaluationCriteria": ["criteria1", "criteria2"],
    "expectedDuration": minutes
  }
]
      ''';

      final response = await _callOpenAI(
        'chat/completions',
        {
          'model': 'gpt-4',
          'messages': [
            {
              'role': 'system',
              'content': 'You are an expert interviewer and career coach specializing in creating effective interview questions.'
            },
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.7,
          'max_tokens': 3000,
        },
      );

      final questionsJson = json.decode(response['choices'][0]['message']['content']) as List;
      return questionsJson.map((q) => InterviewQuestion.fromJson(q)).toList();
    } catch (e) {
      _logger.error('Failed to generate interview questions', error: e);
      return [];
    }
  }

  // Interview Response Analysis
  Future<InterviewFeedback> analyzeInterviewResponse({
    required InterviewQuestion question,
    required String userResponse,
    required Duration responseTime,
  }) async {
    try {
      _logger.info('Analyzing interview response for question: ${question.id}');

      final prompt = '''
Analyze this interview response:

Question: ${question.question}
Category: ${question.category}
Expected Key Points: ${question.keyPoints.join(', ')}

User Response: "$userResponse"
Response Time: ${responseTime.inSeconds} seconds

Provide detailed feedback including:
1. Content quality score (0-100)
2. Communication clarity score (0-100)
3. Completeness score (0-100)
4. Areas done well
5. Areas for improvement
6. Specific suggestions for better answers

Return as JSON with this structure:
{
  "overallScore": number,
  "contentScore": number,
  "clarityScore": number,
  "completenessScore": number,
  "strengths": ["strength1", "strength2"],
  "improvements": ["improvement1", "improvement2"],
  "suggestions": ["suggestion1", "suggestion2"],
  "keyPointsCovered": ["covered1", "covered2"],
  "keyPointsMissed": ["missed1", "missed2"]
}
      ''';

      final response = await _callClaude(
        'messages',
        {
          'model': 'claude-3-sonnet-20240229',
          'max_tokens': 1500,
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
        },
      );

      final feedbackJson = json.decode(response['content'][0]['text']);
      return InterviewFeedback.fromJson(feedbackJson);
    } catch (e) {
      _logger.error('Failed to analyze interview response', error: e);
      return InterviewFeedback.empty();
    }
  }

  // Job Posting Analysis
  Future<List<AISuggestion>> analyzeJobPostingForResume(String jobPosting, ResumeModel resume) async {
    try {
      _logger.info('Analyzing job posting for resume optimization');

      final prompt = '''
Analyze this job posting and compare it with the provided resume to suggest optimizations:

JOB POSTING:
$jobPosting

CURRENT RESUME SUMMARY:
Summary: ${resume.professionalInfo.summary}
Skills: ${resume.skills.map((s) => s.name).join(', ')}
Experience: ${resume.professionalInfo.workExperience.map((e) => '${e.position} at ${e.company}').join(', ')}

Provide specific suggestions for:
1. Keywords to add or emphasize
2. Skills to highlight
3. Experience points to modify
4. Summary improvements
5. Missing qualifications to address

Focus on making the resume more aligned with this specific job posting.
      ''';

      return await _generateSuggestions(prompt, SuggestionType.keyword);
    } catch (e) {
      _logger.error('Failed to analyze job posting', error: e);
      return [];
    }
  }

  // Template Recommendations
  Future<List<ResumeTemplate>> getTemplateRecommendations({
    required String industry,
    required String jobTitle,
  }) async {
    try {
      // This would typically call an API or use a recommendation engine
      // For now, return hardcoded recommendations based on industry
      return _getTemplatesByIndustry(industry);
    } catch (e) {
      _logger.error('Failed to get template recommendations', error: e);
      return [];
    }
  }

  // Cover Letter Generation
  Future<String> generateCoverLetter({
    required PersonalInfo personalInfo,
    required String company,
    required String position,
    required String jobDescription,
    required List<Skill> skills,
    required List<WorkExperience> experience,
    required String tone,
  }) async {
    try {
      _logger.info('Generating cover letter for $position at $company');

      final prompt = '''
Generate a professional cover letter for:

Applicant: ${personalInfo.fullName}
Position: $position
Company: $company
Tone: $tone

Key Skills: ${skills.map((s) => s.name).take(5).join(', ')}

Relevant Experience:
${experience.take(2).map((exp) => '''
- ${exp.position} at ${exp.company}: ${exp.description}
''').join('\n')}

Job Description:
$jobDescription

Create a compelling, personalized cover letter that:
1. Addresses the hiring manager professionally
2. Shows enthusiasm for the role and company
3. Highlights relevant experience and achievements
4. Demonstrates knowledge of the company
5. Includes a strong call to action
6. Maintains the specified tone throughout

Keep it to 3-4 paragraphs and under 400 words.
      ''';

      final response = await _callOpenAI(
        'chat/completions',
        {
          'model': 'gpt-4',
          'messages': [
            {
              'role': 'system',
              'content': 'You are an expert cover letter writer who creates compelling, personalized cover letters that get results.'
            },
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.7,
          'max_tokens': 1000,
        },
      );

      return response['choices'][0]['message']['content'] as String;
    } catch (e) {
      _logger.error('Failed to generate cover letter', error: e);
      rethrow;
    }
  }

  // Helper Methods
  Future<Map<String, dynamic>> _callOpenAI(String endpoint, Map<String, dynamic> data) async {
    final response = await _httpClient.post(
      Uri.parse('$_openAIBaseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_openAIApiKey',
      },
      body: json.encode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('OpenAI API error: ${response.statusCode} - ${response.body}');
    }

    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> _callClaude(String endpoint, Map<String, dynamic> data) async {
    final response = await _httpClient.post(
      Uri.parse('$_claudeBaseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': '$_claudeApiKey',
        'anthropic-version': '2023-06-01',
      },
      body: json.encode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Claude API error: ${response.statusCode} - ${response.body}');
    }

    return json.decode(response.body) as Map<String, dynamic>;
  }

  String _buildResumeEnhancementPrompt(ResumeModel resume) {
    return '''
Please enhance this resume content for better impact and ATS optimization:

PERSONAL INFO:
${json.encode(resume.personalInfo.toJson())}

PROFESSIONAL SUMMARY:
${resume.professionalInfo.summary}

WORK EXPERIENCE:
${json.encode(resume.professionalInfo.workExperience.map((e) => e.toJson()).toList())}

SKILLS:
${json.encode(resume.skills.map((s) => s.toJson()).toList())}

EDUCATION:
${json.encode(resume.education.map((e) => e.toJson()).toList())}

Focus on improving action verbs, quantifying achievements, and optimizing for the ${resume.professionalInfo.industry} industry.
    ''';
  }

  String _buildATSAnalysisPrompt(ResumeModel resume) {
    return '''
Analyze this resume for ATS compatibility:

Target Role: ${resume.professionalInfo.targetJobTitle}
Industry: ${resume.professionalInfo.industry}

CONTENT ANALYSIS:
- Professional Summary: ${resume.professionalInfo.summary}
- Skills Count: ${resume.skills.length}
- Experience Entries: ${resume.professionalInfo.workExperience.length}
- Education Entries: ${resume.education.length}
- Keywords: ${resume.keywords.take(20).join(', ')}

STRUCTURE:
- Sections: ${resume.sections.map((s) => s.title).join(', ')}
- Template: ${resume.template.name}

Evaluate for ATS optimization and provide a comprehensive score with breakdown.
    ''';
  }

  String _buildResumeAnalysisPrompt(ResumeModel resume) {
    return '''
Provide a comprehensive analysis of this resume:

${json.encode({
      'personalInfo': resume.personalInfo.toJson(),
      'professionalInfo': resume.professionalInfo.toJson(),
      'skills': resume.skills.map((s) => s.toJson()).toList(),
      'education': resume.education.map((e) => e.toJson()).toList(),
      'targetRole': resume.professionalInfo.targetJobTitle,
      'industry': resume.professionalInfo.industry,
    })}

Return a detailed analysis with scores, strengths, improvements, and actionable recommendations.
    ''';
  }

  Future<List<AISuggestion>> _generateSuggestions(String prompt, SuggestionType type) async {
    final response = await _callOpenAI(
      'chat/completions',
      {
        'model': 'gpt-3.5-turbo',
        'messages': [
          {
            'role': 'system',
            'content': '''You are a career counselor providing specific, actionable suggestions. 
            Return your response as a JSON array of suggestions with this structure:
            [
              {
                "id": "unique_id",
                "type": "${type.toString()}",
                "title": "Brief title",
                "content": "Specific suggestion or enhanced content",
                "reasoning": "Why this suggestion helps",
                "confidence": 0.85
              }
            ]'''
          },
          {
            'role': 'user',
            'content': prompt,
          }
        ],
        'temperature': 0.7,
        'max_tokens': 1500,
      },
    );

    try {
      final suggestionsJson = json.decode(response['choices'][0]['message']['content']) as List;
      return suggestionsJson.map((s) => AISuggestion.fromJson(s)).toList();
    } catch (e) {
      _logger.error('Failed to parse AI suggestions', error: e);
      return [];
    }
  }

  ResumeModel _applyEnhancements(ResumeModel resume, Map<String, dynamic> enhancements) {
    try {
      // Apply enhancements to the resume model
      // This would parse the AI response and update relevant fields

      // For now, return the original resume with updated timestamp
      return resume.copyWith(updatedAt: DateTime.now());
    } catch (e) {
      _logger.error('Failed to apply enhancements', error: e);
      return resume;
    }
  }

  List<ResumeTemplate> _getTemplatesByIndustry(String industry) {
    // This would typically be loaded from a database or API
    // Returning hardcoded templates for demo purposes
    final templates = <ResumeTemplate>[
      ResumeTemplate(
        id: '1',
        name: 'Modern Professional',
        description: 'Clean, modern design perfect for tech and creative industries',
        category: 'Modern',
        previewImageUrl: 'https://example.com/template1.png',
        styling: {
          'primaryColor': '#1E3A8A',
          'fontFamily': 'Poppins',
          'layout': 'single-column'
        },
        supportedSections: ['header', 'summary', 'experience', 'skills', 'education'],
        isPremium: false,
        rating: 4.8,
        usageCount: 15420,
      ),
      ResumeTemplate(
        id: '2',
        name: 'Executive Elite',
        description: 'Sophisticated design for senior-level positions',
        category: 'Professional',
        previewImageUrl: 'https://example.com/template2.png',
        styling: {
          'primaryColor': '#374151',
          'fontFamily': 'Times New Roman',
          'layout': 'two-column'
        },
        supportedSections: ['header', 'summary', 'experience', 'skills', 'education', 'certifications'],
        isPremium: true,
        rating: 4.9,
        usageCount: 8930,
      ),
      ResumeTemplate(
        id: '3',
        name: 'Creative Spark',
        description: 'Bold, creative design for design and marketing roles',
        category: 'Creative',
        previewImageUrl: 'https://example.com/template3.png',
        styling: {
          'primaryColor': '#8B5CF6',
          'fontFamily': 'Montserrat',
          'layout': 'creative'
        },
        supportedSections: ['header', 'summary', 'experience', 'skills', 'education', 'projects'],
        isPremium: true,
        rating: 4.7,
        usageCount: 6750,
      ),
    ];

    // Filter templates based on industry
    switch (industry.toLowerCase()) {
      case 'technology':
      case 'software':
        return templates.where((t) => t.category == 'Modern').toList();
      case 'finance':
      case 'consulting':
        return templates.where((t) => t.category == 'Professional').toList();
      case 'design':
      case 'marketing':
        return templates.where((t) => t.category == 'Creative').toList();
      default:
        return templates;
    }
  }

  // Text Analysis and Optimization
  Future<String> optimizeText({
    required String text,
    required String context,
    required String targetAudience,
  }) async {
    try {
      final prompt = '''
Optimize this text for $context targeting $targetAudience:

Original text: "$text"

Make it more:
- Impactful and engaging
- Professional and polished
- Action-oriented
- ATS-friendly (if applicable)

Return only the optimized text without explanations.
      ''';

      final response = await _callOpenAI(
        'chat/completions',
        {
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': 'You are an expert copywriter specializing in professional communication.'
            },
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.7,
          'max_tokens': 500,
        },
      );

      return response['choices'][0]['message']['content'] as String;
    } catch (e) {
      _logger.error('Failed to optimize text', error: e);
      return text; // Return original text if optimization fails
    }
  }

  // Keyword Extraction
  Future<List<String>> extractKeywords(String text, String industry) async {
    try {
      final prompt = '''
Extract the most important professional keywords from this text for the $industry industry:

"$text"

Return 10-15 keywords that would be valuable for ATS optimization and job matching.
Return as a JSON array of strings.
      ''';

      final response = await _callOpenAI(
        'chat/completions',
        {
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': 'You are an expert in keyword extraction for professional documents.'
            },
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.3,
          'max_tokens': 300,
        },
      );

      final keywordsJson = json.decode(response['choices'][0]['message']['content']) as List;
      return keywordsJson.cast<String>();
    } catch (e) {
      _logger.error('Failed to extract keywords', error: e);
      return [];
    }
  }

  // Industry Insights
  Future<Map<String, dynamic>> getIndustryInsights(String industry) async {
    try {
      final prompt = '''
Provide current insights for the $industry industry including:

1. Top skills in demand
2. Average salary ranges
3. Growing job roles
4. Key trends and technologies
5. Professional development recommendations

Return as structured JSON.
      ''';

      final response = await _callClaude(
        'messages',
        {
          'model': 'claude-3-sonnet-20240229',
          'max_tokens': 2000,
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
        },
      );

      return json.decode(response['content'][0]['text']) as Map<String, dynamic>;
    } catch (e) {
      _logger.error('Failed to get industry insights', error: e);
      return {};
    }
  }

  // Cleanup resources
  void dispose() {
    _httpClient.close();
  }
}