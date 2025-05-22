import 'package:flutter/material.dart';

class SignupHealthPage extends StatefulWidget {
  const SignupHealthPage({super.key});

  @override
  State<SignupHealthPage> createState() => _SignupHealthPageState();
}

class _SignupHealthPageState extends State<SignupHealthPage> {
  String _selectedHealthStatus = '없음';

  final List<String> _healthOptions = ['없음', '고혈압', '저혈압'];

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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
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
                    TextSpan(text: '마지막으로,\n'),
                    TextSpan(
                      text: '건강 상태',
                      style: TextStyle(color: Color(0xFF54D2A7)),
                    ),
                    TextSpan(text: '를 알려주세요!'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Divider(thickness: 1, color: Color(0xFFE0E0E0), height: 32),
              const Text(
                'Q. 건강 특이사항이 있나요?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedHealthStatus,
                    icon: const Icon(Icons.arrow_drop_down),
                    isExpanded: true,
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    items:
                        _healthOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedHealthStatus = newValue!;
                      });
                    },
                  ),
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
