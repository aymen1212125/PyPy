import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';

import '../constants/prompts.dart';
import '../../models/ai_notes.dart';
import '../../models/learner_profile.dart';
import '../../models/lesson.dart';
import '../../models/module.dart';

class LessonBriefing {
  LessonBriefing({required this.text});
  final String text;
}

class CodeEvaluation {
  CodeEvaluation({
    required this.isValid,
    required this.qualityScore,
    required this.qualityLabel,
    required this.errors,
    required this.feedback,
    required this.improvementTip,
    required this.conceptMastered,
    required this.newWeakPoint,
    required this.xpAwarded,
    required this.encouragement,
  });

  final bool isValid;
  final int qualityScore;
  final String qualityLabel;
  final List<String> errors;
  final String feedback;
  final String improvementTip;
  final String conceptMastered;
  final String? newWeakPoint;
  final int xpAwarded;
  final String encouragement;

  factory CodeEvaluation.fromJson(Map<String, dynamic> map) => CodeEvaluation(
        isValid: map['is_valid'] as bool? ?? false,
        qualityScore: map['quality_score'] as int? ?? 0,
        qualityLabel: map['quality_label'] as String? ?? 'Needs Work',
        errors: (map['errors'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
        feedback: map['feedback'] as String? ?? 'Keep iterating.',
        improvementTip: map['improvement_tip'] as String? ?? '',
        conceptMastered: map['concept_mastered'] as String? ?? '',
        newWeakPoint: map['new_weak_point'] as String?,
        xpAwarded: map['xp_awarded'] as int? ?? 0,
        encouragement: map['encouragement'] as String? ?? 'You can do this!',
      );
}

class GeminiService {
  GeminiService(this.apiKey)
      : _model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: apiKey,
          generationConfig: const GenerationConfig(temperature: 0.7),
        );

  final String apiKey;
  final GenerativeModel _model;

  String _base(LearnerProfile profile, List<AINotesLog> notes) {
    final recent = notes.take(5).map((e) => '${e.concept}:${e.observation}').join('; ');
    return baseMentorPrompt
        .replaceAll('{name}', profile.name.isEmpty ? 'Learner' : profile.name)
        .replaceAll('{experience}', profile.priorExperience)
        .replaceAll('{goal}', profile.learningGoal)
        .replaceAll('{weakConcepts}', profile.weakConcepts.join(', '))
        .replaceAll('{recentNotes}', recent);
  }

  Future<String> _generate(String prompt) async {
    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text?.trim() ?? '';
  }

  Future<LessonBriefing> generateLessonBriefing(LearnerProfile profile, PyLesson lesson, List<AINotesLog> notes) async {
    final prompt = '${_base(profile, notes)}\n${lessonBriefPrompt.replaceAll('{lessonTitle}', lesson.title)}';
    return LessonBriefing(text: await _generate(prompt));
  }

  Future<CodeEvaluation> evaluateCode(LearnerProfile profile, PyLesson lesson, String code, List<String> hintsUsed, List<AINotesLog> notes) async {
    final prompt = '${_base(profile, notes)}\n${evaluatePrompt.replaceAll('{task}', lesson.title)}\nUser code:\n$code\nHints:${hintsUsed.join(',')}';
    final text = await _generate(prompt);
    return CodeEvaluation.fromJson(jsonDecode(text) as Map<String, dynamic>);
  }

  Future<List<AINotesLog>> updateAINotes(LearnerProfile profile, List<AINotesLog> existingNotes, String sessionSummary) async {
    final prompt = '${_base(profile, existingNotes)}\n$notesUpdatePrompt\nSession:$sessionSummary';
    final text = await _generate(prompt);
    final json = jsonDecode(text) as Map<String, dynamic>;
    return (json['notes'] as List<dynamic>? ?? [])
        .map((e) => AINotesLog(
              timestamp: DateTime.now(),
              lessonId: profile.currentLessonId,
              noteType: e['noteType'] as String,
              observation: e['observation'] as String,
              concept: e['concept'] as String,
              confidence: e['confidence'] as int,
            ))
        .toList();
  }

  Future<String> chatResponse(LearnerProfile profile, List<AINotesLog> notes, List<ChatMessage> history, String userMessage) async {
    final turns = history.take(8).map((e) => '${e.isUser ? 'User' : 'Mentor'}:${e.message}').join('\n');
    return _generate('${_base(profile, notes)}\nHistory:\n$turns\nUser:$userMessage');
  }

  Future<String> generateWelcome(LearnerProfile profile, List<AINotesLog> notes) async => _generate('${_base(profile, notes)}\n$welcomePrompt');

  Future<String> generateDailyFocus(LearnerProfile profile, List<AINotesLog> notes) async => _generate('${_base(profile, notes)}\n$dailyFocusPrompt');
}
