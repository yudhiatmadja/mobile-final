import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/HomepageU/views/webview.dart';
import 'package:mobile/app/modules/attendance/views/attendance_view.dart';
import 'package:mobile/app/modules/audio/views/audio_view.dart';
import 'package:mobile/app/modules/foto/controllers/foto_controller.dart';
import 'package:mobile/app/modules/jabatan/views/jabatan_view.dart';
import 'package:mobile/app/modules/jadwal_u/views/jadwal_u_view.dart';
import 'package:mobile/app/modules/leaderboard/views/leaderboard_view.dart';
import 'package:mobile/app/modules/lokasi/views/lokasi_view.dart';
import 'package:mobile/app/modules/modul_u/views/modul_u_view.dart';
import 'package:mobile/app/modules/notifikasi/views/notifikasi_view.dart';
import 'package:mobile/app/modules/profile/views/profile_view.dart';
import 'package:mobile/app/modules/quizuser/views/quizuser_view.dart';
import 'package:mobile/app/modules/schedule/views/schedule_view.dart';
import 'package:mobile/app/modules/speechtext/views/speechtext_view.dart';
import '../controllers/homepage_u_controller.dart';

final HomepageUController controller = Get.put(HomepageUController());

class HomepageUView extends StatefulWidget {
  @override
  _HomepageUViewState createState() => _HomepageUViewState();
}

class _HomepageUViewState extends State<HomepageUView> {
  late FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;

    messaging.getToken().then((value) {
      print("Token Firebase: $value");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showSnackbar(message.notification!.title, message.notification!.body);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Pesan dari background: ${message.notification?.title}");
    });
  }

  void _showSnackbar(String? title, String? body) {
    final snackBar = SnackBar(
      content: Text("$title: $body"),
      duration: Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    // final HomepageUController controller = Get.put(HomepageUController());

    return Scaffold(
      backgroundColor: Color(0xFFEDE1D0),
      body: SafeArea(
        child: Obx(() => IndexedStack(
              index: controller.currentIndex.value,
              children: [
                DashboardPage(),
                JabatanView(),
                JadwalUView(),
                NotifikasiView(),
                ProfileView(),
              ],
            )),
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: controller.currentIndex.value,
            onTap: controller.changePage, // Memanggil fungsi changePage di controller
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home, color: controller.currentIndex.value == 0 ? Colors.green : Colors.grey),
                  label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.card_membership, color: controller.currentIndex.value == 1 ? Colors.green : Colors.grey),
                  label: 'Struktur'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_view_day, color: controller.currentIndex.value == 2 ? Colors.green : Colors.grey),
                  label: 'Jadwal'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications, color: controller.currentIndex.value == 3 ? Colors.green : Colors.grey),
                  label: 'Notifikasi'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person, color: controller.currentIndex.value == 4 ? Colors.green : Colors.grey),
                  label: 'Profile'),
            ],
          )),
    );
  }
}

// Ini adalah halaman Dashboard yang ditampilkan
class DashboardPage extends StatelessWidget {
  final FotoController fotoController = Get.put(FotoController());
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                // Navigasi ke halaman profil saat avatar atau nama diklik
                Get.to(ProfileView()); // Arahkan ke halaman profil
              },
              child: Row(
                children: [
                  Obx(
                    () => CircleAvatar(
                      radius: 25.0,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: fotoController.selectedImagePath.value.isNotEmpty
                      ? (fotoController.selectedImagePath.value.startsWith('http')
                      ? NetworkImage(fotoController.selectedImagePath.value) as ImageProvider<Object>
                      : FileImage(File(fotoController.selectedImagePath.value)) as ImageProvider<Object>)
                      : null,

                      child: fotoController.selectedImagePath.value.isEmpty
                      ? Icon(
                        Icons.person,
                        size: 20.0,
                        color: Colors.grey,
                      )
                      : null,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Obx(() => Text(
                    controller.name.value, // Display the username
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.black54),
                  SizedBox(width: 5.0),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(Icons.mic, color: Colors.black54),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              height: 90.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(image: AssetImage('assets/bg.png'),
                fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Looking For",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "More",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey.shade600,
                    ),
                  ),
                ],
            ),
            SizedBox(height: 20.0),
            GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 45.0,
              mainAxisSpacing: 45.0,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                buildMenuItem(context, 'Modul', Icons.book, ModulUView()), // Navigasi ke ModulView
                buildMenuItem(context, 'Absen', Icons.checklist, AttendanceView()), // Navigasi ke PresensiView
                buildMenuItem(context, 'Schedule', Icons.schedule, JadwalUView()), // Navigasi ke JadwalView
                buildMenuItem(context, 'Leaderboard', Icons.leaderboard, LeaderboardView()),
                buildMenuItem(context, 'Rekaman', Icons.mic, SpeechtextView()),
                buildMenuItem(context, 'Play', Icons.audio_file, AudioView()),
                buildMenuItem(context, 'Location', Icons.location_city, LokasiView()),
                buildMenuItem(context, 'About', Icons.info, SejarahView()),
                buildMenuItem(context, 'Quiz', Icons.quiz, QuizuserView())


              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(BuildContext context, String title, IconData icon, Widget targetPage) {
  return GestureDetector(
    onTap: () {
      // Navigasi ke halaman target saat menu diklik
      Get.to(targetPage);
    },
    child: Container(
      decoration: BoxDecoration(
        color: Color(0xFF009D44), // Warna hijau
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 20.0),
          SizedBox(height: 10.0),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    ),
  );
}
}

void main(){
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomepageUView(),
    initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => ScheduleView()),
      ],
  ));
}
