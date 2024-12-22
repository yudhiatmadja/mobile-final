import 'package:get/get.dart';

import '../controllers/homepage_u_controller.dart';

class HomepageUBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomepageUController>(
      () => HomepageUController(),
    );
  }
}
