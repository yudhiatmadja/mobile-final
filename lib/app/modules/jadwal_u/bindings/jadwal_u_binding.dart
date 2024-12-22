import 'package:get/get.dart';

import '../controllers/jadwal_u_controller.dart';

class JadwalUBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JadwalUController>(
      () => JadwalUController(),
    );
  }
}
