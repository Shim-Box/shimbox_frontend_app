import 'dart:io'; // Platform 확인

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';

// WebView 관련
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // ✅ Android에서 줌 및 제스처 정상 작동을 위한 플랫폼 설정
    // if (Platform.isAndroid) {
    //   WebView.platform = const SurfaceAndroidWebView();
    // }

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (url) async {
                // JS 로딩 지연 보완
                await Future.delayed(Duration(milliseconds: 500));
                _goToMyLocation(zoom: 18);
              },
            ),
          )
          ..enableZoom(true) // 📌 줌 기능 명시적으로 활성화
          ..loadRequest(
            Uri.parse(
              "https://shimbox.web.app/map.html?v=${DateTime.now().millisecondsSinceEpoch}",
            ),
          );
  }

  Future<void> _goToMyLocation({int zoom = 17}) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final lat = position.latitude;
    final lng = position.longitude;

    _controller.runJavaScript('moveToLocation($lat, $lng, $zoom);');
  }

  void _searchNearby() {
    // 👇 여기에 재검색 로직 추가 가능 (지도 중심값 → 서버로 요청 등)
    print("현 위치에서 재검색 클릭됨");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 지도 WebView
          // Positioned.fill(child: WebViewWidget(controller: _controller)),
          Positioned.fill(
            child: WebViewWidget(
              controller: _controller,
              gestureRecognizers: {
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
            ),
          ),
          // 하단 버튼 영역
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 왼쪽: 현재 위치 버튼
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => _goToMyLocation(zoom: 17),
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Color(0xFF1A73E9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.my_location,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ),

                // 중앙: 재검색 버튼
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 188,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1A73E9),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      onPressed: _searchNearby,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/map/re.svg',
                            width: 16,
                            height: 16,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text('현 위치에서 재검색'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
