import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimbox_app/pages/delivery/delivery_detail.dart';

enum PageName { home, map, health }

class BottomNavController extends GetxController {
  var pageIndex = 0.obs;
  var selectedArea = Rxn<Map<String, dynamic>>();

  var isCheckedIn = false.obs;
  var checkInTime = ''.obs;

  var isCheckedOut = false.obs;
  var checkOutTime = ''.obs;

  // ✅ 내부 Navigator 관리용 key 추가
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void changeBottomNav(int value) {
    pageIndex.value = value;
    selectedArea.value = null;
  }

  // ✅ 이제 tab 전환 대신 push
  void goToDeliveryDetail(Map<String, dynamic> area) {
    selectedArea.value = area;
    pageIndex.value = 3; // 상세 페이지 인덱스
  }
}
