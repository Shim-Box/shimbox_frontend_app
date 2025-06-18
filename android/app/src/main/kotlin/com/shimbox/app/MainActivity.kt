package com.shimbox.app

import android.content.res.ColorStateList
import android.graphics.Color
import android.os.Bundle
import android.view.Gravity
import android.widget.Button
import android.widget.FrameLayout
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory("tmap-native-view", TMapViewFactory())

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "tmap-native-channel")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "moveToCurrentLocation" -> {
                        TMapController.moveToCurrentLocation(this)
                        result.success(null)
                    }

                    "drawOptimizedRoute" -> {
                        TMapController.drawOptimizedRoute()
                        result.success(null)
                    }

                    "showNativeButtons" -> {
                        val padding = call.argument<Double>("bottomPadding") ?: 0.0
                        showNativeButtons(padding.toFloat())
                        result.success(null)
                    }

                    "hideNativeButtons" -> {
                        hideNativeButtons()
                        result.success(null)
                    }

                    else -> result.notImplemented()
                }
            }
    }

    private fun showNativeButtons(bottomPadding: Float) {
        val root = findViewById<FrameLayout>(android.R.id.content)

        // 🔽 Flutter 내부 FrameLayout 찾기
        val flutterViewGroup = root.getChildAt(0) as? FrameLayout ?: return

        if (flutterViewGroup.findViewWithTag<Button>("nativeBtnMyLocation") != null) return

        val btnMyLocation = Button(this).apply {
            tag = "nativeBtnMyLocation"
            backgroundTintList = ColorStateList.valueOf(Color.parseColor("#1A73E9"))
            foregroundTintList = ColorStateList.valueOf(Color.WHITE)
            setCompoundDrawablesWithIntrinsicBounds(
                ContextCompat.getDrawable(context, R.drawable.ic_re), null, null, null
            )
            text = ""
            width = dpToPx(45)
            height = dpToPx(45)
            setOnClickListener {
                TMapController.moveToCurrentLocation(this@MainActivity)
            }
        }

        val btnRoute = Button(this).apply {
            tag = "nativeBtnRoute"
            backgroundTintList = ColorStateList.valueOf(Color.parseColor("#1A73E9"))
            foregroundTintList = ColorStateList.valueOf(Color.WHITE)
            text = "최적 경로 보기"
            setCompoundDrawablesWithIntrinsicBounds(
                ContextCompat.getDrawable(context, R.drawable.ic_re), null, null, null
            )
            compoundDrawablePadding = dpToPx(8)
            setOnClickListener {
                TMapController.drawOptimizedRoute()
            }
        }

        var bottomMargin = dpToPx((20 + bottomPadding).toInt())



        val lpMyLoc = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.WRAP_CONTENT,
            FrameLayout.LayoutParams.WRAP_CONTENT
        ).apply {
            gravity = Gravity.BOTTOM or Gravity.START
            marginStart = dpToPx(16)
            bottomMargin = bottomMargin
        }

        val lpRoute = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.WRAP_CONTENT,
            FrameLayout.LayoutParams.WRAP_CONTENT
        ).apply {
            gravity = Gravity.BOTTOM or Gravity.END
            marginEnd = dpToPx(16)
            bottomMargin = bottomMargin
        }

        flutterViewGroup.addView(btnMyLocation, lpMyLoc)
        flutterViewGroup.addView(btnRoute, lpRoute)
    }



    private fun hideNativeButtons() {
        val root = findViewById<FrameLayout>(android.R.id.content)
        val flutterViewGroup = root.getChildAt(0) as? FrameLayout ?: return

        flutterViewGroup.findViewWithTag<Button>("nativeBtnMyLocation")?.let {
            flutterViewGroup.removeView(it)
        }
        flutterViewGroup.findViewWithTag<Button>("nativeBtnRoute")?.let {
            flutterViewGroup.removeView(it)
        }
    }


    private fun dpToPx(dp: Int): Int {
        val density = resources.displayMetrics.density
        return (dp * density).toInt()
    }
}
