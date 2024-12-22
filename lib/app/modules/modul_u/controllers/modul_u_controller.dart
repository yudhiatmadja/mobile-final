import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/app/modules/Modul/controllers/modul.dart';

class ModulUController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var modulList = <Modul>[].obs; // Observable list to hold modules

  @override
  void onInit() {
    super.onInit();
    fetchModuls(); // Fetch modules when the controller is initialized
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
}
