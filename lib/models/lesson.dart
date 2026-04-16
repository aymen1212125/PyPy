class LessonState {
  LessonState({
    required this.lessonId,
    this.bestScore = 0,
    this.attempts = 0,
    this.completed = false,
  });

  final String lessonId;
  int bestScore;
  int attempts;
  bool completed;

  Map<String, dynamic> toMap() => {
        'lessonId': lessonId,
        'bestScore': bestScore,
        'attempts': attempts,
        'completed': completed,
      };

  factory LessonState.fromMap(Map<dynamic, dynamic> map) => LessonState(
        lessonId: map['lessonId'] as String,
        bestScore: map['bestScore'] as int? ?? 0,
        attempts: map['attempts'] as int? ?? 0,
        completed: map['completed'] as bool? ?? false,
      );
}

class ChatMessage {
  ChatMessage({required this.isUser, required this.message, required this.timestamp});

  final bool isUser;
  final String message;
  final DateTime timestamp;

  Map<String, dynamic> toMap() => {
        'isUser': isUser,
        'message': message,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ChatMessage.fromMap(Map<dynamic, dynamic> map) => ChatMessage(
        isUser: map['isUser'] as bool,
        message: map['message'] as String,
        timestamp: DateTime.parse(map['timestamp'] as String),
      );
}
