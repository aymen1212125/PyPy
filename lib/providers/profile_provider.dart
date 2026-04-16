import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/utils/hive_service.dart';
import '../models/learner_profile.dart';

class ProfileProvider extends ChangeNotifier {
  late Box<LearnerProfile> _box;
  LearnerProfile? profile;
  String geminiKey = '';

  Future<void> init() async {
    _box = Hive.box<LearnerProfile>(HiveService.learnerProfileBox);
    profile = _box.get('profile');
    final prefs = await SharedPreferences.getInstance();
    geminiKey = prefs.getString('gemini_api_key') ?? '';
    notifyListeners();
  }

  Future<void> updateProfile(LearnerProfile updated) async {
    profile = updated;
    await _box.put('profile', updated);
    notifyListeners();
  }

  Future<void> saveApiKey(String key) async {
    geminiKey = key;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('gemini_api_key', key);
    notifyListeners();
  }
}
