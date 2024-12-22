import 'package:get/get.dart';
import 'package:mobile/app/modules/leaderboard/views/leaderboard_view.dart';

class LeaderboardController extends GetxController {
  //TODO: Implement LeaderboardController

  final count = 0.obs;

  var leaderboard = <LeaderboardEntry>[
    LeaderboardEntry(
      username: "David",
      imageUrl: "https://example.com/avatar1.png",
      correctAnswers: 10,
      totalQuestions: 10,
      percentage: 100,
      rank: 1,
    ),
    LeaderboardEntry(
      username: "Username2",
      imageUrl: "",
      correctAnswers: 7,
      totalQuestions: 10,
      percentage: 70,
      rank: 2,
    ),
    LeaderboardEntry(
      username: "Username3",
      imageUrl: "",
      correctAnswers: 5,
      totalQuestions: 10,
      percentage: 50,
      rank: 3,
    ),
    LeaderboardEntry(
      username: "Username4",
      imageUrl: "",
      correctAnswers: 4,
      totalQuestions: 10,
      percentage: 40,
      rank: 4,
    ),
    LeaderboardEntry(
      username: "Username5",
      imageUrl: "",
      correctAnswers: 3,
      totalQuestions: 10,
      percentage: 30,
      rank: 5,
    ),
  ].obs;



  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
