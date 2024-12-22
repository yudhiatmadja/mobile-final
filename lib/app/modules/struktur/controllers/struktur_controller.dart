import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/struktur/views/struktur_view.dart';

class StrukturController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obx observable list to store Struktur items
  var strukturList = <Struktur>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchStruktur(); // Fetch data when the controller is initialized
  }

  // Fetch all Struktur documents from Firestore
  void fetchStruktur() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('komponen').get();
      strukturList.clear();
      for (var doc in querySnapshot.docs) {
        strukturList.add(Struktur.fromMap(doc.id, doc.data() as Map<String, dynamic>));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch data: $e');
    }
  }

  // Add a new Struktur document to Firestore
  void addStruktur(String nama, String periode, String jabatan, String tugas) async {
    try {
      DocumentReference docRef = await _firestore.collection('komponen').add({
        'nama': nama,
        'periode': periode,
        'jabatan': jabatan,
        'tugas': tugas,
      });
      strukturList.add(Struktur(id: docRef.id, nama: nama, periode: periode, jabatan: jabatan, tugas: tugas));
      Get.snackbar('Success', 'Struktur added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add Struktur: $e');
    }
  }

  // Update an existing Struktur document in Firestore
  void updateStruktur(String id, String nama, String periode, String jabatan, String tugas) async {
    try {
      await _firestore.collection('komponen').doc(id).update({
        'nama': nama,
        'periode': periode,
        'jabatan': jabatan,
        'tugas': tugas,
      });
      int index = strukturList.indexWhere((element) => element.id == id);
      if (index != -1) {
        strukturList[index] = Struktur(id: id, nama: nama, periode: periode, jabatan: jabatan, tugas: tugas);
      }
      Get.snackbar('Success', 'Struktur updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update Struktur: $e');
    }
  }

  // Delete a Struktur document from Firestore
  void deleteStruktur(String id) async {
    try {
      await _firestore.collection('komponen').doc(id).delete();
      strukturList.removeWhere((element) => element.id == id);
      Get.snackbar('Success', 'Struktur deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete Struktur: $e');
    }
  }
}
