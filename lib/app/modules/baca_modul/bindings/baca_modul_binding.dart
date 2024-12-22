import 'package:get/get.dart';

import '../controllers/baca_modul_controller.dart';

class BacaModulBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BacaModulController>(
      () => BacaModulController(),
    );
  }
}
