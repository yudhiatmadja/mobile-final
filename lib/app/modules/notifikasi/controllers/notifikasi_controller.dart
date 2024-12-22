import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotifikasiController extends GetxController {
  var notifikasiList = <Map<String, dynamic>>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchNotifikasi();
  }

  void fetchNotifikasi() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('notifikasi').get();
      List<Map<String, dynamic>> tempList = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'title': doc['title'] ?? 'No Title',
          'description': doc['description'] ?? 'No Description',
          'date': (doc['date'] as Timestamp).toDate().toString() ?? 'No Date',
        };
      }).toList();
      notifikasiList.value = tempList;
    } catch (e) {
      print("Error fetching notifications: $e");
    }
  }
}
