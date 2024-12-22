import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/app/modules/Modul/controllers/modul.dart';

class BacaModulController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var currentPage = 1.obs;
  var modulList = <Modul>[].obs; 
  var totalPages = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchContent();
  }

  Future<void> fetchContent() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('moduls').get();
      modulList.clear();
      for (var doc in querySnapshot.docs) {
        modulList.add(Modul.fromMap(doc.id, doc.data() as Map<String, dynamic>));
        totalPages.value = modulList.length;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch data: $e');
    }
  }

  void nextPage() {
    if (currentPage.value < totalPages.value) {
      currentPage.value++;
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
    }
  }
}

