import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile/app/modules/pertanyaan/views/pertanyaan_view.dart';
import 'package:mobile/app/modules/quizuser/controllers/quizuser_controller.dart';
import 'package:mobile/firebase_options.dart';

class QuizuserView extends GetView<QuizuserController> {
  final QuizuserController controller = Get.put(QuizuserController());

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
        title: Text('Quiz'),
        backgroundColor: Colors.green,
      ),
      body: Obx(() => ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: controller.quizzes.length,
            itemBuilder: (context, index) {
              final quiz = controller.quizzes[index];
              return buildQuizCard(
                context, // Perbaiki pemanggilan context
                quiz['id'],
                quiz['title'],
                quiz['date'],
                quiz['description'],
              );
            },
          )),
    );
  }

  Widget buildQuizCard(BuildContext context, String quizId, String title, String date, String description) {
    return Card(
      color: Colors.green.shade50,
      margin: EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            Text(date, style: TextStyle(fontSize: 14.0, color: Colors.grey)),
            Text(description),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    controller.fetchQuestions(quizId);
                    // Get.to(() => QuestionView(quizId: quizId));
                    Get.to(() => PertanyaanView(), arguments: quizId); // Kirim quizId ke PertanyaanView
                  },
                  icon: Icon(Icons.list, color: Colors.blue),
                  label: Text('Mulai Quiz', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionView extends StatelessWidget {
  final String quizId;
  const QuestionView({Key? key, required this.quizId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final QuizuserController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text('Questions'),
        backgroundColor: Colors.green,
      ),
      body: Obx(() => ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: controller.questions.length,
            itemBuilder: (context, index) {
              final question = controller.questions[index];
              return buildQuestionCard(context, quizId, question);
            },
          )),
    );
  }

  Widget buildQuestionCard(BuildContext context, String quizId, Map<String, dynamic> question) {
    // final QuizuserController controller = Get.find();
    return Card(
      color: Colors.grey.shade100,
      margin: EdgeInsets.only(bottom: 10.0),
      child: ListTile(
        title: Text(question['question']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (String option in question['options']) Text(option),
          ],
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
    home: QuizuserView(),
  ));
}
