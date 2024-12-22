import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/app/modules/photo/controllers/photo_controller.dart';
import 'package:mobile/app/routes/app_pages.dart';

class PhotoView extends StatelessWidget {
  final PhotoController controller = Get.put(PhotoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDE1D0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo at the top
            Image.asset(
              "assets/logo.png", // Ganti dengan path logo yang benar
              height: 50.0,
            ),
            SizedBox(height: 15.0),

            // Register title
            Text(
              "Foto Profile",
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 15.0),

            // Display selected photo or default icon
            Obx(() => CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: controller.selectedImagePath.value != ''
                      ? FileImage(File(controller.selectedImagePath.value))
                      : null,
                  child: controller.selectedImagePath.value == ''
                      ? Icon(
                          Icons.person_outline,
                          size: 25.0,
                          color: Colors.black,
                        )
                      : null,
                )),
            SizedBox(height: 5.0),
            ElevatedButton(
              onPressed: () {
                // Add action to take a photo
                controller.pickImage(ImageSource.camera);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF009D44), // Hijau
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              child: Text(
                "Take Photo",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8.0,
                ),
              ),
            ),
            SizedBox(height: 15.0),

            // Upload Photo icon and button
            CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.grey.shade200,
              child: Icon(
                Icons.person_outline,
                size: 25.0,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5.0),
            ElevatedButton(
              onPressed: () {
                // Add action to upload a photo
                controller.pickImage(ImageSource.gallery);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF009D44), // Hijau
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              child: Text(
                "Upload Photo",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8.0,
                ),
              ),
            ),
            SizedBox(height: 15.0),

            // Buttons Upload and Skip
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Add action for upload
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Hitam untuk Upload
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  child: Text(
                    "Upload",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8.0,
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                OutlinedButton(
                  onPressed: () {
                    // Add action for skip
                    Get.toNamed(Routes.PROFILE);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 8.0,
                    ),
                  ),
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
    home: PhotoView(),
    getPages: AppPages.routes,
  ));
}

