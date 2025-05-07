import 'package:flutter/material.dart';

class ExperienceSelectPage extends StatefulWidget {
  const ExperienceSelectPage({super.key});

  @override
  State<ExperienceSelectPage> createState() => _ExperienceSelectPageState();
}

class _ExperienceSelectPageState extends State<ExperienceSelectPage> {
  int selectedIndex = 0;

  final List<Map<String, String>> experienceOptions = [
    {'title': '초보자', 'subtitle': '3개월 미만'},
    {'title': '경력자', 'subtitle': '1~2년'},
    {'title': '숙련자', 'subtitle': '3~4년 이상'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '경력 기입',
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
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 23,
                    height: 1.4,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(text: '기사님의\n'),
                    TextSpan(
                      text: '경력',
                      style: TextStyle(color: Color(0xFF54D2A7)),
                    ),
                    TextSpan(text: '을 선택해주세요'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '정확한 배정을 위해 경력 정보를 확인합니다.',
                style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 14),
              ),
              const SizedBox(height: 32),

              // 경력 카드
              ...List.generate(3, (index) {
                final isSelected = selectedIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 25,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? const Color(0xFFE0F4EE)
                              : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            isSelected
                                ? const Color(0xFF54D2A7)
                                : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/signup/driver_icon.png',
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              experienceOptions[index]['title']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              experienceOptions[index]['subtitle']!,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/signup_detail');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF54D2A7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
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
