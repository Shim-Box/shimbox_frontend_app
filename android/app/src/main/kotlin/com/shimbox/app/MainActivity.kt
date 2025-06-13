package com.shimbox.app

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "tmap-native-channel"
//    private lateinit var tmapView: TMapNativeView

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // PlatformView 등록 (이미 했으면 생략 가능)
        flutterEngine
            .platformViewsController
            .registry
//            .registerViewFactory("tmap-native-view", TMapNativeViewFactory())

        // MethodChannel 연결
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            when (call.method) {
                "moveToCurrentLocation" -> {
                    // 현재 위치 이동 (임시 좌표 예시)
//                    tmapView.moveToLocation(37.5665, 126.978) // 실시간 위치는 나중에
                    result.success(null)
                }
                "drawOptimizedRoute" -> {
                    // 경로 그리기 (임시 테스트)
//                    tmapView.drawDummyRoute()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // TMapNativeView 인스턴스 만들어서 저장
//        tmapView = TMapNativeView(this)
    }
}
