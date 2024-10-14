import 'package:coursebro_admin/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
    Get.off(const Dashboard());
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white, // Set the color you want// Light text on dark background
    ));
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Container
            Container(
              width: 254, // Adjusted width to match the logo size in the screenshot
              height: 254, // Adjusted height to match the logo size in the screenshot
              decoration: BoxDecoration(
                color: const Color(0xFF443F89),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFA6A1FB),
                  width: 16, // Border width matching the example
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'C',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 140,
                        fontWeight: FontWeight.bold,
                        height: 0.9, // Adjust height to reduce gap
                      ),
                    ),
                    Text(
                      'course bro',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 0.9, // Reduced line height to minimize gap
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30), // Spacing between the logo and the text
            // Subtitle Text
            const Text(
              'Courses To Earn\nMoney Online',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF525F7F),
                fontSize: 24, // Increased font size for better visibility
                fontWeight: FontWeight.w800, // Made the font bolder for better emphasis
                letterSpacing: 0.5, // Optional: Add letter spacing for a cleaner look
              ),
            )
          ],
        ),
      ),
    );
  }
}
