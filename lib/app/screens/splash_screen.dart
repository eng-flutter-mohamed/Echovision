// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // الانتظار لمدة 3 ثواني ثم الانتقال للصفحة التالية
    Timer(const Duration(milliseconds: 800), () {
    Get.to(LoginScreen());
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/Images/SplashScreen.png', // تأكد من صحة المسار وامتداد الصورة
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
