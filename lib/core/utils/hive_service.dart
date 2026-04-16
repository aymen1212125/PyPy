import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../models/ai_notes.dart';
import '../../models/learner_profile.dart';
import '../../models/module.dart';
import '../../models/session_log.dart';

class HiveService {
  static const String learnerProfileBox = 'learner_profile';
  static const String aiNotesBox = 'ai_notes';
  static const String sessionLogsBox = 'session_logs';
  static const String chatHistoryBox = 'chat_history';
  static const String lessonStatesBox = 'lesson_states';

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive
      ..registerAdapter(LessonTypeAdapter())
      ..registerAdapter(PyLessonAdapter())
      ..registerAdapter(PyModuleAdapter())
      ..registerAdapter(LearnerProfileAdapter())
      ..registerAdapter(SessionLogAdapter())
      ..registerAdapter(AINotesLogAdapter());

    await Future.wait([
      Hive.openBox<LearnerProfile>(learnerProfileBox),
      Hive.openBox<AINotesLog>(aiNotesBox),
      Hive.openBox<SessionLog>(sessionLogsBox),
      Hive.openBox<Map>(chatHistoryBox),
      Hive.openBox<Map>(lessonStatesBox),
    ]);

    final profileBox = Hive.box<LearnerProfile>(learnerProfileBox);
    if (profileBox.isEmpty) {
      profileBox.put(
        'profile',
        LearnerProfile(userId: const Uuid().v4()),
      );
    }
  }
}
