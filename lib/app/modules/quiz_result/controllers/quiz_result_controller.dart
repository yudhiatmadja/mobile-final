import 'package:get/get.dart';

class QuizResultController extends GetxController {
  // Mock data for user's profile
  final userName = 'David';
  final profileImageUrl = 'https://via.placeholder.com/150';

  // Accuracy score (e.g., 70% correct answers)
  var accuracy = 0.7.obs; // This would be 70%

  // List of result strings
  List<String> results = [
    "Question 1: Correct",
    "Question 2: Incorrect",
    "Question 3: Correct",
    "Question 4: Correct",
    "Question 5: Incorrect",
  ];

  void playAgain() {
    // Logic for replaying the quiz, such as resetting variables or navigating back to the quiz screen
    Get.snackbar("Action", "Play again tapped!");
  }

  void quit() {
    // Logic for quitting the quiz, such as navigating back to the main menu
    Get.snackbar("Action", "Quit tapped!");
  }
}
