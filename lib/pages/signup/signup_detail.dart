import 'package:flutter/material.dart';
import '../../models/signup_data.dart';
import '../../utils/database.dart';

class ExperienceDetailPage extends StatefulWidget {
  const ExperienceDetailPage({super.key});

  @override
  State<ExperienceDetailPage> createState() => _ExperienceDetailPageState();
}

class _ExperienceDetailPageState extends State<ExperienceDetailPage> {
  int? _selectedHours;
  int? _selectedDeliveries;

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
            Text(
              text,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // 데이터 저장 및 이동 메서드
  void _submitExperienceDetail() {
    // 평균 근무 시간 저장 (텍스트로 매핑)
    switch (_selectedHours) {
      case 0:
        signupData.averageWorking = '4~6시간';
        break;
      case 1:
        signupData.averageWorking = '6~8시간';
        break;
      case 2:
        signupData.averageWorking = '8시간 이상';
        break;
    }

    // 평균 배송 횟수 저장 (텍스트로 매핑)
    switch (_selectedDeliveries) {
      case 0:
        signupData.averageDelivery = '100건 이하';
        break;
      case 1:
        signupData.averageDelivery = '101~200건';
        break;
      case 2:
        signupData.averageDelivery = '201~300건';
        break;
      case 3:
        signupData.averageDelivery = '300건 이상';
        break;
    }

    Navigator.pushNamed(context, '/signup_health');
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
                'Q1. 하루에 평균 몇시간 일하셨나요?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                'Q2. 하루에 평균 몇 건을 배달하셨나요?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              buildOption(
                text: '100건 이하',
                selected: _selectedDeliveries == 0,
                onTap: () => setState(() => _selectedDeliveries = 0),
              ),
              buildOption(
                text: '101~200건',
                selected: _selectedDeliveries == 1,
                onTap: () => setState(() => _selectedDeliveries = 1),
              ),
              buildOption(
                text: '201~300건',
                selected: _selectedDeliveries == 2,
                onTap: () => setState(() => _selectedDeliveries = 2),
              ),
              buildOption(
                text: '300건 이상',
                selected: _selectedDeliveries == 3,
                onTap: () => setState(() => _selectedDeliveries = 3),
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
            onPressed:
                _selectedHours != null && _selectedDeliveries != null
                    ? _submitExperienceDetail
                    : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _selectedHours != null && _selectedDeliveries != null
                      ? const Color(0xFF54D2A7)
                      : const Color(0xFFD3D3D3),
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
