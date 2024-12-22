import 'package:get/get.dart';
import 'package:mobile/app/modules/login/controllers/login_controller.dart';
import 'package:mobile/app/routes/app_pages.dart';

class SplashController extends GetxController {
  final loginController = Get.put(LoginController());  // Memastikan menggunakan instance yang sudah ada

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 3), () {  // Delay untuk menampilkan splash screen selama 5 detik
        Get.offAllNamed(Routes.LOGIN);
    });
  }
}

