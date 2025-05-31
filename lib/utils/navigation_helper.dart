import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

/// 좌표 클래스
class LatLng {
  final double latitude;
  final double longitude;
  LatLng(this.latitude, this.longitude);
}

/// 주소 → 위도/경도 변환
Future<LatLng?> getLatLngFromAddress(String address) async {
  try {
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      return LatLng(locations[0].latitude, locations[0].longitude);
    }
  } catch (e) {
    print("❌ 주소 변환 실패: $e");
  }
  return null;
}

/// 현재 위치 얻기
Future<LatLng?> getCurrentLocation() async {
  final location = loc.Location();

  bool serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) return null;
  }

  var permissionGranted = await location.hasPermission();
  if (permissionGranted == loc.PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != loc.PermissionStatus.granted) return null;
  }

  final loc.LocationData locationData = await location.getLocation();
  return LatLng(locationData.latitude!, locationData.longitude!);
}

/// Spring 서버에서 주소 받아오기
Future<String?> fetchDestinationAddress() async {
  try {
    final response = await http.get(
      Uri.parse('http://<your_spring_host>/api/destination'),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      print("서버 에러: ${response.statusCode}");
    }
  } catch (e) {
    print("❌ 주소 요청 실패: $e");
  }
  return null;
}

/// 네이버 지도 앱으로 길찾기 시작
Future<void> startNaviToAddressWithNaver(String address) async {
  final destination = await getLatLngFromAddress(address);
  if (destination == null) {
    print("❌ 목적지 좌표를 가져올 수 없습니다.");
    return;
  }

  final latitude = destination.latitude;
  final longitude = destination.longitude;
  final encodedName = Uri.encodeComponent(address);

  final uri =
      'nmap://route/car?dlat=$latitude&dlng=$longitude&dname=$encodedName&appname=com.example.shimbox_app';

  print('📡 생성된 네이버 지도 URI: $uri');

  final naverUri = Uri.parse(uri);

  if (await canLaunchUrl(naverUri)) {
    await launchUrl(naverUri);
  } else {
    // 네이버 지도 앱이 설치되어 있지 않음 → 앱스토어나 마켓으로 이동
    final marketUri =
        Platform.isAndroid
            ? Uri.parse('market://details?id=com.nhn.android.nmap')
            : Uri.parse('https://apps.apple.com/app/id311867728');

    print('❌ 네이버 지도 앱이 설치되어 있지 않음 → 마켓으로 이동');
    await launchUrl(marketUri, mode: LaunchMode.externalApplication);
  }
}

/// 전체 실행 흐름: 현재 위치 → 주소 → 네이버 지도 앱 실행
Future<void> navigateToSavedAddress() async {
  final currentLocation = await getCurrentLocation();
  if (currentLocation == null) {
    print("현재 위치를 가져올 수 없습니다.");
    return;
  }

  final address = await fetchDestinationAddress();
  if (address == null) {
    print("서버로부터 주소를 가져오지 못했습니다.");
    return;
  }

  await startNaviToAddressWithNaver(address);
}
