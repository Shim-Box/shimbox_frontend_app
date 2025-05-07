import 'package:flutter/material.dart';

class ExperienceDetailPage extends StatefulWidget {
  const ExperienceDetailPage({super.key});

  @override
  State<ExperienceDetailPage> createState() => _ExperienceDetailPageState();
}

class _ExperienceDetailPageState extends State<ExperienceDetailPage> {
  int? _selectedDays;
  int? _selectedHours;
  final _areaController = TextEditingController();

  @override
  void dispose() {
    _areaController.dispose();
    super.dispose();
  }

  Widget buildOption({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE6F4EF) : const Color(0xFFF6F6F6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF54D2A7) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              selected
                  ? 'assets/images/signup/check_true2.png'
                  : 'assets/images/signup/check_false2.png',
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 12),
            Text(text, style: const TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '경력 기입',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
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
                      style: TextStyle(
                        color: Color(0xFF54D2A7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: '을 선택해주세요'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Divider(thickness: 1, color: Color(0xFFE0E0E0), height: 32),

              const Text(
                'Q1. 주 몇 일 정도 근무하셨나요?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              buildOption(
                text: '주 4일~5일',
                selected: _selectedDays == 0,
                onTap: () => setState(() => _selectedDays = 0),
              ),
              buildOption(
                text: '주 5일 이상',
                selected: _selectedDays == 1,
                onTap: () => setState(() => _selectedDays = 1),
              ),

              const SizedBox(height: 30),
              const Text(
                'Q2. 하루에 평균 몇시간 일하셨나요?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              buildOption(
                text: '4~6시간',
                selected: _selectedHours == 0,
                onTap: () => setState(() => _selectedHours = 0),
              ),
              buildOption(
                text: '6~8시간',
                selected: _selectedHours == 1,
                onTap: () => setState(() => _selectedHours = 1),
              ),
              buildOption(
                text: '8시간 이상',
                selected: _selectedHours == 2,
                onTap: () => setState(() => _selectedHours = 2),
              ),

              const SizedBox(height: 30),
              const Text(
                'Q3. 담당했던 근무지를 작성해주세요.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _areaController,
                decoration: InputDecoration(
                  hintText: 'ex) 성북구',
                  hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
                  filled: true,
                  fillColor: const Color(0xFFF6F6F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
              Navigator.pushNamed(context, '/signup_waiting');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF54D2A7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              '완료',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
