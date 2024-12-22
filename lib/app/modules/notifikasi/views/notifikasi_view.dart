import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notifikasi_controller.dart';

class NotifikasiView extends StatelessWidget {
  final NotifikasiController controller = Get.put(NotifikasiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Notifikasi'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Obx(() {
        if (controller.notifikasiList.isEmpty) {
          return Center(child: Text('No Notifications Available'));
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: controller.notifikasiList.length,
            itemBuilder: (context, index) {
              final notifikasi = controller.notifikasiList[index];
              return Card(
                color: Colors.green.shade50,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.notifications, size: 50, color: Colors.grey),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notifikasi['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            notifikasi['date'],
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(height: 5),
                          Text(notifikasi['description']),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: NotifikasiView(),
  ));
}
