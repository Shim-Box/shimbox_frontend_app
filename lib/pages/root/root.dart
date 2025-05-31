import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/bottom_nav_controller.dart';
import '../home/home.dart';
import '../map/route_map.dart';
import '../health/health_status.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../delivery/delivery_detail.dart';

class RootPage extends GetView<BottomNavController> {
  RootPage({super.key});

  final List<Widget> staticPages = [HomePage(), MapPage(), HealthPage()];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pageIndex = controller.pageIndex.value;
      Widget currentBody;

      // ✅ index가 3 이상이면 DeliveryDetailPage를 띄움
      if (pageIndex < staticPages.length) {
        currentBody = staticPages[pageIndex];
      } else {
        final selected = controller.selectedArea.value;
        currentBody =
            selected != null
                ? DeliveryDetailPage(area: selected)
                : Center(child: Text("잘못된 접근입니다."));
      }

      return Scaffold(
        body: currentBody,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex:
              pageIndex > 2 ? 0 : pageIndex, // ✅ DeliveryDetailPage는 탭 고정
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
