// lib/features/resume/widgets/resume_form_sections.dart
import 'package:flutter/material.dart';

class PersonalInfoFormSection extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String key, dynamic value) onChanged;

  const PersonalInfoFormSection({
    Key? key,
    required this.data,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personal Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: data['fullName'] as String? ?? '',
          decoration: const InputDecoration(
            labelText: 'Full Name *',
            prefixIcon: Icon(Icons.person),
          ),
          onChanged: (value) => onChanged('fullName', value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your full name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: data['email'] as String? ?? '',
          decoration: const InputDecoration(
            labelText: 'Email Address *',
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) => onChanged('email', value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: data['phone'] as String? ?? '',
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            prefixIcon: Icon(Icons.phone),
          ),
          keyboardType: TextInputType.phone,
          onChanged: (value) => onChanged('phone', value),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: data['location'] as String? ?? '',
          decoration: const InputDecoration(
            labelText: 'Location',
            prefixIcon: Icon(Icons.location_on),
          ),
          onChanged: (value) => onChanged('location', value),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: data['linkedin'] as String? ?? '',
          decoration: const InputDecoration(
            labelText: 'LinkedIn Profile',
            prefixIcon: Icon(Icons.link),
          ),
          onChanged: (value) => onChanged('linkedin', value),
        ),
      ],
    );
  }
}

class ProfessionalInfoFormSection extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String key, dynamic value) onChanged;

  const ProfessionalInfoFormSection({
    Key? key,
    required this.data,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Professional Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: data['jobTitle'] as String? ?? '',
          decoration: const InputDecoration(
            labelText: 'Target Job Title *',
            prefixIcon: Icon(Icons.work),
          ),
          onChanged: (value) => onChanged('jobTitle', value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your target job title';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: data['summary'] as String? ?? '',
          decoration: const InputDecoration(
            labelText: 'Professional Summary',
            prefixIcon: Icon(Icons.description),
            hintText: 'Brief overview of your professional background...',
          ),
          maxLines: 4,
          onChanged: (value) => onChanged('summary', value),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: data['experience'] as String? ?? '',
          decoration: const InputDecoration(
            labelText: 'Work Experience',
            prefixIcon: Icon(Icons.business_center),
            hintText: 'Describe your work experience...',
          ),
          maxLines: 6,
          onChanged: (value) => onChanged('experience', value),
        ),
      ],
    );
  }
}

class SkillsFormSection extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String key, dynamic value) onChanged;

  const SkillsFormSection({
    Key? key,
    required this.data,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final skills = data['skills'] as List<String>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Skills',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Add Skills',
            prefixIcon: Icon(Icons.star),
            hintText: 'e.g., JavaScript, Python, Project Management',
          ),
          onFieldSubmitted: (value) {
            if (value.isNotEmpty && !skills.contains(value)) {
              final updatedSkills = List<String>.from(skills)..add(value);
              onChanged('skills', updatedSkills);
            }
          },
        ),
        const SizedBox(height: 16),
        if (skills.isNotEmpty) ...[
          const Text(
            'Added Skills:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((skill) {
              return Chip(
                label: Text(skill),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () {
                  final updatedSkills = List<String>.from(skills)..remove(skill);
                  onChanged('skills', updatedSkills);
                },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

class EducationFormSection extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String key, dynamic value) onChanged;

  const EducationFormSection({
    Key? key,
    required this.data,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Education',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: data['degree'] as String? ?? '',
          decoration: const InputDecoration(
            labelText: 'Degree',
            prefixIcon: Icon(Icons.school),
          ),
          onChanged: (value) => onChanged('degree', value),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: data['institution'] as String? ?? '',
          decoration: const InputDecoration(
            labelText: 'Institution',
            prefixIcon: Icon(Icons.account_balance),
          ),
          onChanged: (value) => onChanged('institution', value),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: data['graduationYear'] as String? ?? '',
                decoration: const InputDecoration(
                  labelText: 'Graduation Year',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => onChanged('graduationYear', value),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                initialValue: data['gpa'] as String? ?? '',
                decoration: const InputDecoration(
                  labelText: 'GPA (Optional)',
                  prefixIcon: Icon(Icons.grade),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => onChanged('gpa', value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: data['achievements'] as String? ?? '',
          decoration: const InputDecoration(
            labelText: 'Academic Achievements',
            prefixIcon: Icon(Icons.emoji_events),
            hintText: 'Dean\'s List, Honors, Relevant Coursework...',
          ),
          maxLines: 3,
          onChanged: (value) => onChanged('achievements', value),
        ),
      ],
    );
  }
}

// lib/features/resume/widgets/template_selector.dart
class TemplateSelector extends StatelessWidget {
  final List<Map<String, dynamic>> templates;
  final String? selectedTemplateId;
  final Function(String templateId) onTemplateSelected;

  const TemplateSelector({
    Key? key,
    required this.templates,
    this.selectedTemplateId,
    required this.onTemplateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Template',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: templates.length,
            itemBuilder: (context, index) {
              final template = templates[index];
              final isSelected = template['id'] == selectedTemplateId;

              return GestureDetector(
                onTap: () => onTemplateSelected(template['id']),
                child: Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                          ),
                          child: const Icon(
                            Icons.description,
                            size: 48,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).primaryColor.withOpacity(0.1)
                              : Colors.white,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              template['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Theme.of(context).primaryColor
                                    : Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (template['isPremium'] == true) ...[
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'PREMIUM',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber[800],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// lib/features/resume/widgets/ai_writing_assistant.dart
class AIWritingAssistant extends StatefulWidget {
  final Function(String suggestion) onSuggestionApplied;

  const AIWritingAssistant({
    Key? key,
    required this.onSuggestionApplied,
  }) : super(key: key);

  @override
  State<AIWritingAssistant> createState() => _AIWritingAssistantState();
}

class _AIWritingAssistantState extends State<AIWritingAssistant> {
  final TextEditingController _promptController = TextEditingController();
  bool _isGenerating = false;
  String? _generatedContent;

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  void _generateContent() async {
    if (_promptController.text.isEmpty) return;

    setState(() {
      _isGenerating = true;
      _generatedContent = null;
    });

    // Simulate AI content generation
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isGenerating = false;
      _generatedContent = 'AI-generated content based on: "${_promptController.text}"';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology, color: Colors.blue[700]),
              const SizedBox(width: 8),
              Text(
                'AI Writing Assistant',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _promptController,
            decoration: const InputDecoration(
              hintText: 'Describe what you want to write about...',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _isGenerating ? null : _generateContent,
                  child: _isGenerating
                      ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('Generating...'),
                    ],
                  )
                      : const Text('Generate Content'),
                ),
              ),
            ],
          ),
          if (_generatedContent != null) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Generated Content:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(_generatedContent!),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            widget.onSuggestionApplied(_generatedContent!);
                            setState(() {
                              _generatedContent = null;
                              _promptController.clear();
                            });
                          },
                          child: const Text('Apply'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _generatedContent = null;
                            });
                          },
                          child: const Text('Discard'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}