import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

class FotoController extends GetxController {
  var selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final box = GetStorage();

  var selectedImagePath = ''.obs;
  var isImageLoading = false.obs;
  var isConnected = true.obs;
  var isUploading = false.obs;
  var uploadQueue = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfilePhoto(); // Muat foto profil pengguna
    loadUploadQueue(); // Muat antrian unggahan
    ever(isConnected, (connected) {
      if (connected) uploadPendingData(); // Unggah data yang tertunda
    });


    // Pantau perubahan status koneksi
    ever(isConnected, (bool connected) {
      if (connected) {
        Get.snackbar(
          "Koneksi Tersambung",
          "Aplikasi sekarang terhubung ke internet.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        uploadPendingData(); // Coba upload data pending
      } else {
        Get.snackbar(
          "Koneksi Terputus",
          "Aplikasi tidak terhubung ke internet.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    });


    // Muat antrian unggahan dari GetStorage
    loadUploadQueue();

    // Jika koneksi tersambung, unggah data pending
    ever(isConnected, (connected) {
      if (connected) {
        uploadPendingData();
      }
    });
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      isImageLoading.value = true;
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        selectedImagePath.value = pickedFile.path;
        selectedImage.value = File(pickedFile.path);
        await uploadData(type: "image", filePath: pickedFile.path);
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    } finally {
      isImageLoading.value = false;
    }
  }

  void addDataToQueue(Map<String, dynamic> data) {
    uploadQueue.add(data);
    saveUploadQueue();
  }

  void saveUploadQueue() {
    box.write("uploadQueue", uploadQueue.toList());
  }

  void loadUploadQueue() {
    List<dynamic>? storedQueue = box.read<List<dynamic>>("uploadQueue");
    if (storedQueue != null) {
      uploadQueue.assignAll(storedQueue.cast<Map<String, dynamic>>());
    }
  }

  void removeDataFromQueue(Map<String, dynamic> data) {
    uploadQueue.remove(data);
    saveUploadQueue();
  }


  Future<void> uploadData({required String type, required String filePath}) async {
    if (!File(filePath).existsSync()) {
      print("File does not exist at path: $filePath");
      return;
    }

    isUploading.value = true;
    try {
      String userId = box.read('userId'); // Ambil userId dari GetStorage
      String fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";

      // Upload file ke Firebase Storage
      Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('users/$userId/$fileName');
      UploadTask uploadTask = storageRef.putFile(File(filePath));
      TaskSnapshot snapshot = await uploadTask;

      // Dapatkan URL gambar
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Perbarui dokumen user di koleksi 'users'
      await _firestore.collection('users').doc(userId).update({
        'image': downloadUrl, // Tambahkan atau perbarui atribut 'image'
      });

      print("Photo uploaded successfully: $downloadUrl");
    } catch (e) {
      print("Upload failed: $e");
      // Jika gagal, tambahkan ke antrian
      addDataToQueue({'type': type, 'filePath': filePath});
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> fetchUserProfilePhoto() async {
    try {
      String userId = box.read('userId'); // Ambil userId dari GetStorage
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(userId).get();

      if (snapshot.exists && snapshot.data() != null) {
        selectedImagePath.value = snapshot['image'] ?? '';
        print("Profile photo loaded: ${selectedImagePath.value}");
      } else {
        print("User document does not exist or has no image.");
      }
    } catch (e) {
      print("Failed to fetch profile photo: $e");
    }
  }



  Future<void> uploadPendingData() async {
    if (uploadQueue.isEmpty) return;

    isUploading.value = true;
    for (var data in List.from(uploadQueue)) {
      try {
        await _firestore.collection('users').add(data);
        removeDataFromQueue(data);
        print("Pending data uploaded successfully: $data");
      } catch (e) {
        print("Failed to upload pending data: $e");
      }
    }
    isUploading.value = false;
  }

  void resetMedia() {
    selectedImage.value = null;
    selectedImagePath.value = '';
  }
}
