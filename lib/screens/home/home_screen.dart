import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/profile_provider.dart';
import '../../providers/session_provider.dart';
import '../../widgets/common_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>().profile!;
    final notes = context.watch<SessionProvider>().notes;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Good morning, ${profile.name.isEmpty ? 'Coder' : profile.name}', style: Theme.of(context).textTheme.headlineMedium),
            Chip(label: Text('🔥 ${profile.currentStreak}')),
          ],
        ),
        const SizedBox(height: 14),
        GlassCard(
          child: Text(notes.isEmpty ? 'Today, keep momentum going with one focused lesson.' : 'Today, revisit ${notes.first.concept} to turn weakness into strength.'),
        ),
        const SizedBox(height: 14),
        GlassCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Continue Learning'),
            const SizedBox(height: 8),
            Text(profile.currentLessonId, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(value: (profile.totalXP % 500) / 500, minHeight: 6, backgroundColor: AppColors.surface),
            ),
            const SizedBox(height: 10),
            GradientButton(label: 'Go to lesson', onTap: () => context.go('/learn')),
          ]),
        ),
        const SizedBox(height: 14),
        GlassCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Weak Points to Revisit'),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: profile.weakConcepts
                    .map((w) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Chip(label: Text(w)),
                        ))
                    .toList(),
              ),
            )
          ]),
        ),
      ],
    );
  }
}
