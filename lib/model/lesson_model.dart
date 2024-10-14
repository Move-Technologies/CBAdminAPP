class Lesson {
  final int id;
  final int courseId;
  final String name;
  final String description;
  final String iconUrl;
  final String date;
  final int order;

  Lesson({
    required this.id,
    required this.courseId,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.date,
    required this.order,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['lesson_id'],
      courseId: json['course_id'],
      name: json['lesson_name'],
      description: json['lesson_description'],
      iconUrl: json['lesson_icon'],
      date: json['lesson_date'],
      order: json['lesson_order'],
    );
  }
}
