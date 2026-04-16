import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/curriculum_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/common_widgets.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  String _level(int xp) {
    if (xp >= 12000) return 'Pythonista';
    if (xp >= 7000) return 'Master';
    if (xp >= 3500) return 'Expert';
    if (xp >= 1500) return 'Developer';
    if (xp >= 500) return 'Apprentice';
    return 'Novice';
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>().profile!;
    final modules = context.watch<CurriculumProvider>().modules;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GlassCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('XP ${profile.totalXP}', style: Theme.of(context).textTheme.headlineMedium),
            Text(_level(profile.totalXP)),
          ]),
        ),
        const SizedBox(height: 12),
        ...modules.map((m) {
          final score = profile.moduleScores[m.id] ?? 0;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GlassCard(
              child: ExpansionTile(
                title: Text('${m.icon} ${m.title}'),
                subtitle: ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(minHeight: 6, value: score / 100, color: AppColors.accentSecond),
                ),
                children: m.lessons
                    .map((l) => ListTile(
                          title: Text(l.title),
                          subtitle: Text('Attempts: ${profile.lessonAttempts[l.id] ?? 0}'),
                        ))
                    .toList(),
              ),
            ),
          );
        }),
      ],
    );
  }
}
