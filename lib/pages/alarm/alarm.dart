import 'package:flutter/material.dart';

class AlarmPage extends StatelessWidget {
  const AlarmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
        backgroundColor: const Color(0xFF54D2A7),
        centerTitle: true,
      ),
      body: const Center(child: Text('테스트', style: TextStyle(fontSize: 24))),
    );
  }
}
