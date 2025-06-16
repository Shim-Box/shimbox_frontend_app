import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';

// 생략된 import는 그대로 유지

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const MethodChannel _channel = MethodChannel('tmap-native-channel');

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.location,
      Permission.locationWhenInUse,
      Permission.locationAlways,
    ].request();
  }

  Future<void> _moveToCurrentLocation() async {
    try {
      await _channel.invokeMethod('moveToCurrentLocation');
    } catch (e) {
      print('❗ 위치 이동 실패: $e');
    }
  }

  Future<void> _drawOptimizedRoute() async {
    try {
      await _channel.invokeMethod('drawOptimizedRoute');
    } catch (e) {
      print('❗ 경로 그리기 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ✅ Native 지도 View
          Positioned.fill(
            child: PlatformViewLink(
              viewType: 'tmap-native-view',
              surfaceFactory: (context, controller) {
                return AndroidViewSurface(
                  controller: controller as AndroidViewController,
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                    Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                    ),
                  },
                  hitTestBehavior: PlatformViewHitTestBehavior.opaque,
                );
              },
              onCreatePlatformView: (params) {
                return PlatformViewsService.initSurfaceAndroidView(
                  id: params.id,
                  viewType: 'tmap-native-view',
                  layoutDirection: TextDirection.ltr,
                  creationParamsCodec: const StandardMessageCodec(),
                )..create();
              },
            ),
          ),

          // ✅ 지도 위 오버레이 UI
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _moveToCurrentLocation,
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A73E9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _drawOptimizedRoute,
                  icon: SvgPicture.asset(
                    'assets/images/map/re.svg',
                    width: 16,
                    height: 16,
                    color: Colors.white,
                  ),
                  label: const Text('최적 경로 보기'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A73E9),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
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
