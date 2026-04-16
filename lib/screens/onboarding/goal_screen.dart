import 'package:flutter/material.dart';

import '../../widgets/common_widgets.dart';

class GoalStep extends StatelessWidget {
  const GoalStep({super.key, required this.selected, required this.onSelect});
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final options = {
      'automation': 'Automate my work ⚙️',
      'data_science': 'Data & AI 📊',
      'web': 'Web Development 🌐',
      'general': 'Just learn Python 🐍',
    };
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Your goal', style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 20),
      ...options.entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => onSelect(e.key),
              child: GlassCard(
                child: Row(children: [
                  Icon(selected == e.key ? Icons.check_circle : Icons.circle_outlined),
                  const SizedBox(width: 12),
                  Text(e.value),
                ]),
              ),
            ),
          )),
    ]);
  }
}
