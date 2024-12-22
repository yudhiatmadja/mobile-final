import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile/firebase_options.dart';
import '../controllers/pertanyaan_controller.dart';

class PertanyaanView extends GetView<PertanyaanController> {
  PertanyaanView({Key? key}) : super(key: key) {
    String quizId = Get.arguments as String; // Ambil quizId dari arguments
    controller.fetchQuiz(quizId); // Muat data quiz berdasarkan quizId
  }

  final PertanyaanController controller = Get.put(PertanyaanController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.top,
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            'Pertanyaan ${controller.currentQuestion.value + 1}/${controller.totalQuestions.value}',
            style: TextStyle(fontSize: 18),
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: Container(
        color: Color(0xFFEDE1D0), // Warna latar belakang
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Obx(() {
                if (controller.questions.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        controller.questions[controller.currentQuestion.value]['question'],
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Column(
                        children: controller.questions[controller.currentQuestion.value]['options']
                            .map<Widget>((option) => AnswerButton(
                                  label: option,
                                  color: Colors.green.shade50,
                                  onPressed: () => controller.selectAnswer(option),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(double.infinity, 48),
                ),
                onPressed: () {
                  controller.submitAnswer();
                },
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class AnswerButton extends StatelessWidget {
  final String label;
  final Color? color;
  final VoidCallback onPressed;

  const AnswerButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: Size(double.infinity, 48),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }
}

void main() async {   
  WidgetsFlutterBinding.ensureInitialized();   
  await Firebase.initializeApp(     
    options: DefaultFirebaseOptions.currentPlatform,   
    );   
    await GetStorage.init();   
    runApp(GetMaterialApp(     
      debugShowCheckedModeBanner: false,     
      home: PertanyaanView(),   
  )); 
} 