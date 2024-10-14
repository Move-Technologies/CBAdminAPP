import 'package:flutter/material.dart';
import 'package:coursebro_admin/pages/splashscreen.dart';
import 'package:get/get.dart';

const domain = "https://coursebro.io";
// const domain = "http://localhost:8000";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
