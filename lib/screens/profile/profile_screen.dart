import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/profile_provider.dart';
import '../../providers/session_provider.dart';
import '../../widgets/common_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final keyController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    keyController.text = context.read<ProfileProvider>().geminiKey;
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ProfileProvider>().profile!;
    final notes = context.watch<SessionProvider>().notes;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GlassCard(
          child: Row(children: [
            CircleAvatar(radius: 28, child: Text(p.name.isEmpty ? 'PY' : p.name.substring(0, 1).toUpperCase())),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.name.isEmpty ? 'PyPy Learner' : p.name, style: Theme.of(context).textTheme.titleLarge),
              Text('Mastery ${(p.averageCodeQuality * 100).toStringAsFixed(0)}%'),
            ]),
          ]),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 2.2,
          children: [
            _stat('Total XP', '${p.totalXP}'),
            _stat('Current Streak', '${p.currentStreak}'),
            _stat('Lessons Done', '${p.lessonAttempts.length}'),
            _stat('Hints Used', '${p.hintsUsedTotal}'),
            _stat('Avg Code Quality', '${(p.averageCodeQuality * 100).toStringAsFixed(0)}%'),
            _stat('Modules Mastered', '${p.moduleScores.values.where((s) => s >= 80).length}'),
          ],
        ),
        const SizedBox(height: 12),
        GlassCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("AI's Notes on You", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ...notes.take(12).map((n) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('${n.noteType.toUpperCase()} • ${n.concept}'),
                  subtitle: Text(n.observation),
                  trailing: Text('⭐' * n.confidence),
                )),
          ]),
        ),
        const SizedBox(height: 12),
        GlassCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Gemini API Key', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            TextField(controller: keyController, obscureText: true),
            const SizedBox(height: 8),
            GradientButton(
              label: 'Save Key',
              onTap: () => context.read<ProfileProvider>().saveApiKey(keyController.text.trim()),
            ),
          ]),
        ),
      ],
    );
  }

  Widget _stat(String label, String value) => GlassCard(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(color: AppColors.textSecond, fontSize: 12)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ]),
      );
}
