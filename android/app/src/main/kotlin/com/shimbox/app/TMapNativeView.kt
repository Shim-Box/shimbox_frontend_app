package com.shimbox.app

import android.content.Context
import android.util.Log
import android.view.MotionEvent
import android.view.SurfaceView
import android.view.View
import android.view.ViewGroup
import android.view.ViewTreeObserver
import com.skt.tmap.TMapPoint
import com.skt.tmap.TMapView
import io.flutter.plugin.platform.PlatformView

class TMapNativeView(context: Context) : PlatformView {

    private val tMapView: TMapView

    init {
        tMapView = TMapView(context).apply {
            setSKTMapApiKey("DJO4si6El028Ny2KjF9bC4kNCtroX0TL22vzVsjf")
            setZoomLevel(15)
            setMapType(TMapView.MapType.DEFAULT)

            // 지도 준비 완료 후 설정
            setOnMapReadyListener {
                setTrackingMode(true)
                setCompassMode(true)

                // 현재 위치 중심으로 이동
                val location: TMapPoint = locationPoint
                Log.d("TMapDebug", "현재 위치 lat=${location.latitude}, lon=${location.longitude}")

                // 위도, 경도 순서 맞게!
                setCenterPoint(location.longitude, location.latitude)

                // 줌 가능하도록 설정
                try {
                    this.javaClass.getMethod("setZoomEnable", Boolean::class.java)
                        .invoke(this, true)
                    Log.d("TMapDebug", "Zoom enabled")
                } catch (e: Exception) {
                    Log.w("TMapDebug", "Zoom enable method not found in SDK")
                }
            }

            // SurfaceView 가려지지 않게 미디어 오버레이 설정
            viewTreeObserver.addOnGlobalLayoutListener(object : ViewTreeObserver.OnGlobalLayoutListener {
                override fun onGlobalLayout() {
                    forceSurfaceViewMediaOverlay(this@apply)
                    viewTreeObserver.removeOnGlobalLayoutListener(this)
                }
            })

            // 제스처 로그 확인용
            setOnTouchListener { _, event ->
                when (event.action) {
                    MotionEvent.ACTION_DOWN -> Log.d("TMapGesture", "사용자 터치 시작")
                    MotionEvent.ACTION_MOVE -> Log.d("TMapGesture", "사용자 손가락 이동")
                    MotionEvent.ACTION_UP -> Log.d("TMapGesture", "사용자 손 떼기")
                }
                false
            }

            post {
                forceSurfaceViewMediaOverlay(this)
            }
        }

        // 외부에서 접근 가능하게 컨트롤러에 저장
        TMapController.tMapView = tMapView
    }

    override fun getView(): View = tMapView
    override fun dispose() {}

    // SurfaceView 재귀적으로 찾아 overlay 설정
    private fun forceSurfaceViewMediaOverlay(view: View) {
        if (view is SurfaceView) {
            view.setZOrderOnTop(false)
            view.setZOrderMediaOverlay(true)
            Log.d("TMapDebug", "✅ SurfaceView overlay 설정 완료")
        } else if (view is ViewGroup) {
            for (i in 0 until view.childCount) {
                forceSurfaceViewMediaOverlay(view.getChildAt(i))
            }
        }
    }
}
