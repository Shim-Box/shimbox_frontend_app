import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HealthConnectService {
  static const _scopes = [
    'https://www.googleapis.com/auth/fitness.activity.read',
    'https://www.googleapis.com/auth/fitness.location.read',
    'https://www.googleapis.com/auth/fitness.heart_rate.read',
  ];

  static Future<dynamic> requestPermissions() async {
    try {
      final googleSignIn = GoogleSignIn(scopes: _scopes);
      GoogleSignInAccount? account = googleSignIn.currentUser;

      account =
          account ??
          await googleSignIn.signInSilently() ??
          await googleSignIn.signIn();
      if (account == null) return 'cancelled';

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('health_connected', true);

      return 'granted';
    } catch (e) {
      return PlatformException(
        code: 'GOOGLE_FIT_AUTH_ERROR',
        message: e.toString(),
      );
    }
  }

  static Future<void> disconnect() async {
    final googleSignIn = GoogleSignIn(scopes: _scopes);
    await googleSignIn.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('health_connected', false);
  }

  static Future<String> getStepCount() async {
    final steps = await getStepCountBetween(
      DateTime.now().subtract(const Duration(hours: 24)),
      DateTime.now(),
    );
    return steps.toString();
  }

  static Future<int> getStepCountBetween(DateTime start, DateTime end) async {
    final account = await _ensureSignedIn();
    if (account == null) throw Exception('Google 로그인 실패');

    final authHeaders = await account.authHeaders;
    final client = GoogleAuthClient(authHeaders);

    final body = {
      "aggregateBy": [
        {"dataTypeName": "com.google.step_count.delta"},
      ],
      "bucketByTime": {"durationMillis": 86400000},
      "startTimeMillis": start.toUtc().millisecondsSinceEpoch,
      "endTimeMillis": end.toUtc().millisecondsSinceEpoch,
    };

    final response = await client.post(
      Uri.parse(
        'https://www.googleapis.com/fitness/v1/users/me/dataset:aggregate',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final bucket = json['bucket'] as List;
      int total = 0;

      for (final b in bucket) {
        final dataset = b['dataset'] as List;
        for (final d in dataset) {
          final sourceId = d['dataSourceId'] as String? ?? '';
          if (sourceId.toLowerCase().contains('healthsync')) {
            final points = d['point'] as List;
            for (final p in points) {
              final values = p['value'] as List;
              for (final v in values) {
                total += (v['intVal'] ?? 0) as int;
              }
            }
          }
        }
      }

      return total;
    } else {
      throw Exception(
        'Google Fit API error: ${response.statusCode} - ${response.body}',
      );
    }
  }

  static Future<List<int>> getPast7DaysSteps() async {
    final now = DateTime.now();
    final stepsPerDay = <int>[];

    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final start = DateTime(day.year, day.month, day.day);
      final end = start.add(const Duration(days: 1));

      try {
        final steps = await getStepCountBetween(start, end);
        stepsPerDay.add(steps);
      } catch (_) {
        stepsPerDay.add(0);
      }
    }

    return stepsPerDay;
  }

  static Future<int> getTodayHeartRateAvg() async {
    final account = await _ensureSignedIn();
    if (account == null) throw Exception('Google 로그인 실패');

    final authHeaders = await account.authHeaders;
    final client = GoogleAuthClient(authHeaders);

    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));

    final body = {
      "aggregateBy": [
        {"dataTypeName": "com.google.heart_rate.bpm"},
      ],
      "bucketByTime": {"durationMillis": 86400000},
      "startTimeMillis": start.toUtc().millisecondsSinceEpoch,
      "endTimeMillis": end.toUtc().millisecondsSinceEpoch,
    };

    final response = await client.post(
      Uri.parse(
        'https://www.googleapis.com/fitness/v1/users/me/dataset:aggregate',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print('API Response: ${response.body}'); // API 응답 로그 추가
      final bucket = json['bucket'] as List;
      double total = 0;
      int count = 0;

      for (final b in bucket) {
        final dataset = b['dataset'] as List;
        for (final d in dataset) {
          final points = d['point'] as List;
          for (final p in points) {
            final values = p['value'] as List;
            for (final v in values) {
              final rawValue = v['fpVal'];
              if (rawValue != null) {
                double heartRate =
                    (rawValue is int)
                        ? rawValue.toDouble()
                        : (rawValue as double);
                total += heartRate;
                count++;
              }
            }
          }
        }
      }

      return count > 0 ? (total / count).round() : 0;
    } else {
      throw Exception(
        'Google Fit API error: ${response.statusCode} - ${response.body}',
      );
    }
  }

  static Future<GoogleSignInAccount?> _ensureSignedIn() async {
    final googleSignIn = GoogleSignIn(scopes: _scopes);
    GoogleSignInAccount? account = googleSignIn.currentUser;

    account =
        account ??
        await googleSignIn.signInSilently() ??
        await googleSignIn.signIn();
    return account;
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}
