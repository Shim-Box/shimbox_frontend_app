import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/bottom_nav_controller.dart';
import '../home/home.dart';
import '../map/route_map.dart';
import '../health/health_status.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RootPage extends GetView<BottomNavController> {
  RootPage({super.key});

  final List<Widget> _pages = [HomePage(), MapPage(), HealthPage()];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: _pages[controller.pageIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.pageIndex.value,
          onTap: controller.changeBottomNav,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/icons/home1.svg',
                width: 24,
                height: 24,
                color: Colors.grey,
              ),
              activeIcon: SvgPicture.asset(
                'assets/images/icons/home2.svg',
                width: 24,
                height: 24,
                color: Colors.black,
              ),
              label: '하루일정',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/icons/map.svg',
                width: 24,
                height: 24,
                color: Colors.grey,
              ),
              activeIcon: SvgPicture.asset(
                'assets/images/icons/map.svg',
                width: 24,
                height: 24,
                color: Colors.black,
              ),
              label: '근처 배송지',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/icons/health.svg',
                width: 24,
                height: 24,
                color: Colors.grey,
              ),
              activeIcon: SvgPicture.asset(
                'assets/images/icons/health.svg',
                width: 24,
                height: 24,
                color: Colors.black,
              ),
              label: '건강',
            ),
          ],
        ),
      );
    });
  }
}
