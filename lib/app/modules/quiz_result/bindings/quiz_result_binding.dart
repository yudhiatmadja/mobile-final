import 'package:get/get.dart';

import '../controllers/quiz_result_controller.dart';

class QuizResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuizResultController>(
      () => QuizResultController(),
    );
  }
}
