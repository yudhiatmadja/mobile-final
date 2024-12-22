import 'package:get/get.dart';

import '../controllers/jabatan_controller.dart';

class JabatanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JabatanController>(
      () => JabatanController(),
    );
  }
}
