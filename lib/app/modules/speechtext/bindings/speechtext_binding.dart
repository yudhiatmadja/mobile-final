import 'package:get/get.dart';

import '../controllers/speechtext_controller.dart';

class SpeechtextBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpeechtextController>(
      () => SpeechtextController(),
    );
  }
}
