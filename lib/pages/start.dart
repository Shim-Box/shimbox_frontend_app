import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimbox_app/pages/signup/signup_verify.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool agreeAll = false;
  bool agreeTerms = false;
  bool agreePrivacy = false;
  bool agreeLocation = false;

  void _checkAll(bool? value) async {
    setState(() {
      agreeAll = value ?? false;
      agreeTerms = agreeAll;
      agreePrivacy = agreeAll;
      agreeLocation = agreeAll;
    });

    // 전체동의가 체크된 경우 무조건 위치 권한 요청
    if (agreeAll) {
      await _requestLocationPermission();
    }
  }

  void _checkEach() {
    setState(() {
      agreeAll = agreeTerms && agreePrivacy && agreeLocation;
    });
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    setState(() {
      agreeLocation = status.isGranted;
      _checkEach();
    });
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('위치 권한이 필요합니다. 권한을 허용해주세요.'),
          action:
              status.isPermanentlyDenied
                  ? SnackBarAction(
                    label: '설정',
                    onPressed: () => openAppSettings(),
                  )
                  : null,
        ),
      );
    }
  }

  Future<void> _handleSignup() async {
    // 실제 위치 권한 상태 확인
    final status = await Permission.location.status;
    if (!status.isGranted) {
      await _requestLocationPermission();
    }

    // 모든 약관이 동의되고 위치 권한이 허용된 경우에만 페이지 이동
    if (agreeTerms && agreePrivacy && agreeLocation && status.isGranted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SignupVerifyPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAgreed = agreeTerms && agreePrivacy && agreeLocation;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                Image.asset('assets/images/logo.png', height: 50),
                const SizedBox(height: 40),
                Image.asset('assets/images/start_illustration.png', width: 230),
                const SizedBox(height: 20),

                // 약관 동의 항목
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      CheckboxListTile(
                        title: const Text('약관 전체동의'),
                        value: agreeAll,
                        activeColor: const Color(0xFF54D2A7),
                        onChanged: _checkAll,
                      ),
                      CheckboxListTile(
                        title: const Text('이용약관 동의 (필수)'),
                        value: agreeTerms,
                        activeColor: const Color(0xFF54D2A7),
                        onChanged: (value) {
                          setState(() => agreeTerms = value ?? false);
                          _checkEach();
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('개인정보 수집 및 이용 동의 (필수)'),
                        value: agreePrivacy,
                        activeColor: const Color(0xFF54D2A7),
                        onChanged: (value) {
                          setState(() => agreePrivacy = value ?? false);
                          _checkEach();
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('사용자 위치 정보 제공 동의 (필수)'),
                        value: agreeLocation,
                        activeColor: const Color(0xFF54D2A7),
                        onChanged: (value) async {
                          if (value == true && !agreeLocation) {
                            await _requestLocationPermission();
                          } else {
                            setState(() => agreeLocation = value ?? false);
                            _checkEach();
                          }
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isAgreed ? _handleSignup : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isAgreed ? const Color(0xFF54D2A7) : Colors.grey,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      '회원가입하기',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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
