import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile/app/modules/biodata/views/biodata_view.dart';
import 'package:mobile/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/leaderboard/views/leaderboard_view.dart';
import 'package:mobile/firebase_options.dart';

class DashboardView extends StatelessWidget {
  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Row(
          children: [
            SizedBox(width: 10),
            Text('Statistik'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Add functionality for the menu icon here
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFFEDE1D0), // Background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card for Users
            GestureDetector(
              onTap: () {
                Get.to(BiodataView());
              },
              child: Obx(() => buildStatisticCard(
                title: 'Users',
                count: '${controller.userCount.value}', // Display the real-time count from Firestore
                icon: Icons.people,
              )),
            ),

            SizedBox(height: 20),

            // Chart for Statistic Event
            Text(
              'Statistic Event',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // Card for Leaderboard
            GestureDetector(
              onTap: () {
                Get.to(LeaderboardView());
              },
              child: Obx(() => buildStatisticCard(
                title: 'Leaderboard',
                count: '${controller.leaderboardCount.value}',
                icon: Icons.leaderboard,
              )),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for Statistic Card
  Widget buildStatisticCard({required String title, required String count, required IconData icon}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  count,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Icon(icon, size: 40, color: Colors.black54),
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
    home: DashboardView(),
  ));
}
