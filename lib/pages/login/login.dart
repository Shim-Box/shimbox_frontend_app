import 'package:flutter/material.dart';
import 'package:shimbox_app/models/login_data.dart';
import 'package:shimbox_app/models/login_response.dart' as model;
import 'package:shimbox_app/utils/api_service.dart';
import '../root/root.dart';
import 'package:shimbox_app/models/test_user_data.dart'; // 🔄 정적 저장용 UserData

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final loginData = LoginData(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    final model.LoginResponse? result = await ApiService.loginUser(loginData);
    print('서버 응답값: $result');

    if (result != null) {
      final userData = result.data;

      if (!userData.approved) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❗승인되지 않은 계정입니다. 관리자에게 문의하세요.')),
        );
        return;
      }

      // 승인된 사용자일 경우 정보 저장
      UserData.name = userData.name;
      UserData.token = userData.accessToken;
      UserData.email = loginData.email;

      print('✅ 저장된 사용자 이름: ${UserData.name}');
      print('✅ 저장된 토큰: ${UserData.token}');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RootPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❗계정이 존재하지 않거나 비밀번호가 틀렸습니다')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 45),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 로고
                Image.asset('assets/images/logo.png', height: 55),
                const SizedBox(height: 60),

                // 아이디
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '아이디',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // 비밀번호
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '비밀번호',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 링크
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '아이디 찾기 | 비밀번호 찾기 | ',
                      style: TextStyle(fontSize: 13, color: Color(0xFFBDBDBD)),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/start'),
                      child: const Text(
                        '회원가입',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFBDBDBD),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 70),

                // 로그인 버튼
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF54D2A7),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      '로그인',
                      style: TextStyle(
                        fontSize: 18,
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
