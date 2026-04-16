import 'package:hive/hive.dart';

class AINotesLog {
  AINotesLog({
    required this.timestamp,
    required this.lessonId,
    required this.noteType,
    required this.observation,
    required this.concept,
    required this.confidence,
  });

  DateTime timestamp;
  String lessonId;
  String noteType;
  String observation;
  String concept;
  int confidence;
}

class AINotesLogAdapter extends TypeAdapter<AINotesLog> {
  @override
  final int typeId = 5;

  @override
  AINotesLog read(BinaryReader reader) {
    final fields = <int, dynamic>{
      for (int i = 0, n = reader.readByte(); i < n; i++) reader.readByte(): reader.read(),
    };
    return AINotesLog(
      timestamp: fields[0] as DateTime,
      lessonId: fields[1] as String,
      noteType: fields[2] as String,
      observation: fields[3] as String,
      concept: fields[4] as String,
      confidence: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AINotesLog obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.lessonId)
      ..writeByte(2)
      ..write(obj.noteType)
      ..writeByte(3)
      ..write(obj.observation)
      ..writeByte(4)
      ..write(obj.concept)
      ..writeByte(5)
      ..write(obj.confidence);
  }
}
