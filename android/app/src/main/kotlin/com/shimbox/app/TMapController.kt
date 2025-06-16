package com.shimbox.app

import android.content.Context
import android.util.Log
import com.google.android.gms.location.LocationServices
import com.skt.tmap.TMapData
import com.skt.tmap.TMapPoint
import com.skt.tmap.TMapView
import com.skt.tmap.overlay.TMapPolyLine

object TMapController {
    lateinit var tMapView: TMapView

    fun moveToCurrentLocation(context: Context) {
        val fusedLocationClient = LocationServices.getFusedLocationProviderClient(context)

        try {
            fusedLocationClient.lastLocation
                .addOnSuccessListener { location ->
                    if (location != null) {
                        val lat = location.latitude
                        val lon = location.longitude

                        Log.d("TMapController", "📍 정확 위치: lat=$lat, lon=$lon")
                        tMapView.setCenterPoint(lon, lat)
                    } else {
                        Log.w("TMapController", "⚠️ 위치를 가져올 수 없습니다 (null)")
                    }
                }
                .addOnFailureListener {
                    Log.e("TMapController", "❌ 위치 가져오기 실패: ${it.message}")
                }
        } catch (e: SecurityException) {
            Log.e("TMapController", "❌ 위치 권한 없음: ${e.message}")
        }
    }

    fun enableTracking() {
        try {
            tMapView.setTrackingMode(true)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    fun drawOptimizedRoute() {
        val tMapData = TMapData()

        val points = arrayListOf(
            TMapPoint(37.4979, 127.0276), // 강남
            TMapPoint(37.5111, 127.0980), // 잠실
            TMapPoint(37.5056, 127.1237)  // 송파
        )

        val start = points.first()
        val end = points.last()
        val passList = ArrayList(points.subList(1, points.size - 1))

        tMapData.findPathDataWithType(
            TMapData.TMapPathType.CAR_PATH,
            start,
            end,
            passList,
            0,
            object : TMapData.OnFindPathDataWithTypeListener {
                override fun onFindPathDataWithType(polyline: TMapPolyLine) {
                    tMapView.addTMapPolyLine(polyline)
                }
            }
        )
    }
}
