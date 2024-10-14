import 'dart:convert';
import 'package:flutter/material.dart';
import '../main.dart';
import '../model/coursemodel.dart';
import '../model/lesson_model.dart';
import 'package:http/http.dart' as http;

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  _LessonsScreenState createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  Future<List<Course>>? _courses;
  Future<List<Lesson>>? _lessons;
  int? _selectedCourseId;

  @override
  void initState() {
    super.initState();
    _courses = fetchCourses();
  }

  void _loadLessons(int courseId) {
    setState(() {
      _selectedCourseId = courseId;
      _lessons = fetchLessons(courseId);
    });
  }

  Future<void> _createLesson(int courseId, String lessonName, String lessonDescription, String lessonIcon,
      String lessonDate, int lessonOrder) async {
    try {
      final response = await http.post(
        Uri.parse('$domain/api/lessons/course/$courseId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'lesson_name': lessonName,
          'lesson_description': lessonDescription,
          'lesson_icon': lessonIcon,
          'lesson_date': lessonDate,
          'lesson_order': lessonOrder,
        }),
      );

      if (response.statusCode == 201) {
        print('Lesson created successfully: ${response.body}');
        _loadLessons(courseId);
      } else {
        print('Failed to create lesson: ${response.body}');
        throw Exception('Failed to create lesson');
      }
    } catch (e) {
      print('Error creating lesson: $e');
    }
  }

  Future<List<Course>> fetchCourses() async {
    final response = await http.get(Uri.parse('$domain/api/courses/'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((course) => Course.fromJson(course)).toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }

  Future<List<Lesson>> fetchLessons(int courseId) async {
    final response = await http.get(Uri.parse('$domain/api/lessons/course/$courseId'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((lesson) => Lesson.fromJson(lesson)).toList();
    } else {
      throw Exception('Failed to load lessons');
    }
  }

  Future<void> _deleteLesson(int lessonId) async {
    final response = await http.delete(Uri.parse('$domain/api/lessons/$lessonId'));

    if (response.statusCode == 200) {
      _loadLessons(_selectedCourseId!);
    } else {
      throw Exception('Failed to delete lesson');
    }
  }

  void _showCreateLessonDialog(int courseId) {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController iconController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    TextEditingController orderController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Lesson'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nameController, 'Lesson Name'),
                _buildTextField(descriptionController, 'Lesson Description'),
                _buildTextField(iconController, 'Lesson Icon URL'),
                _buildTextField(dateController, 'Lesson Date (YYYY-MM-DD)'),
                _buildTextField(orderController, 'Lesson Order', inputType: TextInputType.number),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _createLesson(
                  courseId,
                  nameController.text,
                  descriptionController.text,
                  iconController.text,
                  dateController.text,
                  int.parse(orderController.text),
                );
                Navigator.pop(context);
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _editLesson(Lesson lesson) {
    TextEditingController nameController = TextEditingController(text: lesson.name);
    TextEditingController descriptionController = TextEditingController(text: lesson.description);
    TextEditingController iconController = TextEditingController(text: lesson.iconUrl);
    TextEditingController dateController = TextEditingController(text: lesson.date);
    TextEditingController orderController = TextEditingController(text: lesson.order.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Lesson'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nameController, 'Lesson Name'),
                _buildTextField(descriptionController, 'Lesson Description'),
                _buildTextField(iconController, 'Lesson Icon URL'),
                _buildTextField(dateController, 'Lesson Date (YYYY-MM-DD)'),
                _buildTextField(orderController, 'Lesson Order', inputType: TextInputType.number),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateLesson(lesson.id, _selectedCourseId!, nameController.text, iconController.text,
                    descriptionController.text, dateController.text, int.parse(orderController.text));
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateLesson(int lessonId, int courseId, String newName, String newIcon, String newDescription,
      String newDate, int newOrder) async {
    try {
      print('Updating lesson ID: $lessonId for course ID: $courseId');
      final response = await http.put(
        Uri.parse('$domain/api/lessons/$lessonId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'lesson_id': lessonId,
          'course_id': courseId,
          'lesson_name': newName,
          'lesson_description': newDescription,
          'lesson_icon': newIcon,
          'lesson_date': newDate,
          'lesson_order': newOrder,
        }),
      );

      if (response.statusCode == 200) {
        print('Lesson updated successfully: ${response.body}');
        _loadLessons(_selectedCourseId!);
      } else {
        print('Failed to update lesson: ${response.body}');
        throw Exception('Failed to update lesson');
      }
    } catch (e) {
      print('Error updating lesson: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Courses & Lessons')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Course>>(
                future: _courses,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final coursesList = snapshot.data!;
                    return ListView.builder(
                      itemCount: coursesList.length,
                      itemBuilder: (context, index) {
                        final course = coursesList[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              child: Text(course.name[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
                            ),
                            title: Text(course.name),
                            trailing: IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () => _showCreateLessonDialog(course.id),
                            ),
                            onTap: () {
                              _loadLessons(course.id);
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            if (_selectedCourseId != null)
              Expanded(
                child: FutureBuilder<List<Lesson>>(
                  future: _lessons,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No lessons found'));
                    } else {
                      final lessonsList = snapshot.data!;
                      return ListView.builder(
                        itemCount: lessonsList.length,
                        itemBuilder: (context, index) {
                          final lesson = lessonsList[index];
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              leading: const Icon(Icons.book, size: 40, color: Colors.teal),
                              title: Text(lesson.name),
                              subtitle: Text(lesson.description),
                              trailing: PopupMenuButton<String>(
                                onSelected: (String value) {
                                  if (value == 'edit') {
                                    _editLesson(lesson);
                                  } else if (value == 'delete') {
                                    _deleteLesson(lesson.id);
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return [
                                    const PopupMenuItem<String>(
                                      value: 'edit',
                                      child: Text('Edit'),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Text('Delete'),
                                    ),
                                  ];
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
