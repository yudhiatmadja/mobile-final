import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/HomepageA/controllers/homepage_a_controller.dart';
import 'package:mobile/app/modules/Quiz/views/quiz_view.dart';
import 'package:mobile/app/modules/Modul/views/modul_view.dart';
import 'package:mobile/app/modules/audio/views/audio_view.dart';
import 'package:mobile/app/modules/dokumentasi/views/dokumentasi_view.dart';
import 'package:mobile/app/modules/foto/controllers/foto_controller.dart';
import 'package:mobile/app/modules/lokasi/views/lokasi_view.dart';
import 'package:mobile/app/modules/notifikasi/views/notifikasi_view.dart';
import 'package:mobile/app/modules/profile/views/profile_view.dart';
import 'package:mobile/app/modules/presensi/views/presensi_view.dart';
import 'package:mobile/app/modules/struktur/views/struktur_view.dart';
import 'package:mobile/app/modules/jadwal/views/jadwal_view.dart';
import 'package:mobile/app/modules/dashboard/views/dashboard_view.dart';

class HomepageAView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomepageAController controller = Get.put(HomepageAController());

    return Scaffold(
      backgroundColor: Color(0xFFEDE1D0),
      body: SafeArea(
        child: Obx(() => IndexedStack(
              index: controller.currentIndex.value,
              children: [
                // Halaman Dashboard ada di indeks 0
                DashboardPage(),
                StrukturView(),
                JadwalView(),
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
                  icon: Icon(Icons.grid_view, color: controller.currentIndex.value == 1 ? Colors.green : Colors.grey),
                  label: 'Struktur'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.access_time, color: controller.currentIndex.value == 2 ? Colors.green : Colors.grey),
                  label: 'Jadwal'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.message, color: controller.currentIndex.value == 3 ? Colors.green : Colors.grey),
                  label: 'Notifikasi'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person, color: controller.currentIndex.value == 5 ? Colors.green : Colors.grey),
                  label: 'Profile'),
            ],
          )),
    );
  }
}

// Ini adalah halaman Dashboard yang ditampilkan
class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomepageAController controller = Get.find<HomepageAController>();
    final FotoController fotoController = Get.put(FotoController());

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Get.to(ProfileView()); // Navigate to ProfileView
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
                  ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.black54),
                  SizedBox(width: 10.0),
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
            SizedBox(height: 20.0),
            GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 45.0,
              mainAxisSpacing: 45.0,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                buildMenuItem(context, 'Dashboard', Icons.report, DashboardView()), // Misalnya halaman dashboard itu sendiri
                buildMenuItem(context, 'Modul', Icons.book, ModulView()), // Navigasi ke ModulView
                buildMenuItem(context, 'Absen', Icons.checklist, PresensiView()), // Navigasi ke PresensiView
                buildMenuItem(context, 'Schedule', Icons.schedule, JadwalView()), // Navigasi ke JadwalView
                buildMenuItem(context, 'Quiz', Icons.quiz, QuizView()), // Navigasi ke QuizView
                buildMenuItem(context, 'Dokumentasi', Icons.image, DokumentasiView()), // Navigasi ke StrukturView
                buildMenuItem(context, 'Play', Icons.audio_file, AudioView()),
                buildMenuItem(context, 'Lokasi', Icons.location_city, LokasiView())
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



void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomepageAView(),
  ));
}
