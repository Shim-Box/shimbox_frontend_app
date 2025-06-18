import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import './map_action_header.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? mapController;
  LatLng? currentLocation;

  StreamSubscription<Position>? _positionSubscription;
  StreamSubscription<CompassEvent>? _compassSubscription;

  final List<LatLng> waypoints = [
    LatLng(37.5083, 126.8665),
    LatLng(37.5102, 126.8702),
    LatLng(37.5130, 126.8732),
  ];

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  final String kakaoApiKey = '4faee1ecf5810b0685963cbb90ed9d48';

  @override
  void initState() {
    super.initState();
    _initializeMap().then((_) => _startTracking());
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _compassSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    try {
      final loc = await _fetchCurrentLocation();
      if (!mounted) return;

      currentLocation = loc;
      _setMarkers(loc);
      await _drawRouteFrom(loc);
      mapController?.animateCamera(CameraUpdate.newLatLngZoom(loc, 17));
    } catch (e) {
      print('❌ 초기화 실패: $e');
    }
  }

  Future<LatLng> _fetchCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('위치 권한 거부됨');
      }
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    return LatLng(position.latitude, position.longitude);
  }

  void _startTracking() {
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((position) {
      final loc = LatLng(position.latitude, position.longitude);
      if (!mounted) return;

      setState(() {
        currentLocation = loc;
        _setMarkers(loc);
      });

      mapController?.animateCamera(CameraUpdate.newLatLng(loc));
    });

    _compassSubscription = FlutterCompass.events?.listen((event) {
      final heading = event.heading;
      if (heading == null || currentLocation == null || mapController == null)
        return;

      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: currentLocation!, zoom: 17, bearing: heading),
        ),
      );
    });
  }

  void _setMarkers(LatLng start) {
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId('start'),
        position: start,
        infoWindow: const InfoWindow(title: '현재 위치'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

    for (int i = 0; i < waypoints.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId('waypoint$i'),
          position: waypoints[i],
          infoWindow: InfoWindow(
            title: i == waypoints.length - 1 ? '도착지' : '경유지 ${i + 1}',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            i == waypoints.length - 1
                ? BitmapDescriptor.hueGreen
                : BitmapDescriptor.hueRed,
          ),
        ),
      );
    }
  }

  List<LatLng> _greedyRoute(LatLng start, List<LatLng> mids) {
    final List<LatLng> route = [];
    final List<bool> visited = List.filled(mids.length, false);
    LatLng current = start;

    for (int i = 0; i < mids.length; i++) {
      double minDist = double.infinity;
      int minIdx = -1;
      for (int j = 0; j < mids.length; j++) {
        if (visited[j]) continue;
        final dist = Geolocator.distanceBetween(
          current.latitude,
          current.longitude,
          mids[j].latitude,
          mids[j].longitude,
        );
        if (dist < minDist) {
          minDist = dist;
          minIdx = j;
        }
      }
      visited[minIdx] = true;
      route.add(mids[minIdx]);
      current = mids[minIdx];
    }

    return route;
  }

  Future<void> _drawRouteFrom(LatLng start) async {
    final end = waypoints.last;
    final mids = waypoints.sublist(0, waypoints.length - 1);
    final best = _greedyRoute(start, mids);

    final origin = '${start.longitude},${start.latitude}';
    final destination = '${end.longitude},${end.latitude}';
    final waypointsStr = best
        .map((e) => '${e.longitude},${e.latitude}')
        .join('|');

    final url =
        'https://apis-navi.kakaomobility.com/v1/directions?origin=$origin&destination=$destination'
        '${waypointsStr.isNotEmpty ? '&waypoints=$waypointsStr' : ''}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'KakaoAK $kakaoApiKey'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'] == null || data['routes'].isEmpty) return;

        final List sections = data['routes'][0]['sections'];
        List<LatLng> coords = [];

        for (var section in sections) {
          for (var road in section['roads']) {
            final vertexes = road['vertexes'];
            for (int i = 0; i < vertexes.length; i += 2) {
              coords.add(LatLng(vertexes[i + 1], vertexes[i]));
            }
          }
        }

        if (!mounted) return;
        setState(() {
          polylines = {
            Polyline(
              polylineId: const PolylineId('route'),
              color: Colors.deepPurple,
              width: 6,
              jointType: JointType.round,
              patterns: [PatternItem.dot, PatternItem.gap(10)],
              endCap: Cap.roundCap,
              startCap: Cap.roundCap,
              points: coords,
            ),
          };
        });
      } else {
        print('❌ 경로 요청 실패: ${response.body}');
      }
    } catch (e) {
      print('❌ 경로 요청 중 예외 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.5077, 126.8644),
              zoom: 15,
            ),
            myLocationEnabled: true,
            markers: markers,
            polylines: polylines,
            onMapCreated: (controller) {
              mapController = controller;
              if (currentLocation != null) {
                mapController!.animateCamera(
                  CameraUpdate.newLatLngZoom(currentLocation!, 17),
                );
              }
            },
          ),
          MapActionHeader(
            onCurrentLocationPressed: () async {
              final loc = await _fetchCurrentLocation();
              if (!mounted) return;
              mapController?.animateCamera(CameraUpdate.newLatLngZoom(loc, 17));
            },
            onDrawRoutePressed: () {
              if (currentLocation != null) {
                _drawRouteFrom(currentLocation!);
              }
            },
          ),
        ],
      ),
    );
  }
}
