import 'package:coursebro_admin/pages/coursedashboard.dart';
import 'package:coursebro_admin/pages/lesson_content.dart';
import 'package:coursebro_admin/pages/lesson_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF443F89),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            _buildDashboardTile(
              context: context,
              icon: Icons.book_outlined,
              title: 'Courses',
              onTap: () {
                Get.to(const CoursesScreen());
              },
            ),
            const SizedBox(height: 20),
            _buildDashboardTile(
              context: context,
              icon: Icons.video_library_outlined,
              title: 'Lessons',
              onTap: () {
                Get.to(const LessonsScreen());
                // Navigate to Lessons screen
              },
            ),
            const SizedBox(height: 20),
            _buildDashboardTile(
              context: context,
              icon: Icons.article_outlined,
              title: 'Content',
              onTap: () {
                Get.to(const LessonContentScreen());
                // Navigate to Content screen
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 4,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF443F89),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}