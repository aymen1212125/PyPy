import 'package:flutter/material.dart';

import '../../widgets/common_widgets.dart';

class WelcomeStep extends StatelessWidget {
  const WelcomeStep({super.key, required this.nameController});
  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.7, end: 1),
          duration: const Duration(milliseconds: 800),
          builder: (context, v, child) => Transform.scale(scale: v, child: child),
          child: const Text('🐍', style: TextStyle(fontSize: 80)),
        ),
        const SizedBox(height: 12),
        Text('Meet PyPy — your AI Python mentor', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
        const SizedBox(height: 24),
        GlassCard(
          child: TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Your name')),
        ),
      ],
    );
  }
}
