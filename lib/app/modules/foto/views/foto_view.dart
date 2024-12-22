import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/foto_controller.dart';

class FotoView extends GetView<FotoController> {
  final FotoController controller = Get.put(FotoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF009D44), // Warna hijau pada AppBar
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back(); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      backgroundColor: Color(0xFFEDE1D0),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Upload File or Take Photo",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 30.0),

              // Display selected photo or default icon
              Obx(() => CircleAvatar(
                    radius: 60.0,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: controller.selectedImagePath.value != ''
                        ? FileImage(File(controller.selectedImagePath.value))
                        : null,
                    child: controller.selectedImagePath.value == ''
                        ? Icon(
                            Icons.person_outline,
                            size: 60.0,
                            color: Colors.black,
                          )
                        : null,
              )),

              SizedBox(height: 20.0),

              // Take Photo and Upload Photo buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await controller.pickImage(ImageSource.camera);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF009D44), // Hijau
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      "Take Photo",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  OutlinedButton(
                    onPressed: () async {
                      await controller.pickImage(ImageSource.gallery);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Color(0xFF009D44)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      "Upload Photo",
                      style: TextStyle(
                        color: Color(0xFF009D44),
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();// Pastikan Firebase terinisialisasi
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: FotoView(),
  ));
}
