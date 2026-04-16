import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/gemini_service.dart';
import '../../models/lesson.dart';
import '../../providers/profile_provider.dart';
import '../../providers/session_provider.dart';
import '../../widgets/common_widgets.dart';

class MentorChatScreen extends StatefulWidget {
  const MentorChatScreen({super.key});

  @override
  State<MentorChatScreen> createState() => _MentorChatScreenState();
}

class _MentorChatScreenState extends State<MentorChatScreen> {
  final controller = TextEditingController();
  bool loading = false;

  Future<void> send() async {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    controller.clear();
    final s = context.read<SessionProvider>();
    final p = context.read<ProfileProvider>();
    await s.addChat(ChatMessage(isUser: true, message: text, timestamp: DateTime.now()));

    if (p.geminiKey.isEmpty) return;
    setState(() => loading = true);
    try {
      final service = GeminiService(p.geminiKey);
      final ai = await service.chatResponse(p.profile!, s.notes, s.chatHistory, text);
      await s.addChat(ChatMessage(isUser: false, message: ai, timestamp: DateTime.now()));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = context.watch<SessionProvider>().chatHistory;
    final suggestions = const ['Explain my biggest weak point', 'Give me a practice task', 'Why is my code not Pythonic?'];
    return Column(
      children: [
        SizedBox(
          height: 42,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            children: suggestions
                .map((s) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(label: Text(s), onPressed: () => controller.text = s),
                    ))
                .toList(),
          ),
        ),
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[messages.length - index - 1];
              final align = msg.isUser ? Alignment.centerRight : Alignment.centerLeft;
              return Align(
                alignment: align,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(maxWidth: 320),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: msg.isUser ? AppColors.accent : AppColors.surfaceHigh,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: msg.isUser ? Text(msg.message) : MarkdownBody(data: msg.message),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(child: TextField(controller: controller, decoration: const InputDecoration(hintText: 'Ask PyPy anything...'))),
              const SizedBox(width: 8),
              GradientButton(label: loading ? '...' : 'Send', onTap: loading ? null : send),
            ],
          ),
        ),
      ],
    );
  }
}
