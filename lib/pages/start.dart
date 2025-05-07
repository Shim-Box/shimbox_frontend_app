import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 텍스트
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '건강한 근무',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '의 시작,\n'),
                      TextSpan(
                        text: '쉼박스',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '와 함께'),
                    ],
                    style: const TextStyle(
                      fontSize: 25,
                      height: 1.5,
                      color: Colors.black,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),

                // 로고
                Image.asset('assets/images/logo.png', height: 50),
                const SizedBox(height: 60),

                // 일러스트
                Image.asset('assets/images/start_illustration.png', width: 250),
                const SizedBox(height: 35),

                // 버튼
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF54D2A7),
                    minimumSize: const Size(290, 55),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    '시작하기',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
