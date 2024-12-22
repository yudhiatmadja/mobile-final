import 'package:get/get.dart';

import '../controllers/quizuser_controller.dart';

class QuizuserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuizuserController>(
      () => QuizuserController(),
    );
  }
}
