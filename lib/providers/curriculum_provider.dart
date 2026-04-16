import 'package:flutter/material.dart';

import '../core/constants/curriculum.dart';
import '../models/module.dart';

class CurriculumProvider extends ChangeNotifier {
  final List<PyModule> modules = curriculum;

  PyLesson? lessonById(String lessonId) {
    for (final module in modules) {
      for (final lesson in module.lessons) {
        if (lesson.id == lessonId) return lesson;
      }
    }
    return null;
  }

  int completionPercent(Map<String, int> moduleScores, String moduleId) {
    final score = moduleScores[moduleId] ?? 0;
    return score;
  }
}
