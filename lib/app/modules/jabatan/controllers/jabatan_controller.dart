import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JabatanController extends GetxController {
  // Observable list untuk menyimpan data dari Firestore
  var structureList = <Map<String, dynamic>>[].obs;

  // Instance Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchDataFromFirestore(); // Panggil fungsi untuk mengambil data
  }

  // Fungsi untuk mengambil data dari Firestore
  void fetchDataFromFirestore() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('komponen').get();
      structureList.clear(); // Bersihkan list sebelum diisi data baru

      for (var doc in snapshot.docs) {
        structureList.add({
          'nama': doc['nama'] ?? 'Tidak ada nama',
          'jabatan': doc['jabatan'] ?? 'Tidak ada jabatan',
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil data dari Firestore: $e');
    }
  }
}
