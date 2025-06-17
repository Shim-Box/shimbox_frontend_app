import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

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
    // Flutter 프레임이 모두 그려진 후 native 버튼을 표시
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showNativeButtons();
    });
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.location,
      Permission.locationWhenInUse,
      Permission.locationAlways,
    ].request();
  }

  Future<void> _showNativeButtons() async {
    try {
      final bottomPadding =
          MediaQuery.of(context).viewPadding.bottom +
          kBottomNavigationBarHeight;

      await _channel.invokeMethod('showNativeButtons', {
        'bottomPadding': bottomPadding, // ⬅️ dp로 보내기!
      });
    } catch (e) {
      print('❗ showNativeButtons 호출 실패: $e');
    }
  }

  @override
  void dispose() {
    _channel.invokeMethod('hideNativeButtons');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AndroidView(
        viewType: 'tmap-native-view',
        layoutDirection: TextDirection.ltr,
        creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }
}
