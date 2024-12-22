import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/quiz_result_controller.dart';

class QuizResultView extends GetView<QuizResultController> {
  final QuizResultController controller = Get.put(QuizResultController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        color: Color(0xFFEDE1D0), // Background color
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Section
            Container(
              color: Color(0xFFE8F5E9),
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(controller.profileImageUrl),
                    radius: 30,
                  ),
                  SizedBox(width: 10),
                  Text(
                    controller.userName,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Accuracy Quiz Section
            Container(
              color: Color(0xFFE8F5E9),
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Accuracy Quiz',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => LinearProgressIndicator(
                            value: controller.accuracy.value,
                            backgroundColor: Colors.grey[300],
                            color: Colors.green,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Obx(
                        () => Text(
                          '${(controller.accuracy.value * 100).toInt()}%',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Benar', style: TextStyle(fontSize: 16)),
                      Text('Salah', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[100],
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  onPressed: controller.playAgain,
                  child: Text(
                    'Play Again',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[100],
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  onPressed: controller.quit,
                  child: Text(
                    'Quit',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Result Section
            Text(
              'Result',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: controller.results.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: Color(0xFFE8F5E9),
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      controller.results[index],
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuizResultView(),
    ),
  );
}