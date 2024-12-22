import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

class DokumentasiController extends GetxController {
  var selectedImage = Rx<File?>(null); // File gambar yang dipilih
  var selectedVideo = Rx<File?>(null); // File video yang dipilih
  final ImagePicker _picker = ImagePicker(); // Instance ImagePicker
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance
  final box = GetStorage(); // GetStorage instance

  var isConnected = true.obs; // Status koneksi internet
  var isUploading = false.obs; // Status unggahan
  var uploadQueue = <Map<String, dynamic>>[].obs; // Antrian data untuk diunggah

 @override
  void onInit() {
    super.onInit();

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

    // Muat data antrian dari penyimpanan lokal
    loadUploadQueue();
  }


  // Simpan data ke antrian unggahan
  void addDataToQueue(Map<String, dynamic> data) {
    uploadQueue.add(data);
    saveUploadQueue();
  }

  // Simpan antrian unggahan ke GetStorage
  void saveUploadQueue() {
    box.write("uploadQueue", uploadQueue.toList());
  }

  // Muat antrian unggahan dari GetStorage
  void loadUploadQueue() {
    List<dynamic>? storedQueue = box.read<List<dynamic>>("uploadQueue");
    if (storedQueue != null) {
      uploadQueue.assignAll(storedQueue.cast<Map<String, dynamic>>());
    }
  }

  // Hapus data dari antrian setelah berhasil diunggah
  void removeDataFromQueue(Map<String, dynamic> data) {
    uploadQueue.remove(data);
    saveUploadQueue();
  }

  // Upload data ke Firestore
  Future<void> uploadData({required String type, required String filePath}) async {
    try {
      final file = File(filePath);
      final storageRef = FirebaseStorage.instance
        .ref()
        .child('uploads/${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}');

      await storageRef.putFile(file);
    } catch (e) {
      print("Error uploading to Firebase Storage: $e");
    }

    Map<String, dynamic> data = {
      'type': type,
      'filePath': filePath,
      'timestamp': FieldValue.serverTimestamp(),
    };

    if (isConnected.value) {
      isUploading.value = true;
      try {
        await _firestore.collection('dokumentasi').add(data);
        print("Data uploaded successfully: $data");
      } catch (e) {
        print("Upload failed, adding to queue: $e");
        addDataToQueue(data);
      } finally {
        isUploading.value = false;
      }
    } else {
      print("No connection, adding data to queue.");
      addDataToQueue(data);
    }
  }

  // Unggah semua data yang tertunda
  Future<void> uploadPendingData() async {
    if (uploadQueue.isEmpty) return;

    isUploading.value = true;
    for (var data in List.from(uploadQueue)) {
      try {
        await _firestore.collection('dokumentasi').add(data);
        removeDataFromQueue(data);
        print("Pending data uploaded successfully: $data");
      } catch (e) {
        print("Failed to upload pending data: $e");
        break; // Hentikan jika ada masalah
      }
    }
    isUploading.value = false;
  }

  // Fungsi untuk mengambil foto dari kamera
  Future<void> ambilFotoDariKamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
      await uploadData(type: "image", filePath: pickedFile.path);
    }
  }

  // Fungsi untuk memilih foto dari galeri
  Future<void> ambilFotoDariGaleri() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
      await uploadData(type: "image", filePath: pickedFile.path);
    }
  }

  // Fungsi untuk mengambil video dari kamera
  Future<void> ambilVideoDariKamera() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      selectedVideo.value = File(pickedFile.path);
      await uploadData(type: "video", filePath: pickedFile.path);
    }
  }

  // Fungsi untuk memilih video dari galeri
  Future<void> ambilVideoDariGaleri() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedVideo.value = File(pickedFile.path);
      await uploadData(type: "video", filePath: pickedFile.path);
    }
  }

  var uploadedMedia = <Map<String, dynamic>>[].obs; // Daftar media yang diunggah

  Future<void> fetchUploadedMedia() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('dokumentasi').get();

      uploadedMedia.assignAll(snapshot.docs.map((doc) {
        return {
          'type': doc['type'],
          'filePath': doc['filePath'],
          'timestamp': doc['timestamp'],
        };
      }).toList());
    } catch (e) {
      print("Failed to fetch uploaded media: $e");
    }
  }

  // Metode untuk menghapus data di pending secara manual
  void deletePendingData(int index) {
    if (index >= 0 && index < uploadQueue.length) {
      Map<String, dynamic> removedData = uploadQueue.removeAt(index);
      saveUploadQueue(); // Simpan perubahan antrian ke storage
      print("Deleted pending data: $removedData");
      Get.snackbar(
        "Data Dihapus",
        "Data berhasil dihapus dari antrian.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      print("Invalid index: $index");
    }
  }



  //Reset gambar dan video yang diambil atau dipilih
  void resetMedia() {
    selectedImage.value = null;
    selectedVideo.value = null;
  }
}
