import 'package:flutter/material.dart';

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

              // 아이디
              const Text('아이디', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _idController,
                decoration: const InputDecoration(
                  hintText: '아이디 입력',
                  hintStyle: hintStyle,
                  enabledBorder: underlineBorder,
                  focusedBorder: underlineBorder,
                  contentPadding: inputPadding,
                ),
              ),
              const SizedBox(height: 32),

              // 비밀번호
              const Text('비밀번호', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: '비밀번호 입력',
                  hintStyle: hintStyle,
                  enabledBorder: underlineBorder,
                  focusedBorder: underlineBorder,
                  contentPadding: inputPadding,
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
            onPressed: () {
              Navigator.pushNamed(context, '/signup_license');
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
