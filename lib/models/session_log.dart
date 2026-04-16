import 'package:hive/hive.dart';

class SessionLog {
  SessionLog({
    required this.timestamp,
    required this.lessonId,
    required this.score,
    required this.hintsUsed,
    required this.codeSubmitted,
  });

  DateTime timestamp;
  String lessonId;
  int score;
  int hintsUsed;
  String codeSubmitted;
}

class SessionLogAdapter extends TypeAdapter<SessionLog> {
  @override
  final int typeId = 4;

  @override
  SessionLog read(BinaryReader reader) {
    final fields = <int, dynamic>{
      for (int i = 0, n = reader.readByte(); i < n; i++) reader.readByte(): reader.read(),
    };
    return SessionLog(
      timestamp: fields[0] as DateTime,
      lessonId: fields[1] as String,
      score: fields[2] as int,
      hintsUsed: fields[3] as int,
      codeSubmitted: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SessionLog obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.lessonId)
      ..writeByte(2)
      ..write(obj.score)
      ..writeByte(3)
      ..write(obj.hintsUsed)
      ..writeByte(4)
      ..write(obj.codeSubmitted);
  }
}
