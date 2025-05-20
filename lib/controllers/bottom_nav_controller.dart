import 'package:get/get.dart';

enum PageName { home, map, health }

class BottomNavController extends GetxController {
  RxInt pageIndex = 0.obs;

  void changeBottomNav(int value) {
    pageIndex.value = value; // ✅ 이것만 있으면 충분!
  }
}
