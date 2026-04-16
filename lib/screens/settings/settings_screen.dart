import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/session_provider.dart';
import '../../widgets/common_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> exportNotes(BuildContext context) async {
    final notes = context.read<SessionProvider>().notes;
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/pypy_notes.txt');
    final text = notes.map((e) => '[${e.timestamp}] ${e.noteType} (${e.concept}): ${e.observation}').join('\n');
    await file.writeAsString(text);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exported to ${file.path}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GlassCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Dark theme only'),
            const SizedBox(height: 12),
            GradientButton(label: 'Export my learning notes', onTap: () => exportNotes(context)),
          ]),
        ),
      ],
    );
  }
}
