import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class SignupVerifyPage extends StatefulWidget {
  const SignupVerifyPage({super.key});

  @override
  State<SignupVerifyPage> createState() => _SignupVerifyPageState();
}

class _SignupVerifyPageState extends State<SignupVerifyPage> {
  final _nameController = TextEditingController();
  final _rrnFrontController = TextEditingController();
  final _rrnBackController = TextEditingController();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  // String? _verificationId;
  bool _isVerified = false;
  bool _codeSent = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() => setState(() {}));
    _codeController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rrnFrontController.dispose();
    _rrnBackController.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  bool get isPhoneValid => _phoneController.text.trim().length == 11;
  bool get isCodeValid => _codeController.text.trim().length == 6;

  // --- Utils ---
  String? formatPhoneNumber(String raw) {
    raw = raw.trim();
    if (raw.length == 11 && raw.startsWith('0')) {
      return '+82${raw.substring(1)}';
    }
    return null;
  }

  void showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // --- 인증 로직 --- (주석 처리됨)
  /*
  Future<void> _sendCode() async {
    final formatted = formatPhoneNumber(_phoneController.text);
    if (formatted == null) {
      showSnack('유효한 전화번호를 입력해주세요.');
      return;
    }

    print('인증 요청: $formatted');

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: formatted,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('✅ 자동 인증 완료');
          await FirebaseAuth.instance.signInWithCredential(credential);
          setState(() => _isVerified = true);
          showSnack('자동 인증 성공!');
        },
        verificationFailed: (FirebaseAuthException e) {
          print('인증 실패: ${e.code}, ${e.message}');
          showSnack('인증 실패: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          print('인증번호 전송됨 (verificationId: $verificationId)');
          setState(() {
            _verificationId = verificationId;
            _codeSent = true;
          });
          showSnack('인증번호가 전송되었습니다.');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('자동 인증 타임아웃');
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      print('인증 요청 예외 발생: $e');
      showSnack('인증 요청 중 오류 발생: $e');
    }
  }

  Future<void> _verifyCode() async {
    if (_verificationId == null || !isCodeValid) {
      showSnack('인증번호를 확인해주세요.');
      return;
    }

    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: _codeController.text.trim(),
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() => _isVerified = true);
      showSnack('인증 성공!');
    } catch (e) {
      showSnack('인증 실패: ${e.toString()}');
    }
  }
*/

  // --- UI ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            'assets/images/signup/arrow-left.png',
            width: 24,
            height: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '본인인증',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '본인인증',
                style: TextStyle(
                  color: Color(0xFF54D2A7),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '본인 인증을 위해 필요한 정보를 입력해 주세요.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(221, 23, 23, 23),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),

              // 이름
              const Text(
                '이름',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _nameController,
                  maxLength: 3,
                  decoration: const InputDecoration(
                    hintText: '이름 입력',
                    hintStyle: TextStyle(
                      color: Color(0xFFD2D2D2),
                      fontSize: 14,
                    ),
                    counterText: '',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                    contentPadding: EdgeInsets.only(bottom: 6),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // 주민등록번호
              const Text(
                '주민등록번호',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: _rrnFrontController,
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: '앞 6자리',
                        hintStyle: TextStyle(
                          color: Color(0xFFD2D2D2),
                          fontSize: 14,
                        ),
                        counterText: '',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                        ),
                        contentPadding: EdgeInsets.only(bottom: 6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text('-'),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 40,
                    child: TextField(
                      controller: _rrnBackController,
                      maxLength: 1,
                      obscureText: true,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        counterText: '',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                        ),
                        contentPadding: EdgeInsets.only(bottom: 6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(' ● ● ● ● ●'),
                ],
              ),
              const SizedBox(height: 40),

              // 전화번호
              const Text(
                '전화번호 인증',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      maxLength: 11,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: '전화번호 입력',
                        hintStyle: TextStyle(
                          color: Color(0xFFD2D2D2),
                          fontSize: 14,
                        ),
                        counterText: '',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                        ),
                        contentPadding: EdgeInsets.only(bottom: 6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: null, // 인증 요청 비활성화
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(100, 40),
                      foregroundColor: const Color(0xFFD3D3D3),
                      side: const BorderSide(color: Color(0xFFD3D3D3)),
                    ),
                    child: const Text('인증요청', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              if (_codeSent) ...[
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _codeController,
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: '인증 번호 입력',
                          hintStyle: TextStyle(
                            color: Color(0xFFD2D2D2),
                            fontSize: 14,
                          ),
                          counterText: '',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                          ),
                          contentPadding: EdgeInsets.only(bottom: 6),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: null, // 인증 확인 비활성화
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 40),
                        backgroundColor: Colors.transparent,
                        foregroundColor: const Color(0xFFD3D3D3),
                      ),
                      child: const Text('확인', style: TextStyle(fontSize: 13)),
                    ),
                  ],
                ),
              ],
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
              // 👉 인증 생략: 바로 다음 화면으로 이동
              Navigator.pushNamed(context, '/signup_account');
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
