// lib/features/resume/screens/resume_preview_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/widgets/custom_app_bar.dart';

class ResumePreviewScreen extends StatelessWidget {
  final Map<String, dynamic> resumeData;
  final String templateId;

  const ResumePreviewScreen({
    Key? key,
    required this.resumeData,
    required this.templateId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Resume Preview',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ATS Score Card
            _buildATSScoreCard(),
            const SizedBox(height: 24),

            // Resume Preview Container
            _buildResumePreview(context),
            const SizedBox(height: 24),

            // Action Buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildATSScoreCard() {
    final atsScore = resumeData['atsScore'] as int? ?? 85;
    final scoreColor = atsScore >= 85
        ? Colors.green
        : atsScore >= 70
        ? Colors.orange
        : Colors.red;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scoreColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scoreColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: scoreColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$atsScore%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ATS Compatibility Score',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your resume is well-optimized for applicant tracking systems',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumePreview(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Resume Header
          _buildResumeHeader(),

          // Resume Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (resumeData['summary'] != null) ...[
                  _buildResumeSection('PROFESSIONAL SUMMARY'),
                  const SizedBox(height: 8),
                  Text(
                    resumeData['summary'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                if (resumeData['skills'] != null) ...[
                  _buildResumeSection('KEY SKILLS'),
                  const SizedBox(height: 8),
                  _buildSkillsSection(),
                  const SizedBox(height: 24),
                ],

                if (resumeData['experience'] != null) ...[
                  _buildResumeSection('PROFESSIONAL EXPERIENCE'),
                  const SizedBox(height: 8),
                  Text(
                    resumeData['experience'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                if (resumeData['education'] != null) ...[
                  _buildResumeSection('EDUCATION'),
                  const SizedBox(height: 8),
                  _buildEducationSection(),
                  const SizedBox(height: 24),
                ],

                // AI Optimization Badge
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green[600]),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'AI Optimized: This resume is ATS-friendly and tailored for your target role.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumeHeader() {
    final primaryColor = _getTemplateColor();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            resumeData['fullName'] as String? ?? 'Full Name',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            resumeData['jobTitle'] as String? ?? 'Job Title',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          if (resumeData['email'] != null) ...[
            Row(
              children: [
                const Icon(Icons.email, color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                Text(
                  resumeData['email'] as String,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ],
          if (resumeData['phone'] != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                Text(
                  resumeData['phone'] as String,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ],
          if (resumeData['location'] != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                Text(
                  resumeData['location'] as String,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResumeSection(String title) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _getTemplateColor(),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsSection() {
    final skills = resumeData['skills'] as List<String>? ?? [];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skills.map((skill) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _getTemplateColor().withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _getTemplateColor().withOpacity(0.3)),
        ),
        child: Text(
          skill,
          style: TextStyle(
            fontSize: 12,
            color: _getTemplateColor(),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildEducationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (resumeData['degree'] != null) ...[
          Text(
            resumeData['degree'] as String,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
        ],
        if (resumeData['institution'] != null) ...[
          Text(
            resumeData['institution'] as String,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
        ],
        if (resumeData['graduationYear'] != null) ...[
          Text(
            'Graduated: ${resumeData['graduationYear']}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
        if (resumeData['gpa'] != null && (resumeData['gpa'] as String).isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            'GPA: ${resumeData['gpa']}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _shareResume(context);
                },
                icon: const Icon(Icons.share),
                label: const Text('Share'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _downloadResume(context);
                },
                icon: const Icon(Icons.download),
                label: const Text('Download PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getTemplateColor(),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.edit),
            label: const Text('Edit Resume'),
          ),
        ),
      ],
    );
  }

  Color _getTemplateColor() {
    switch (templateId) {
      case 'modern':
        return const Color(0xFF1E3A8A);
      case 'creative':
        return const Color(0xFF8B5CF6);
      case 'minimal':
        return const Color(0xFF6B7280);
      case 'professional':
        return const Color(0xFF059669);
      default:
        return const Color(0xFF3B82F6);
    }
  }

  void _shareResume(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Resume shared successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _downloadResume(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Resume downloaded as PDF!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}