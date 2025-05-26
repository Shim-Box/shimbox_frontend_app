import 'package:flutter/material.dart';
import 'package:shimbox_app/pages/health/health_connect_service.dart';
import 'package:flutter/services.dart';

class WearablePage extends StatelessWidget {
  const WearablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Google Fit 연동',
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
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Health Sync 연결',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 16),
              Center(
                child: Image.asset(
                  'assets/images/wearable/connection_flow.png',
                  width: 270,
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  '*걸음 수를 가져오는데 시간이 걸릴 수 있어요.\n조금만 기다려주세요.',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                '아래 순서로 다시 확인해주세요!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              const SizedBox(height: 12),
              const Text('· Health Sync에서 삼성헬스를 Google Fit으로 연동해 주세요.\n'),
              const SizedBox(height: 6),
              const Text('· Google Fit 앱 로그인 및 설치가 필요해요.\n'),
              const SizedBox(height: 6),
              const Text('· 하루 걸음 수가 반영되기까지 시간이 걸릴 수 있어요.\n'),
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
            onPressed: () async {
              try {
                final result = await HealthConnectService.requestPermissions();
                if (result == 'granted') {
                  Navigator.pop(context, true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Google Fit 연동 실패: $result')),
                  );
                }
              } catch (e) {
                if (e is PlatformException) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('오류: ${e.message ?? e.code}')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('알 수 없는 오류: ${e.toString()}')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF54D2A7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Google Fit 연동하기 →',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
