import 'package:get/get.dart';

enum PageName { home, map, health }

class BottomNavController extends GetxController {
  RxInt pageIndex = 0.obs;
  Rx<Map<String, dynamic>?> selectedArea = Rxn();

  var isCheckedIn = false.obs;
  var checkInTime = ''.obs;

  var isCheckedOut = false.obs;
  var checkOutTime = ''.obs;

  void changeBottomNav(int value) {
    pageIndex.value = value;
  }

  void goToDeliveryDetail(Map<String, dynamic> area) {
    selectedArea.value = area;
    pageIndex.value = 3;
  }

  void markCheckedIn(String time) {
    isCheckedIn.value = true;
    checkInTime.value = time;
  }
}
