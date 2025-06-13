import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  static const MethodChannel _channel = MethodChannel('tmap-native-channel');
  static const String viewType = 'tmap-native-view';

  Future<void> _moveToCurrentLocation() async {
    await _channel.invokeMethod('moveToCurrentLocation');
  }

  Future<void> _drawOptimizedRoute() async {
    await _channel.invokeMethod('drawOptimizedRoute');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ✅ 지도는 네이티브 TMapView로 출력
          const Positioned.fill(child: AndroidView(viewType: viewType)),

          // ✅ 버튼 UI는 기존 그대로 유지
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // ✅ 내 위치 버튼 (왼쪽)
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: _moveToCurrentLocation,
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A73E9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.my_location,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ),

                // ✅ 최적 경로 버튼 (가운데)
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 188,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A73E9),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      onPressed: _drawOptimizedRoute,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/map/re.svg',
                            width: 16,
                            height: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          const Text('최적 경로 보기'),
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
