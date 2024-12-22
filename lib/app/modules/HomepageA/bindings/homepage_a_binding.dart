import 'package:get/get.dart';

import '../controllers/homepage_a_controller.dart';

class HomepageABinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomepageAController>(
      () => HomepageAController(),
    );
  }
}
