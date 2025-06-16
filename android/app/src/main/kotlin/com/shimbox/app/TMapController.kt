package com.shimbox.app

import com.skt.tmap.TMapData
import com.skt.tmap.TMapPoint
import com.skt.tmap.TMapView
import com.skt.tmap.overlay.TMapPolyLine

object TMapController {
    lateinit var tMapView: TMapView

    fun moveToCurrentLocation() {
        val location = tMapView.locationPoint
        tMapView.setCenterPoint(location.longitude, location.latitude)
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

        // 예시 더미 데이터: 강남 → 잠실 → 송파
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
