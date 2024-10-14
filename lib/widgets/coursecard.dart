import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:coursebro_admin/model/coursemodel.dart';

import '../main.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final Function onDelete;
  final Function onUpdate;

  const CourseCard({super.key, required this.course, required this.onDelete, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showOptionsDialog(context),
      child: Card(
        margin: const EdgeInsets.all(10),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Image.network(
                course.iconUrl,
                width: 80,
                height: 80,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 80);
                },
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(course.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 5),
                    Text('Level: ${course.level} | Salary: \$${course.salary}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Display edit/delete options when a course is tapped
  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Options'),
          content: const Text('What do you want to do?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _editCourse(context);
              },
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _confirmDelete(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Confirm deletion before making the DELETE request
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${course.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteCourse(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Send DELETE request to API
  Future<void> _deleteCourse(BuildContext context) async {
    final url = '$domain/api/courses/${course.id}';
    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Course deleted successfully')),
          );
        }
        onDelete(); // Call the onDelete function to update the list
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete course')),
          );
        }
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    }
  }

  // Function to edit course details
  void _editCourse(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController(text: course.name);
        final descriptionController = TextEditingController(text: course.description);
        final levelController = TextEditingController(text: course.level);
        final salaryController = TextEditingController(text: course.salary);

        return AlertDialog(
          title: const Text('Edit Course'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Course Name'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: levelController,
                  decoration: const InputDecoration(labelText: 'Level'),
                ),
                TextField(
                  controller: salaryController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Salary'),
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
              onPressed: () async {
                // Call the API to update the course
                final updatedCourse = {
                  'course_name': nameController.text,
                  'course_description': descriptionController.text,
                  'course_level': levelController.text,
                  'course_salary': salaryController.text,
                };

                final url = '$domain/api/courses/${course.id}';
                try {
                  final response = await http.put(
                    Uri.parse(url),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode(updatedCourse),
                  );
                  if (response.statusCode == 200) {
                    Navigator.pop(context); // Close the dialog box
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Course updated successfully')),
                    );
                    onUpdate(); // Call the onUpdate function to refresh the list
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to update course')),
                    );
                  }
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $error')),
                  );
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
