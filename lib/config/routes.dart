import 'package:flutter/material.dart';

import '../pages/splash.dart'; //스플래시
import '../pages/start.dart'; //시작하기
import '../pages/login/login.dart'; //로그인
import '../pages/signup/signup_verify.dart'; //회원가입 주민번호
import '../pages/signup/signup_account.dart'; //회원가입 아디비번
import '../pages/signup/signup_license.dart'; //회원가입 자격증
import '../pages/signup/signup_experience.dart'; //회원가입 경력 선택
import '../pages/signup/signup_detail.dart'; //회원가입 경력 자세히
import '../pages/signup/signup_health.dart'; //건강 상태
import '../pages/signup/signup_waiting.dart'; //승인 대기

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const SplashPage(),
  '/start': (context) => const StartPage(),
  '/login': (context) => const LoginPage(),
  '/signup_verify': (context) => const SignupVerifyPage(),
  '/signup_account': (context) => const SignupAccountPage(),
  '/signup_license': (context) => const LicenseVerifyPage(),
  '/signup_experience': (context) => const ExperienceSelectPage(),
  '/signup_detail': (context) => const ExperienceDetailPage(),
  '/signup_health': (context) => const SignupHealthPage(),
  '/signup_waiting': (context) => const SignupCompletePage(),
};
