import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile/app/modules/foto/controllers/foto_controller.dart';
import 'package:mobile/app/modules/login/views/login_view.dart';
import 'package:mobile/firebase_options.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final FotoController fotoController = Get.put(FotoController());

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFEDE1D0),
        title: Text('Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Stack(
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
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: (){
                      Get.toNamed('/foto');
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 10.0,
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 12.0,
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Obx(() => buildProfileItem(context, 'Username', controller.name.value, () {
              _showEditDialog(context, 'Username', controller.name.value, (newValue) {
                controller.updateUserProfile(newname: newValue);
              });
            })),
            Obx(() => buildProfileItem(context, 'Email Address', controller.email.value, null)), // Email is typically not editable
            Obx(() => buildProfileItem(context, 'Phone Number', controller.phone_number.value, () {
              _showEditDialog(context, 'Phone Number', controller.phone_number.value, (newValue) {
                controller.updateUserProfile(newphonenumber: newValue);
              });
            })),
            SizedBox(height: 5.0),
            buildProfileButton(
              context,
              'History',
              Icons.arrow_right,
              onPressed: () {
                // Navigate to History
              },
            ),
            buildProfileButton(
              context,
              'Riwayat',
              Icons.arrow_right,
              onPressed: () {
                // Navigate to Riwayat
              },
            ),
            buildProfileButton(
              context,
              'Logout',
              Icons.arrow_right,
              onPressed: () {
                controller.logout();
                Get.offAll(() => LoginView());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileItem(BuildContext context, String title, String value, VoidCallback? onEdit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '$title: $value',
                style: TextStyle(
                  fontSize: 8.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            if (onEdit != null)
              IconButton(
                icon: Icon(Icons.edit, size: 5.0),
                onPressed: onEdit,
              ),
          ],
        ),
        Divider(
          thickness: 1,
          color: Colors.grey.shade400,
        ),
        SizedBox(height: 5.0),
      ],
    );
  }

  Widget buildProfileButton(BuildContext context, String title, IconData icon, {VoidCallback? onPressed}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF009D44),
          padding: EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 8.0,
                color: Colors.white,
              ),
            ),
            Icon(icon, color: Colors.white),
          ],
        ),
      ),
    );
  }

  // Show dialog to edit profile field
  void _showEditDialog(BuildContext context, String title, String currentValue, Function(String) onSave) {
    final TextEditingController textController = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(hintText: 'Enter new $title'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onSave(textController.text);
                Get.back();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
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
    home: ProfileView(),
  ));
}
