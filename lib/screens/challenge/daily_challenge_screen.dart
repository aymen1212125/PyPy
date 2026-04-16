import 'package:flutter/material.dart';

import '../../widgets/common_widgets.dart';

class DailyChallengeScreen extends StatelessWidget {
  const DailyChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        GlassCard(child: Text('Daily Challenge: Build a function that groups words by first letter and returns a dictionary.')),
      ],
    );
  }
}
