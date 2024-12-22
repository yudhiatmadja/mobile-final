import 'package:get/get.dart';

import '../controllers/detail_struktur_controller.dart';

class DetailStrukturBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailStrukturController>(
      () => DetailStrukturController(),
    );
  }
}
