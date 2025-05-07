import 'package:flutter/material.dart';

class LicenseVerifyPage extends StatelessWidget {
  const LicenseVerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '면허증 인증',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 40), // ← 위쪽 간격 증가
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 텍스트 간격 조절
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 23,
                    height: 1.4,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: '기사님의\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '운전면허증',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF54D2A7),
                      ),
                    ),
                    TextSpan(
                      text: '과\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '화물운송 종사자격증',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF54D2A7),
                      ),
                    ),
                    TextSpan(
                      text: '을 준비해주세요',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16), // 간격 살짝 늘림
              const Text(
                '자격을 확인하기 위한 인증이에요.',
                style: TextStyle(fontSize: 14, color: Color(0xFFBDBDBD)),
              ),
              const SizedBox(height: 50),

              // 이미지
              Center(
                child: Image.asset(
                  'assets/images/signup/license_sample.png',
                  width: 400,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: SizedBox(
          height: 60,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/signup_experience');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF54D2A7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              '다음',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
