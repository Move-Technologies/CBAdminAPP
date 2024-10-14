import 'dart:convert';
import 'package:coursebro_admin/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/coursemodel.dart';
import '../model/lesson_model.dart'; // Assuming there's a Lesson model for lessons
import '../model/contentmodel.dart';
import 'package:http/http.dart' as http;

class LessonContentScreen extends StatefulWidget {
  const LessonContentScreen({super.key});

  @override
  _LessonContentScreenState createState() => _LessonContentScreenState();
}

class _LessonContentScreenState extends State<LessonContentScreen> {
  Future<List<Course>>? _courses;
  Future<List<Lesson>>? _lessons;
  Future<List<LessonContent>>? _lessonContents;
  int? _selectedCourseId;
  int? _selectedLessonId;

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

  void _loadLessonContent(int lessonId) {
    setState(() {
      _selectedLessonId = lessonId;
      _lessonContents = fetchLessonContent(lessonId);
    });
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

  Future<List<LessonContent>> fetchLessonContent(int lessonId) async {
    final response = await http.get(Uri.parse('$domain/api/lesson-content/lessons/$lessonId'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((content) => LessonContent.fromJson(content)).toList();
    } else {
      throw Exception('Failed to load lesson content');
    }
  }

  void _showEditLessonContentDialog(LessonContent content) {
    print("QQQQQ ${content.contentVideo}");
    TextEditingController contentTextController = TextEditingController(text: content.contentText);
    TextEditingController contentVideoController = TextEditingController(text: content.contentVideo);
    TextEditingController contentTypeController = TextEditingController(text: content.contentType);
    TextEditingController contentOrderController = TextEditingController(text: content.contentOrder.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Lesson Content'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: contentTextController,
                  decoration: const InputDecoration(labelText: 'Content Text'),
                ),
                TextField(
                  controller: contentVideoController,
                  decoration: const InputDecoration(labelText: 'Content Video'),
                ),
                TextField(
                  controller: contentTypeController,
                  decoration: const InputDecoration(labelText: 'Content Type'),
                ),
                TextField(
                  controller: contentOrderController,
                  decoration: const InputDecoration(labelText: 'Content Order'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateLessonContent(
                  content.id,
                  contentTextController.text,
                  contentVideoController.text,
                  contentTypeController.text,
                  int.parse(contentOrderController.text),
                );
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _createLessonContent(
      int lessonId, String contentText, String contentVideo, String contentType, int contentOrder) async {
    try {
      final response = await http.post(
        Uri.parse('$domain/api/lesson-content/lessons/$lessonId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'content_text': contentText,
          'content_type': contentType,
          'content_order': contentOrder,
          'content_video': contentVideo
        }),
      );

      if (response.statusCode == 201) {
        _loadLessonContent(lessonId);
      } else {
        print('Failed to create lesson content');
      }
    } catch (e) {
      print('Error creating lesson content: $e');
    }
  }

  Future<void> _deleteLessonContent(int contentId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this lesson content?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      final response = await http.delete(Uri.parse('$domain/api/lesson-content/$contentId'));

      if (response.statusCode == 200) {
        _loadLessonContent(_selectedLessonId!);
      } else {
        throw Exception('Failed to delete lesson content');
      }
    }
  }

  void _showCreateLessonContentDialog(int lessonId) {
    TextEditingController contentTextController = TextEditingController();
    TextEditingController contentVideoController = TextEditingController();
    TextEditingController contentTypeController = TextEditingController();
    TextEditingController contentOrderController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Lesson Content'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: contentTextController,
                  decoration: const InputDecoration(labelText: 'Content Text'),
                ),
                TextField(
                  controller: contentVideoController,
                  decoration: const InputDecoration(labelText: 'Content Video'),
                ),
                TextField(
                  controller: contentTypeController,
                  decoration: const InputDecoration(labelText: 'Content Type'),
                ),
                TextField(
                  controller: contentOrderController,
                  decoration: const InputDecoration(labelText: 'Content Order'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _createLessonContent(
                  lessonId,
                  contentTextController.text,
                  contentVideoController.text,
                  contentTypeController.text,
                  int.parse(contentOrderController.text),
                );
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateLessonContent(
      int contentId, String contentText, String contentVideo, String contentType, int contentOrder) async {
    try {
      final response = await http.put(
        Uri.parse('$domain/api/lesson-content/$contentId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'content_text': contentText,
          'content_type': contentType,
          'content_order': contentOrder,
          'content_video': contentVideo
        }),
      );

      if (response.statusCode == 200) {
        print('Lesson content updated successfully');
        _loadLessonContent(_selectedLessonId!); // Refresh content list after updating
      } else {
        print('Failed to update lesson content');
      }
    } catch (e) {
      print('Error updating lesson content: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses, Lessons & Content'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                          elevation: 4.0,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              course.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: const Icon(
                              CupertinoIcons.arrow_right,
                              color: Colors.deepPurpleAccent,
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
            const Divider(),
            if (_lessons != null)
              Expanded(
                child: FutureBuilder<List<Lesson>>(
                  future: _lessons,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No lessons available'));
                    } else {
                      final lessonsList = snapshot.data!;
                      return ListView.builder(
                        itemCount: lessonsList.length,
                        itemBuilder: (context, index) {
                          final lesson = lessonsList[index];
                          return Card(
                            elevation: 4.0,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              title: Text(
                                lesson.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              trailing: const Icon(
                                CupertinoIcons.arrow_right,
                                color: Colors.deepPurpleAccent,
                              ),
                              onTap: () {
                                _loadLessonContent(lesson.id);
                              },
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            const Divider(),
            if (_lessonContents != null)
              Expanded(
                child: FutureBuilder<List<LessonContent>>(
                  future: _lessonContents,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No content available'));
                    } else {
                      final contentList = snapshot.data!;
                      return ListView.builder(
                        itemCount: contentList.length,
                        itemBuilder: (context, index) {
                          final content = contentList[index];
                          return Card(
                            elevation: 4.0,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              title: Text(content.contentText),
                              subtitle: Text('Order: ${content.contentOrder}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      _showEditLessonContentDialog(content);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _deleteLessonContent(content.id);
                                    },
                                  ),
                                ],
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
      floatingActionButton: _selectedLessonId != null
          ? FloatingActionButton(
              onPressed: () {
                _showCreateLessonContentDialog(_selectedLessonId!);
              },
              backgroundColor: Colors.deepPurpleAccent,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
