import 'package:get/get.dart';

import '../controllers/notif_registrasi_controller.dart';

class NotifRegistrasiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotifRegistrasiController>(
      () => NotifRegistrasiController(),
    );
  }
}
