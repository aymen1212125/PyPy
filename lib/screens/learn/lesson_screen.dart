import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/gemini_service.dart';
import '../../models/ai_notes.dart';
import '../../models/session_log.dart';
import '../../providers/curriculum_provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/session_provider.dart';
import '../../widgets/common_widgets.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final codeController = TextEditingController();
  int phase = 1;
  bool loading = false;
  bool takingNotes = false;
  String briefing = 'Loading personalized briefing...';
  CodeEvaluation? result;
  final hints = const [
    'Think about what data type you need here.',
    'Your function likely needs a return statement.',
    'Try using a list comprehension for a cleaner Pythonic approach.',
  ];
  int revealedHints = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadBriefing());
  }

  Future<void> _loadBriefing() async {
    final profile = context.read<ProfileProvider>().profile!;
    final notes = context.read<SessionProvider>().notes;
    final lesson = context.read<CurriculumProvider>().lessonById(profile.currentLessonId);
    if (lesson == null) return;
    if (context.read<ProfileProvider>().geminiKey.isEmpty) {
      setState(() => briefing = 'Set your Gemini API key in profile settings to unlock personalized AI coaching.');
      return;
    }
    final service = GeminiService(context.read<ProfileProvider>().geminiKey);
    try {
      final response = await service.generateLessonBriefing(profile, lesson, notes);
      setState(() => briefing = response.text);
    } catch (_) {
      setState(() => briefing = 'Today we will focus on ${lesson.title}. Write clean code with clear variables and test your logic mentally before submit.');
    }
  }

  Future<void> _submit() async {
    final profileProvider = context.read<ProfileProvider>();
    final sessionProvider = context.read<SessionProvider>();
    final lesson = context.read<CurriculumProvider>().lessonById(profileProvider.profile!.currentLessonId);
    if (lesson == null || profileProvider.geminiKey.isEmpty) return;

    setState(() => loading = true);
    final service = GeminiService(profileProvider.geminiKey);
    try {
      final eval = await service.evaluateCode(profileProvider.profile!, lesson, codeController.text, hints.take(revealedHints).toList(), sessionProvider.notes);
      setState(() => result = eval);
      await sessionProvider.addSession(SessionLog(
        timestamp: DateTime.now(),
        lessonId: lesson.id,
        score: eval.qualityScore,
        hintsUsed: revealedHints,
        codeSubmitted: codeController.text,
      ));
      final p = profileProvider.profile!;
      final earned = max(0, eval.xpAwarded - (revealedHints * 5));
      p.totalXP += earned;
      p.hintsUsedTotal += revealedHints;
      p.averageCodeQuality = (p.averageCodeQuality + eval.qualityScore / 100) / 2;
      p.lessonAttempts[lesson.id] = (p.lessonAttempts[lesson.id] ?? 0) + 1;
      if (eval.newWeakPoint != null) p.weakConcepts.add(eval.newWeakPoint!);
      if (eval.conceptMastered.isNotEmpty) p.masteredConcepts.add(eval.conceptMastered);
      await profileProvider.updateProfile(p);

      if (mounted) _showResult(eval);

      setState(() => takingNotes = true);
      final newNotes = await service.updateAINotes(profileProvider.profile!, sessionProvider.notes, 'score=${eval.qualityScore}, feedback=${eval.feedback}');
      for (final n in newNotes) {
        await sessionProvider.addNote(n);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Evaluation failed. Please verify API key and try again.')));
    } finally {
      setState(() {
        loading = false;
        takingNotes = false;
      });
    }
  }

  void _showResult(CodeEvaluation eval) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      builder: (context) {
        final color = eval.qualityScore >= 80 ? AppColors.success : (eval.qualityScore >= 50 ? AppColors.warning : AppColors.danger);
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(value: eval.qualityScore / 100, strokeWidth: 10, color: color),
                    Center(child: Text('${eval.qualityScore}%')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text('+${eval.xpAwarded} XP ✨', style: Theme.of(context).textTheme.headlineMedium),
            MarkdownBody(data: '**Feedback**\n${eval.feedback}\n\n**Tip:** ${eval.improvementTip}'),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: GradientButton(label: 'Try to improve', onTap: () => Navigator.pop(context))),
              const SizedBox(width: 10),
              Expanded(child: GradientButton(label: 'Next lesson →', onTap: () => Navigator.pop(context))),
            ]),
          ]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>().profile!;
    final lesson = context.watch<CurriculumProvider>().lessonById(profile.currentLessonId);
    if (lesson == null) return const Center(child: Text('Lesson not found'));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(lesson.title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        AnimatedContainer(duration: const Duration(milliseconds: 250), child: GlassCard(child: Text(briefing))),
        const SizedBox(height: 10),
        if (phase == 1) GradientButton(label: 'Ready to practice →', onTap: () => setState(() => phase = 2)),
        if (phase >= 2) ...[
          const SizedBox(height: 14),
          GlassCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Task'),
              const SizedBox(height: 8),
              const Text('Write a Python function that doubles every number in a list and returns the transformed list.'),
              const SizedBox(height: 12),
              Row(children: const [Text('1'), SizedBox(width: 8), Text('def double_numbers(numbers):')]),
              const SizedBox(height: 8),
              TextField(
                controller: codeController,
                maxLines: 10,
                style: const TextStyle(fontFamily: 'JetBrains Mono'),
                decoration: const InputDecoration(hintText: '    return [x*2 for x in numbers]'),
              ),
              Align(alignment: Alignment.centerRight, child: Text('${codeController.text.length} chars • ${'\n'.allMatches(codeController.text).length + 1} lines')),
            ]),
          ),
          const SizedBox(height: 14),
          GlassCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Hints (−5 XP each)'),
              const SizedBox(height: 8),
              ...List.generate(3, (i) {
                final open = i < revealedHints;
                return GestureDetector(
                  onTap: () => setState(() => revealedHints = min(i + 1, 3)),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: open ? AppColors.accentGlow : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(open ? hints[i] : 'Hint ${i + 1} (tap to reveal)'),
                  ),
                );
              }),
            ]),
          ),
          const SizedBox(height: 10),
          GradientButton(label: loading ? 'Submitting...' : 'Submit', onTap: loading ? null : _submit),
          if (takingNotes)
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Chip(label: Text('AI is taking notes…')),
            ),
        ],
      ],
    );
  }
}
