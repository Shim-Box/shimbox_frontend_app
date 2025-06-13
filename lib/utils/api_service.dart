import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/signup_data.dart';
import '../models/login_data.dart';
import '../models/test_user_data.dart';

class ApiService {
  // ✅ 외부에서 쓸 수 있는 POST 메서드 (내부 _post 호출)
  static Future<bool> post(String endpoint, Map<String, dynamic> body) {
    return _post(endpoint, body);
  }

  // 사용자 회원가입
  static Future<bool> registerUser(SignupData data) {
    return _post('/api/v1/auth/save', data.toJson());
  }

  // 로그인
  static Future<Map<String, dynamic>?> loginUser(LoginData data) async {
    final url = Uri.parse('http://116.39.208.72:26443/api/v1/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(
        utf8.decode(response.bodyBytes),
      ); // ✅ UTF-8 decode
      // final decoded = jsonDecode(response.body);
      print('✅ 로그인 응답: $decoded');
      return decoded;
    } else {
      print('❌ 로그인 실패: ${response.statusCode}, ${response.body}');
      return null;
    }
  }

  // ✅ 운전면허 이미지 업로드
  static Future<String?> uploadLicenseImage(File file) async {
    final url = Uri.parse(
      'http://116.39.208.72:26443/api/v1/upload/license',
    ); // 서버가 받아주는 업로드 API

    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        final result = jsonDecode(body);
        print('✅ 이미지 업로드 성공: ${result['url']}');
        return result['url']; // 서버가 업로드된 파일 URL을 반환한다고 가정
      } else {
        print('❌ 이미지 업로드 실패: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('🔥 이미지 업로드 에러: $e');
      return null;
    }
  }

  // 공통 POST 요청 처리
  static Future<bool> _post(String endpoint, Map<String, dynamic> body) async {
    final baseUrl = 'http://116.39.208.72:26443';
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('✅ 요청 성공: $endpoint');
        return true;
      } else {
        print('❌ 실패 [$endpoint]: ${response.statusCode}, ${response.body}');
        return false;
      }
    } catch (e) {
      print('🔥 예외 발생 [$endpoint]: $e');
      return false;
    }
  }

  // ✅ 배송 사진 파일 전송 (서버가 문자 전송 포함)
  static Future<bool> sendDeliveryImageFile({
    required String phone,
    required File imageFile,
  }) async {
    final url = Uri.parse(
      'http://116.39.208.72:26443/api/v1/driver/delivery/image',
    );

    final request =
        http.MultipartRequest('POST', url)
          ..fields['phone'] = phone
          ..files.add(
            await http.MultipartFile.fromPath('file', imageFile.path),
          );

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        print('✅ 배송 이미지 전송 성공');
        return true;
      } else {
        print('❌ 배송 이미지 전송 실패: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('🔥 배송 이미지 전송 예외: $e');
      return false;
    }
  }

  // 근태 상태 변경 API 호출
  static Future<bool> updateAttendanceStatus(String status) async {
    final url = Uri.parse(
      'http://116.39.208.72:26443/api/v1/driver/attendance',
    );

    print('📤 근태 상태 요청: $status');
    print('📤 토큰: ${UserData.token}');

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserData.token}',
        },
        body: jsonEncode({'status': status}),
      );

      print('📥 응답 코드: ${response.statusCode}');
      print('📥 응답 바디: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ 근태 상태 업데이트 성공');
        return true;
      } else {
        print('❌ 근태 상태 업데이트 실패: ${response.statusCode}, ${response.body}');
        return false;
      }
    } catch (e) {
      print('🔥 근태 상태 업데이트 예외 발생: $e');
      return false;
    }
  }
}
