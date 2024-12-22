import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mobile/app/modules/home/controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(221, 165, 35, 0.4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar dan nama pengguna
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30.0,
                      backgroundImage: AssetImage(
                          'assets/bg.png'), // Ganti dengan link atau asset gambar user
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      'Abraham', // Nama pengguna
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),

                // Search bar
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
                SizedBox(
                  height: 20.0),

                // Grid Menu
                GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 60.0,
                  mainAxisSpacing: 60.0,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    buildMenuItem(context, 'Dashboard', Icons.calendar_today),
                    buildMenuItem(context, 'Modul', Icons.book),
                    buildMenuItem(context, 'Absen', Icons.checklist),
                    buildMenuItem(context, 'Schedule', Icons.schedule),
                    buildMenuItem(context, 'Quiz', Icons.lightbulb),
                    buildMenuItem(context, 'Struktur', Icons.account_tree),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.green), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view, color: Colors.grey), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.access_time, color: Colors.grey), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.message, color: Colors.grey), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person, color: Colors.grey), label: ''),
        ],
      ),
    );
  }

  // Fungsi untuk membuat item menu
  Widget buildMenuItem(BuildContext context, String title, IconData icon) {
    return Container(
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
    );
  }
}

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeView(),
  ));
}
