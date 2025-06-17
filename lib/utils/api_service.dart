import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/signup_data.dart';
import '../models/login_data.dart';
import '../models/login_response.dart'; // ✅ LoginResponse 사용 가능하게 함
import '../models/test_user_data.dart' as localUser; // ✅ 이름 충돌 방지용

class ApiService {
  static const String baseUrl = 'http://116.39.208.72:26443';

  static Future<bool> post(String endpoint, Map<String, dynamic> body) {
    return _post(endpoint, body);
  }

  static Future<bool> registerUser(SignupData data) {
    return _post('/api/v1/auth/save', data.toJson());
  }

  static Future<LoginResponse?> loginUser(LoginData data) async {
    final url = Uri.parse('$baseUrl/api/v1/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      print('✅ 로그인 응답: $decoded');

      final loginResponse = LoginResponse.fromJson(decoded);

      // ✅ 로그인 성공 시 토큰 SharedPreferences에 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', loginResponse.data.accessToken ?? '');

      // ✅ 메모리에도 할당
      localUser.UserData.token = loginResponse.data.accessToken;

      return loginResponse;
    } else {
      print('❌ 로그인 실패: ${response.statusCode}, ${response.body}');
      return null;
    }
  }

  static Future<String?> uploadLicenseImage(File file) async {
    final url = Uri.parse('$baseUrl/api/v1/upload/license');
    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        final result = jsonDecode(body);
        print('✅ 이미지 업로드 성공: ${result['url']}');
        return result['url'];
      } else {
        print('❌ 이미지 업로드 실패: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('🔥 이미지 업로드 에러: $e');
      return null;
    }
  }

  static Future<bool> _post(String endpoint, Map<String, dynamic> body) async {
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

  // 이미지 전송
  static Future<bool> sendDeliveryImage({
    required int productId,
    required String imageUrl,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/driver/delivery/image');

    print('📤 이미지 전송 요청: productId=$productId, imageUrl=$imageUrl');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${localUser.UserData.token}',
        },
        body: jsonEncode({'productId': productId, 'imageUrl': imageUrl}),
      );

      print('📥 서버 응답: ${response.statusCode}, ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('❌ 이미지 전송 실패: $e');
      return false;
    }
  }

  static Future<bool> updateAttendanceStatus(String status) async {
    final url = Uri.parse('$baseUrl/api/v1/driver/attendance');

    print('📤 근태 상태 요청: $status');
    print('📤 토큰: ${localUser.UserData.token}'); // ✅ 충돌 방지 alias 사용

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${localUser.UserData.token}',
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

  // 설문조사
  static Future<bool> submitHealthSurvey({
    required String finish1,
    required String finish2,
    required String finish3,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/driver/health/survey');
    print('📤 설문 제출 시작');
    print('📤 토큰: ${localUser.UserData.token}');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${localUser.UserData.token}',
        },
        body: jsonEncode({
          'finish1': finish1,
          'finish2': finish2,
          'finish3': finish3,
        }),
      );

      print('📥 응답 코드: ${response.statusCode}');
      print('📥 응답 바디: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ 설문 제출 성공');
        return true;
      } else {
        print('❌ 설문 제출 실패');
        return false;
      }
    } catch (e) {
      print('🔥 설문 제출 중 에러 발생: $e');
      return false;
    }
  }

  // 배송 요약 조회
  static Future<List<dynamic>> fetchDeliverySummary() async {
    final response = await get('/api/v1/driver/summary');
    if (response['statusCode'] == 200) {
      return response['data'];
    } else {
      throw Exception(response['message'] ?? '배송 정보를 불러올 수 없습니다.');
    }
  }

  // 배송 상태 업데이트
  static Future<bool> updateProductStatus(int productId, String status) async {
    final body = {"productId": productId, "status": status};
    final response = await patch('/api/v1/driver/product/status', body);

    // ✅ 스웨거 응답은 statusCode == 0이지만 성공임
    final isSuccess =
        response['statusCode'] == 0 || response['statusCode'] == 200;
    if (!isSuccess) {
      print('❌ 배송 상태 변경 실패: ${response['statusCode']}, ${response['message']}');
    }
    return isSuccess;
  }

  // 건강 더미 데이터 - 이게 있어야 퇴근후 설문이 됨
  static Future<bool> createDummyHealthRecord() async {
    final url = Uri.parse('$baseUrl/api/v1/driver/realtime');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${localUser.UserData.token}',
        },
        body: jsonEncode({
          'step': 1000,
          'heartRate': 75,
          'conditionStatus': '좋음',
        }),
      );

      if (response.statusCode == 200) {
        print('✅ 건강 데이터 생성 성공');
        return true;
      } else {
        print('❌ 건강 데이터 생성 실패: ${response.statusCode}, ${response.body}');
        return false;
      }
    } catch (e) {
      print('🔥 건강 데이터 예외 발생: $e');
      return false;
    }
  }

  // ✅ 인증 포함 GET 요청
  static Future<Map<String, dynamic>> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${localUser.UserData.token}',
        },
      );

      return jsonDecode(utf8.decode(response.bodyBytes));
    } catch (e) {
      print('🔥 GET 요청 실패 [$endpoint]: $e');
      rethrow;
    }
  }

  // ✅ 인증 포함 PATCH 요청
  static Future<Map<String, dynamic>> patch(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${localUser.UserData.token}',
        },
        body: jsonEncode(body),
      );

      return jsonDecode(utf8.decode(response.bodyBytes));
    } catch (e) {
      print('🔥 PATCH 요청 실패 [$endpoint]: $e');
      rethrow;
    }
  }
}
