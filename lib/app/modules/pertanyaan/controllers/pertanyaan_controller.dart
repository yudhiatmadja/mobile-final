import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PertanyaanController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var currentQuestion = 0.obs;
  var selectedAnswer = ''.obs;
  var questions = <Map<String, dynamic>>[].obs;
  var totalQuestions = 0.obs;

  Future<void> fetchQuiz(String quizId) async {
    try {
      QuerySnapshot questionsSnapshot = await _firestore
          .collection('quizzes')
          .doc(quizId)
          .collection('questions')
          .get();

      questions.value = questionsSnapshot.docs
          .map((doc) => {
                'question': doc['question'],
                'options': doc['options'],
                'correctAnswer': doc['correctAnswer'],
              })
          .toList();
      totalQuestions.value = questions.length;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch quiz: $e');
    }
  }

  void selectAnswer(String answer) {
    selectedAnswer.value = answer;
  }

  void submitAnswer() {
    if (selectedAnswer.value.isNotEmpty) {
      if (currentQuestion.value < totalQuestions.value - 1) {
        currentQuestion.value++;
        selectedAnswer.value = '';
      } else {
        Get.snackbar("Quiz", "Quiz selesai!");
        // Handle penyelesaian quiz
      }
    } else {
      Get.snackbar("Error", "Pilih jawaban terlebih dahulu.");
    }
  }
}
