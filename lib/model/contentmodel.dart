class LessonContent {
  final int id;
  final int lessonId;
  final String contentText;
  final String contentType;
  final int contentOrder;
  final String contentVideo;

  LessonContent(
      {required this.id,
      required this.lessonId,
      required this.contentText,
      required this.contentType,
      required this.contentOrder,
      required this.contentVideo});

  // Factory method to create a LessonContent instance from JSON
  factory LessonContent.fromJson(Map<String, dynamic> json) {
    return LessonContent(
        id: json['content_id'],
        lessonId: json['lesson_id'],
        contentText: json['content_text'],
        contentType: json['content_type'],
        contentOrder: json['content_order'],
        contentVideo: json['content_video'] ?? "");
  }

  // Method to convert a LessonContent instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'content_id': id,
      'lesson_id': lessonId,
      'content_text': contentText,
      'content_type': contentType,
      'content_order': contentOrder,
      'content_video': contentVideo
    };
  }
}
