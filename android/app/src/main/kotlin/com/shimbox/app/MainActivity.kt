package com.shimbox.app

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // ✅ Native View 등록
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory("tmap-native-view", TMapViewFactory())

        // ✅ Flutter <-> Native 채널 연결
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "tmap-native-channel")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "moveToCurrentLocation" -> {
                        // context 전달을 위해 this 사용
                        TMapController.moveToCurrentLocation(this)
                        result.success(null)
                    }

                    "enableTracking" -> {
                        TMapController.enableTracking()
                        result.success(null)
                    }

                    "drawOptimizedRoute" -> {
                        TMapController.drawOptimizedRoute()
                        result.success(null)
                    }

                    else -> result.notImplemented()
                }
            }
    }
}
