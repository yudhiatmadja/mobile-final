import 'package:get/get.dart';

import '../controllers/modul_u_controller.dart';

class ModulUBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ModulUController>(
      () => ModulUController(),
    );
  }
}
