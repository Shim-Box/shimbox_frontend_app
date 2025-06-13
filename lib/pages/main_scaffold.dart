import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimbox_app/controllers/bottom_nav_controller.dart';
import '../pages/home/home.dart'; // 또는 import 정확한 경로
import '../pages/map/route_map.dart'; // 예시
import '../pages/health/health_status.dart'; // 예시

class MyBottomNavigationBar extends StatelessWidget {
  final bottomController = Get.find<BottomNavController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
        currentIndex: bottomController.pageIndex.value,
        onTap: bottomController.changeBottomNav,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: '지도'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '건강'),
        ],
      ),
    );
  }
}

class MainScaffold extends StatelessWidget {
  final bottomController = Get.put(BottomNavController());

  final List<Widget> pages = [HomePage(), MapPage(), HealthPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => Offstage(
              offstage: false,
              child: Navigator(
                key: bottomController.navigatorKey,
                onGenerateRoute:
                    (_) => MaterialPageRoute(
                      builder:
                          (_) => Obx(
                            () => pages[bottomController.pageIndex.value],
                          ),
                    ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: MyBottomNavigationBar(), // 분리해도 되고 직접 넣어도 됨
          ),
        ],
      ),
    );
  }
}
