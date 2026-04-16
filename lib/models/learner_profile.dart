import 'package:hive/hive.dart';

class LearnerProfile {
  LearnerProfile({
    required this.userId,
    this.name = '',
    this.nativeLanguage = 'English',
    this.priorExperience = 'zero',
    this.learningGoal = 'general',
    this.learningPace = 'medium',
    this.totalXP = 0,
    this.currentStreak = 0,
    DateTime? lastSessionDate,
    this.currentModuleId = 'm01',
    this.currentLessonId = 'm01l01',
    Map<String, int>? moduleScores,
    Map<String, int>? lessonAttempts,
    List<String>? masteredConcepts,
    List<String>? weakConcepts,
    List<String>? strongConcepts,
    this.hintsUsedTotal = 0,
    this.hintsUsedThisLesson = 0,
    this.averageCodeQuality = 0.0,
  })  : lastSessionDate = lastSessionDate ?? DateTime.now(),
        moduleScores = moduleScores ?? {},
        lessonAttempts = lessonAttempts ?? {},
        masteredConcepts = masteredConcepts ?? [],
        weakConcepts = weakConcepts ?? [],
        strongConcepts = strongConcepts ?? [];

  String userId;
  String name;
  String nativeLanguage;
  String priorExperience;
  String learningGoal;
  String learningPace;
  int totalXP;
  int currentStreak;
  DateTime lastSessionDate;
  String currentModuleId;
  String currentLessonId;
  Map<String, int> moduleScores;
  Map<String, int> lessonAttempts;
  List<String> masteredConcepts;
  List<String> weakConcepts;
  List<String> strongConcepts;
  int hintsUsedTotal;
  int hintsUsedThisLesson;
  double averageCodeQuality;
}

class LearnerProfileAdapter extends TypeAdapter<LearnerProfile> {
  @override
  final int typeId = 3;

  @override
  LearnerProfile read(BinaryReader reader) {
    final fields = <int, dynamic>{
      for (int i = 0, n = reader.readByte(); i < n; i++) reader.readByte(): reader.read(),
    };
    return LearnerProfile(
      userId: fields[0] as String,
      name: fields[1] as String,
      nativeLanguage: fields[2] as String,
      priorExperience: fields[3] as String,
      learningGoal: fields[4] as String,
      learningPace: fields[5] as String,
      totalXP: fields[6] as int,
      currentStreak: fields[7] as int,
      lastSessionDate: fields[8] as DateTime,
      currentModuleId: fields[9] as String,
      currentLessonId: fields[10] as String,
      moduleScores: (fields[11] as Map).cast<String, int>(),
      lessonAttempts: (fields[12] as Map).cast<String, int>(),
      masteredConcepts: (fields[13] as List).cast<String>(),
      weakConcepts: (fields[14] as List).cast<String>(),
      strongConcepts: (fields[15] as List).cast<String>(),
      hintsUsedTotal: fields[16] as int,
      hintsUsedThisLesson: fields[17] as int,
      averageCodeQuality: fields[18] as double,
    );
  }

  @override
  void write(BinaryWriter writer, LearnerProfile obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.nativeLanguage)
      ..writeByte(3)
      ..write(obj.priorExperience)
      ..writeByte(4)
      ..write(obj.learningGoal)
      ..writeByte(5)
      ..write(obj.learningPace)
      ..writeByte(6)
      ..write(obj.totalXP)
      ..writeByte(7)
      ..write(obj.currentStreak)
      ..writeByte(8)
      ..write(obj.lastSessionDate)
      ..writeByte(9)
      ..write(obj.currentModuleId)
      ..writeByte(10)
      ..write(obj.currentLessonId)
      ..writeByte(11)
      ..write(obj.moduleScores)
      ..writeByte(12)
      ..write(obj.lessonAttempts)
      ..writeByte(13)
      ..write(obj.masteredConcepts)
      ..writeByte(14)
      ..write(obj.weakConcepts)
      ..writeByte(15)
      ..write(obj.strongConcepts)
      ..writeByte(16)
      ..write(obj.hintsUsedTotal)
      ..writeByte(17)
      ..write(obj.hintsUsedThisLesson)
      ..writeByte(18)
      ..write(obj.averageCodeQuality);
  }
}
