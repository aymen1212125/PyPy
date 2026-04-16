import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/learner_profile.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/common_widgets.dart';
import 'experience_screen.dart';
import 'goal_screen.dart';
import 'pace_screen.dart';
import 'welcome_screen.dart';

class OnboardingFlowScreen extends StatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  State<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends State<OnboardingFlowScreen> {
  final controller = PageController();
  final nameController = TextEditingController();
  int step = 0;
  String exp = 'zero';
  String goal = 'general';
  String pace = 'medium';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: controller,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    WelcomeStep(nameController: nameController),
                    ExperienceStep(selected: exp, onSelect: (v) => setState(() => exp = v)),
                    GoalStep(selected: goal, onSelect: (v) => setState(() => goal = v)),
                    PaceStep(selected: pace, onSelect: (v) => setState(() => pace = v)),
                  ],
                ),
              ),
              GradientButton(
                label: step == 3 ? 'Build my learning plan →' : 'Continue',
                onTap: () async {
                  if (step < 3) {
                    setState(() => step++);
                    controller.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
                    return;
                  }
                  final p = context.read<ProfileProvider>();
                  final profile = p.profile!;
                  profile.name = nameController.text.trim();
                  profile.priorExperience = exp;
                  profile.learningGoal = goal;
                  profile.learningPace = pace;
                  await p.updateProfile(profile);
                  if (context.mounted) context.go('/home');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
