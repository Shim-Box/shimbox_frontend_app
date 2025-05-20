import 'package:flutter/material.dart';
import '../home/home.dart'; //홈으로

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                const TextField(
                  decoration: InputDecoration(
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
                const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
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

                // 링크 (회원가입만 클릭 가능)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '아이디 찾기 | 비밀번호 찾기 | ',
                      style: TextStyle(fontSize: 13, color: Color(0xFFBDBDBD)),
                    ),
                    GestureDetector(
                      onTap:
                          () => Navigator.pushNamed(context, '/signup_verify'),
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
                    onPressed: () {
                      Navigator.push(
                        //홈으로 예비
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
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
