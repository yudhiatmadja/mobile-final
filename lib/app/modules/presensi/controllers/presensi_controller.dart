import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/presensi/controllers/presensi.dart';

class PresensiController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var presensiList = <Presensi>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPresensi();
  }

  // Fetch all presensi records
  void fetchPresensi() {
    firestore.collection('presensi').snapshots().listen((snapshot) {
      presensiList.value = snapshot.docs
          .map((doc) => Presensi.fromFirestore(doc))
          .toList();
    });
  }

  // Add a new presensi record
  Future<void> addPresensi(Presensi presensi) async {
    await firestore.collection('presensi').add(presensi.toFirestore());
  }

  // Update an existing presensi record
  Future<void> updatePresensi(Presensi presensi) async {
    await firestore.collection('presensi').doc(presensi.id).update(presensi.toFirestore());
  }

  // Delete a presensi record
  Future<void> deletePresensi(String id) async {
    await firestore.collection('presensi').doc(id).delete();
  }
}
