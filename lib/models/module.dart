import 'package:hive/hive.dart';

enum LessonType { concept, practice, debug, challenge }

class PyLesson {
  PyLesson({
    required this.id,
    required this.title,
    this.type = LessonType.practice,
    this.description = '',
  });

  final String id;
  final String title;
  final LessonType type;
  final String description;
}

class PyModule {
  PyModule({
    required this.id,
    required this.title,
    required this.icon,
    required this.xpReward,
    this.lessons = const [],
  });

  final String id;
  final String title;
  final String icon;
  final int xpReward;
  final List<PyLesson> lessons;
}

class LessonTypeAdapter extends TypeAdapter<LessonType> {
  @override
  final int typeId = 0;

  @override
  LessonType read(BinaryReader reader) => LessonType.values[reader.readByte()];

  @override
  void write(BinaryWriter writer, LessonType obj) => writer.writeByte(obj.index);
}

class PyLessonAdapter extends TypeAdapter<PyLesson> {
  @override
  final int typeId = 1;

  @override
  PyLesson read(BinaryReader reader) {
    final fields = <int, dynamic>{
      for (int i = 0, n = reader.readByte(); i < n; i++) reader.readByte(): reader.read(),
    };
    return PyLesson(
      id: fields[0] as String,
      title: fields[1] as String,
      type: fields[2] as LessonType,
      description: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PyLesson obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.description);
  }
}

class PyModuleAdapter extends TypeAdapter<PyModule> {
  @override
  final int typeId = 2;

  @override
  PyModule read(BinaryReader reader) {
    final fields = <int, dynamic>{
      for (int i = 0, n = reader.readByte(); i < n; i++) reader.readByte(): reader.read(),
    };
    return PyModule(
      id: fields[0] as String,
      title: fields[1] as String,
      icon: fields[2] as String,
      xpReward: fields[3] as int,
      lessons: (fields[4] as List).cast<PyLesson>(),
    );
  }

  @override
  void write(BinaryWriter writer, PyModule obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.icon)
      ..writeByte(3)
      ..write(obj.xpReward)
      ..writeByte(4)
      ..write(obj.lessons);
  }
}
