import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/Modul/controllers/modul.dart';
import 'package:mobile/app/modules/quizuser/views/quizuser_view.dart';
import 'package:mobile/firebase_options.dart';
import '../controllers/baca_modul_controller.dart';

class BacaModulView extends GetView<BacaModulController> {
  final BacaModulController controller = Get.put(BacaModulController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.top,
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Modul'),
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
      color: Color(0xFFEDE1D0), // Background color
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              color: Color(0xFFE8F5E9), // Content background color
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              padding: EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () {
                        // Check if the module list is not empty
                        if (controller.modulList.isEmpty) {
                          return Text("Loading...", style: TextStyle(fontSize: 8), textAlign: TextAlign.center);
                        } else {
                          // Get the current module based on currentPage
                          Modul currentModul = controller.modulList[controller.currentPage.value - 1];
                          return Column(
                            children: [
                              Text(
                                currentModul.title, // Display title
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10),
                              Text(
                                currentModul.deskripsi, // Display description
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10),
                              Text(
                                currentModul.isi_modul, // Display module content
                                style: TextStyle(fontSize: 14),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: controller.previousPage,
                icon: Icon(Icons.arrow_left),
              ),
              Obx(
                () => Text(
                  'Page ${controller.currentPage.value}/${controller.totalPages}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              IconButton(
                onPressed: controller.nextPage,
                icon: Icon(Icons.arrow_right),
              ),
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[100],
                minimumSize: Size(double.infinity, 48),
              ),
              onPressed: () {
                Get.to(QuizuserView());
              },
              child: Text(
                'Mulai Quiz',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 20),
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
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: BacaModulView(),
  ));
}