import 'package:get/get.dart';
import 'package:mobile/app/routes/app_pages.dart';

class NotifRegistrasiController extends GetxController {
  //TODO: Implement NotifRegistrasiController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 5), () {  // Delay untuk menampilkan splash screen selama 5 detik
      Get.offAllNamed(Routes.LOGIN);
    });
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
