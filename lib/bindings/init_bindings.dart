import 'package:get/get.dart';
import '../controllers/bottom_nav_controller.dart';

class InitBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(BottomNavController());
  }
}
