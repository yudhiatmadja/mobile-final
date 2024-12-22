import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'modul.dart';

class ModulController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observables
  var modulList = <Modul>[].obs;

  // Controllers for form inputs
  final titleController = TextEditingController();
  final penulisController = TextEditingController();
  final deskripsiController = TextEditingController();
  final isiModulController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchModuls();
  }

  @override
  void onClose() {
    titleController.dispose();
    penulisController.dispose();
    deskripsiController.dispose();
    isiModulController.dispose();
    super.onClose();
  }

  void fetchModuls() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('moduls').get();
      modulList.clear();
      for (var doc in querySnapshot.docs) {
        modulList.add(Modul.fromMap(doc.id, doc.data() as Map<String, dynamic>));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch data: $e');
    }
  }

  void addModul(String title, String penulis, String deskripsi, String isi_modul) async {
    try {
      DocumentReference docRef = await _firestore.collection('moduls').add({
        'title': title,
        'penulis': penulis,
        'deskripsi': deskripsi,
        'isi_modul': isi_modul,
        'date': Timestamp.now(),
      });
      modulList.add(Modul(
        id: docRef.id,
        title: title,
        penulis: penulis,
        deskripsi: deskripsi,
        isi_modul: isi_modul,
        date: Timestamp.now(),
      ));
      Get.snackbar('Success', 'Modul added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add Modul: $e');
    }
  }

  void updateModul(String id, String title, String penulis, String deskripsi, String isi_modul) async {
    try {
      await _firestore.collection('moduls').doc(id).update({
        'title': title,
        'penulis': penulis,
        'deskripsi': deskripsi,
        'isi_modul': isi_modul,
        'date': Timestamp.now(),
      });
      int index = modulList.indexWhere((element) => element.id == id);
      if (index != -1) {
        modulList[index] = Modul(
          id: id,
          title: title,
          penulis: penulis,
          deskripsi: deskripsi,
          isi_modul: isi_modul,
          date: Timestamp.now(),
        );
      }
      Get.snackbar('Success', 'Modul updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update Modul: $e');
    }
  }

  void deleteModul(String id) async {
    try {
      await _firestore.collection('moduls').doc(id).delete();
      modulList.removeWhere((element) => element.id == id);
      Get.snackbar('Success', 'Modul deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete Modul: $e');
    }
  }
}
