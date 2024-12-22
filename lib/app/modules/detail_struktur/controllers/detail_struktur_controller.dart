import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/app/modules/struktur/views/struktur_view.dart';

class DetailStrukturController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable untuk data Struktur yang dipilih
  var selectedStruktur = Rxn<Struktur>();

  // Fetch Struktur detail by document ID
  void fetchStrukturDetail(String id) async {
    try {
      // Mengambil dokumen berdasarkan ID di koleksi 'komponen'
      DocumentSnapshot doc = await _firestore.collection('komponen').doc(id).get();
      
      if (doc.exists) {
        // Jika dokumen ditemukan, set data ke selectedStruktur
        selectedStruktur.value = Struktur.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      } else {
        // Jika tidak ditemukan, tampilkan pesan error
        Get.snackbar('Error', 'Data tidak ditemukan');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil data: $e');
    }
  }
}


