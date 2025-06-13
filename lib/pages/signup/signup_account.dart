import 'package:flutter/material.dart';
import '../../models/signup_data.dart';
import '../../utils/database.dart';

class SignupAccountPage extends StatefulWidget {
  const SignupAccountPage({super.key});

  @override
  State<SignupAccountPage> createState() => _SignupAccountPageState();
}

class _SignupAccountPageState extends State<SignupAccountPage> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  static const hintStyle = TextStyle(color: Color(0xFFD2D2D2), fontSize: 14);
  static const underlineBorder = UnderlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFD9D9D9)),
  );
  static const inputPadding = EdgeInsets.only(bottom: 6);

  bool get isPasswordMatch =>
      _passwordController.text.isNotEmpty &&
      _passwordController.text == _confirmPasswordController.text;

  bool get isPasswordValid => _passwordController.text.length >= 8;

  bool get isEmailValid {
    final email = _idController.text.trim();
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
    _confirmPasswordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  // 데이터 저장 및 이동 메서드
  void _submitAccount() {
    signupData.email = _idController.text.trim(); // 아이디를 이메일 필드에 저장 (필요에 따라 조정)
    signupData.password = _passwordController.text.trim();
    signupData.residence = _addressController.text.trim();
    signupData.height = int.tryParse(_heightController.text.trim());
    signupData.weight = int.tryParse(_weightController.text.trim());

    // 유효성 검사 (예: 빈 값 체크)
    if (_idController.text.isEmpty ||
        !isEmailValid ||
        _passwordController.text.isEmpty ||
        !isPasswordValid ||
        _addressController.text.isEmpty ||
        _heightController.text.isEmpty ||
        _weightController.text.isEmpty ||
        !isPasswordMatch) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('모든 필드를 올바르게 입력해주세요.')));
      return;
    }

    Navigator.pushNamed(context, '/signup_license');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '회원가입',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '회원가입',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF54D2A7),
                ),
              ),
              const SizedBox(height: 24),

              // email
              const Text(
                'email',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _idController,
                onChanged: (_) => setState(() {}), // 상태 갱신
                decoration: const InputDecoration(
                  hintText: 'email 입력',
                  hintStyle: hintStyle,
                  enabledBorder: underlineBorder,
                  focusedBorder: underlineBorder,
                  contentPadding: inputPadding,
                ),
              ),
              // 이메일 유효성 메시지
              if (_idController.text.isNotEmpty && !isEmailValid)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    'email 형식이 틀립니다',
                    style: TextStyle(fontSize: 12, color: Colors.red),
                  ),
                ),
              const SizedBox(height: 32),

              // 비밀번호
              const Text('비밀번호', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _passwordController,
                obscureText: true,
                onChanged: (_) => setState(() {}), // 상태 갱신
                decoration: const InputDecoration(
                  hintText: '비밀번호 입력',
                  hintStyle: hintStyle,
                  enabledBorder: underlineBorder,
                  focusedBorder: underlineBorder,
                  contentPadding: inputPadding,
                ),
              ),
              // 비밀번호 유효성 메시지
              if (_passwordController.text.isNotEmpty && !isPasswordValid)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    '비밀번호는 8자 이상이어야 합니다',
                    style: TextStyle(fontSize: 12, color: Colors.red),
                  ),
                ),
              const SizedBox(height: 32),

              // 비밀번호 확인
              Row(
                children: [
                  const Text(
                    '비밀번호 확인',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  if (_confirmPasswordController.text.isNotEmpty)
                    Image.asset(
                      isPasswordMatch
                          ? 'assets/images/signup/check_true.png'
                          : 'assets/images/signup/check_false.png',
                      width: 16,
                      height: 16,
                    ),
                  const SizedBox(width: 4),
                  if (_confirmPasswordController.text.isNotEmpty)
                    Text(
                      '비밀번호 일치',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            isPasswordMatch
                                ? const Color(0xFF54D2A7)
                                : Colors.grey,
                      ),
                    ),
                ],
              ),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: '비밀번호 확인',
                  hintStyle: hintStyle,
                  enabledBorder: underlineBorder,
                  focusedBorder: underlineBorder,
                  contentPadding: inputPadding,
                ),
              ),
              const SizedBox(height: 40),

              const Text(
                '추가 정보',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF54D2A7),
                ),
              ),
              const SizedBox(height: 24),

              // 거주지
              const Text('거주지', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        hintText: '서울 성북구 삼양로',
                        hintStyle: hintStyle,
                        enabledBorder: underlineBorder,
                        focusedBorder: underlineBorder,
                        contentPadding: inputPadding,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Image.asset(
                    'assets/images/signup/marker.png',
                    width: 20,
                    height: 20,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // 키
              const Text('키', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _heightController,
                      maxLength: 3,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: '키 입력',
                        hintStyle: hintStyle,
                        counterText: '',
                        enabledBorder: underlineBorder,
                        focusedBorder: underlineBorder,
                        contentPadding: inputPadding,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('cm', style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 32),

              // 몸무게
              const Text('몸무게', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _weightController,
                      maxLength: 3,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: '몸무게 입력',
                        hintStyle: hintStyle,
                        counterText: '',
                        enabledBorder: underlineBorder,
                        focusedBorder: underlineBorder,
                        contentPadding: inputPadding,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('kg', style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 60),
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
            onPressed: _submitAccount,
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
