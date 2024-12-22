import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/leaderboard_controller.dart';

class LeaderboardEntry {
  final String username;
  final String imageUrl;
  final int correctAnswers;
  final int totalQuestions;
  final int percentage;
  final int rank;

  LeaderboardEntry({
    required this.username,
    required this.imageUrl,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.percentage,
    required this.rank,
  });
}

class LeaderboardView extends StatelessWidget {
  final LeaderboardController leaderboardController = Get.put(LeaderboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
        backgroundColor: Colors.green,
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: leaderboardController.leaderboard.length,
          itemBuilder: (context, index) {
            final entry = leaderboardController.leaderboard[index];
            return LeaderboardItem(entry: entry);
          },
        );
      }),
    );
  }
}

class LeaderboardItem extends StatelessWidget {
  final LeaderboardEntry entry;

  const LeaderboardItem({required this.entry});

  Color getProgressColor() {
    if (entry.percentage == 100) {
      return Colors.green;
    } else if (entry.percentage >= 50) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                entry.imageUrl.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(entry.imageUrl),
                      )
                    : Icon(Icons.person),
                SizedBox(width: 10),
                Text(
                  entry.username,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Spacer(),
                Text('#${entry.rank}'),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: entry.correctAnswers / entry.totalQuestions,
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: getProgressColor(),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  '${entry.percentage}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: getProgressColor(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('${entry.correctAnswers}/${entry.totalQuestions}'),
                Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                  ),
                  child: Text('Evaluasi'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: LeaderboardView(),
  ));
}

