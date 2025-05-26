import 'package:flutter/material.dart';
import 'package:shimbox_app/pages/signup/signup_detail.dart';
import 'package:shimbox_app/pages/signup/signup_experience.dart';
import 'package:shimbox_app/pages/signup/signup_health.dart';
import 'package:shimbox_app/pages/signup/signup_license.dart';
import 'package:shimbox_app/pages/signup/signup_waiting.dart';
// import 'app.dart';
import 'package:get/get.dart';
import 'bindings/init_bindings.dart';
import 'pages/root/root.dart';
import 'pages/splash.dart';
import 'pages/start.dart';
import 'pages/login/login.dart';
import 'pages/signup/signup_verify.dart';
import 'pages/signup/signup_account.dart';
import 'pages/health/health_status.dart';
import 'pages/wearable/wearable.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: InitBindings(),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => SplashPage()),
        GetPage(name: '/start', page: () => StartPage()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/signup_verify', page: () => SignupVerifyPage()),
        GetPage(name: '/signup_account', page: () => SignupAccountPage()),
        GetPage(name: '/signup_license', page: () => LicenseVerifyPage()),
        GetPage(name: '/signup_experience', page: () => ExperienceSelectPage()),
        GetPage(name: '/signup_detail', page: () => ExperienceDetailPage()),
        GetPage(name: '/signup_health', page: () => SignupHealthPage()),
        GetPage(name: '/signup_waiting', page: () => SignupCompletePage()),
        GetPage(name: '/home', page: () => RootPage()),
        GetPage(name: '/health_status', page: () => HealthPage()),
        GetPage(name: '/wearable', page: () => WearablePage()),
      ],
    );
  }
}
