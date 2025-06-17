package com.shimbox.app

import android.content.Context
import android.util.Log
import android.view.MotionEvent
import android.view.SurfaceView
import android.view.View
import android.view.ViewGroup
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

            setOnMapReadyListener {
                setTrackingMode(false) // 🔴 반드시 false로 설정해야 드래그 가능!
                setCompassMode(true)

                val location: TMapPoint = locationPoint
                Log.d("TMapDebug", "현재 위치 lat=${location.latitude}, lon=${location.longitude}")
                setCenterPoint(location.longitude, location.latitude)

                try {
                    this.javaClass.getMethod("setZoomEnable", Boolean::class.java)
                        .invoke(this, true)
                    Log.d("TMapDebug", "Zoom enabled")
                } catch (e: Exception) {
                    Log.w("TMapDebug", "Zoom enable method not found in SDK")
                }
            }

            // 🔽 overlay 설정
            post {
                Log.d("TMapDebug", "📌 post 블록 진입 - overlay 설정 시도 시작")
                forceSurfaceViewMediaOverlay(this@apply)
            }

            // 🔽 터치 로그용
            setOnTouchListener { _, event ->
                when (event.action) {
                    MotionEvent.ACTION_DOWN -> Log.d("TMapGesture", "사용자 터치 시작")
                    MotionEvent.ACTION_MOVE -> Log.d("TMapGesture", "사용자 손가락 이동")
                    MotionEvent.ACTION_UP -> Log.d("TMapGesture", "사용자 손 떼기")
                }
                false
            }
        }

        TMapController.tMapView = tMapView

    }

    override fun getView(): View = tMapView
    override fun dispose() {}

    // ✅ SurfaceView 재귀 탐색해서 overlay 설정
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
