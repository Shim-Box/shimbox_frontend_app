import 'package:flutter/material.dart';
import 'dart:async';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
      // Navigator.pushReplacementNamed(context, '/start');
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF54D2A7), // 배경색
      body: Center(
        child: Image.asset(
          'assets/images/splash_icon.png',
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
