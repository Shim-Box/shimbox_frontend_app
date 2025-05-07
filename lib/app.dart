import 'package:flutter/material.dart';
import 'config/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shimbox',
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // 스플래쉬
      routes: appRoutes, // routes.dart
      theme: ThemeData(
        //fontFamily: 'Pretendard',
        primaryColor: Color(0xFF54D2A7),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
    );
  }
}
