import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/detail_struktur/views/detail_struktur_view.dart';
import '../controllers/jabatan_controller.dart';

class JabatanView extends GetView<JabatanController> {
  final JabatanController controller = Get.put(JabatanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Struktur'),
        backgroundColor: Colors.green,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Container(
        color: Color(0xFFEDE1D0),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            // Carousel for the main image
            Container(
              height: 100,
              child: PageView(
                children: [
                  Image.asset(
                    'assets/bg.png', // Replace with actual image URL
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.structureList.length,
                  itemBuilder: (context, index) {
                    var item = controller.structureList[index];
                    // Tentukan warna berdasarkan indeks (ganjil/genap)
                    Color backgroundColor = index.isEven
                        ? Color.fromARGB(255, 209, 234, 207)
                        : Color.fromARGB(255, 247, 219, 219);

                    return GestureDetector(
                      onTap: () {
                        Get.to(() => DetailStrukturView(), arguments: ['id']);
                      },
                      child: Container(
                        color: backgroundColor, // Terapkan warna latar belakang
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        margin: const EdgeInsets.only(bottom: 5), // Jarak antar item
                        child: Row(
                          children: [
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['nama'] ?? '',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  item['jabatan'] ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: JabatanView(),
  ));
}
