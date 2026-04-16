import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../core/utils/hive_service.dart';
import '../models/ai_notes.dart';
import '../models/lesson.dart';
import '../models/session_log.dart';

class SessionProvider extends ChangeNotifier {
  late Box<AINotesLog> _notesBox;
  late Box<SessionLog> _logsBox;
  late Box<Map> _chatBox;

  List<AINotesLog> notes = [];
  List<SessionLog> logs = [];
  List<ChatMessage> chatHistory = [];

  Future<void> init() async {
    _notesBox = Hive.box<AINotesLog>(HiveService.aiNotesBox);
    _logsBox = Hive.box<SessionLog>(HiveService.sessionLogsBox);
    _chatBox = Hive.box<Map>(HiveService.chatHistoryBox);

    notes = _notesBox.values.toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    logs = _logsBox.values.toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    chatHistory = _chatBox.values.map(ChatMessage.fromMap).toList();
    notifyListeners();
  }

  Future<void> addNote(AINotesLog note) async {
    await _notesBox.add(note);
    notes.insert(0, note);
    notifyListeners();
  }

  Future<void> addSession(SessionLog log) async {
    await _logsBox.add(log);
    logs.insert(0, log);
    notifyListeners();
  }

  Future<void> addChat(ChatMessage msg) async {
    chatHistory.add(msg);
    if (chatHistory.length > 50) {
      chatHistory = chatHistory.sublist(chatHistory.length - 50);
    }
    await _chatBox.clear();
    for (final m in chatHistory) {
      await _chatBox.add(m.toMap());
    }
    notifyListeners();
  }
}
