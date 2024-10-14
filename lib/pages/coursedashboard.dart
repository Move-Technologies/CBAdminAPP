import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:coursebro_admin/model/coursemodel.dart';

import '../main.dart';
import '../widgets/coursecard.dart'; // Import the course model

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  late Future<List<Course>> _futureCourses;

  @override
  void initState() {
    super.initState();
    _futureCourses = fetchCourses();
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

  Future<void> _addCourse(Map<String, dynamic> courseData) async {
    final response = await http.post(
      Uri.parse('$domain/api/courses/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(courseData),
    );

    if (response.statusCode == 201) {
      _refreshCourses();
    } else {
      throw Exception('Failed to add course');
    }
  }

  void _refreshCourses() {
    setState(() {
      _futureCourses = fetchCourses(); // Reload courses after deletion or addition
    });
  }

  void _showAddCourseDialog() {
    final _formKey = GlobalKey<FormState>();
    final Map<String, dynamic> courseData = {};

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Course'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Course Name'),
                    onSaved: (value) => courseData['course_name'] = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a course name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Course Description'),
                    onSaved: (value) => courseData['course_description'] = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a course description';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Course Level'),
                    onSaved: (value) => courseData['course_level'] = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the course level';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Course Salary'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => courseData['course_salary'] = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the salary';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Course Icon'),
                    onSaved: (value) => courseData['course_icon'] = value,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Job Description'),
                    onSaved: (value) => courseData['job_desc'] = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the job description';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Companies Hiring'),
                    onSaved: (value) => courseData['companies_hiring'] = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the companies hiring';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Jobs Open'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => courseData['jobs_open'] = int.parse(value ?? '0'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the number of jobs open';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _addCourse(courseData).then((_) {
                    Navigator.of(context).pop();
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddCourseDialog,
          ),
        ],
      ),
      body: FutureBuilder<List<Course>>(
        future: _futureCourses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No courses found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final course = snapshot.data![index];
              return CourseCard(
                course: course,
                onDelete: _refreshCourses, // Pass the refresh function to delete
                onUpdate: _refreshCourses,
              );
            },
          );
        },
      ),
    );
  }
}
