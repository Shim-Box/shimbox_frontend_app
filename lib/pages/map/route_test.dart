import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;

class RouteTestPage extends StatefulWidget {
  const RouteTestPage({Key? key}) : super(key: key);

  @override
  State<RouteTestPage> createState() => _RouteTestPageState();
}

class _RouteTestPageState extends State<RouteTestPage> {
  GoogleMapController? mapController;

  // 동양미래대학교 (시작 위치)
  final LatLng startLocation = LatLng(37.5077, 126.8644);

  // 경유지(더미) 3개
  final List<LatLng> waypoints = [
    LatLng(37.5083, 126.8665), // 경유1
    LatLng(37.5102, 126.8702), // 경유2
    LatLng(37.5130, 126.8732), // 경유3 (도착)
  ];

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  final String googleApiKey = 'AIzaSyDcaQDrzTPJQ1bT2feHqyyo-LA_ijEXHCs';

  @override
  void initState() {
    super.initState();
    _setMarkers();
    _drawRoute();
  }

  void _setMarkers() {
    markers.add(
      Marker(
        markerId: MarkerId('start'),
        position: startLocation,
        infoWindow: InfoWindow(title: '출발지(동양미래대)'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
    for (int i = 0; i < waypoints.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId('waypoint$i'),
          position: waypoints[i],
          infoWindow: InfoWindow(title: '상품 ${i + 1}'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
  }

  Future<void> _drawRoute() async {
    String waypointsString = waypoints
        .sublist(0, waypoints.length - 1)
        .map((e) => "${e.latitude},${e.longitude}")
        .join('|');

    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startLocation.latitude},${startLocation.longitude}'
        '&destination=${waypoints.last.latitude},${waypoints.last.longitude}'
        '&waypoints=$waypointsString'
        '&key=$googleApiKey';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      String encodedPolyline = data['routes'][0]['overview_polyline']['points'];
      List<PointLatLng> points = PolylinePoints().decodePolyline(
        encodedPolyline,
      );
      List<LatLng> polylineCoords =
          points.map((e) => LatLng(e.latitude, e.longitude)).toList();

      setState(() {
        polylines.add(
          Polyline(
            polylineId: PolylineId('route'),
            color: Colors.blue,
            width: 5,
            points: polylineCoords,
          ),
        );
      });
    } else {
      print('경로 불러오기 실패: ${data['status']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('경유지 경로 테스트')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: startLocation, zoom: 15),
        markers: markers,
        polylines: polylines,
        onMapCreated: (controller) => mapController = controller,
        myLocationEnabled: true,
      ),
    );
  }
}
