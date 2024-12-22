import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class JadwalUController extends GetxController {
  //TODO: Implement JadwalUController

 final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  var calenderFormat = CalendarFormat.month.obs; // State untuk format kalender
  var kegiatanList = <Map<String, dynamic>>[].obs; // Daftar kegiatan

  // Fungsi untuk mengambil data kegiatan dari Firestore
  Future<void> fetchKegiatan() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('kegiatan').get();
      kegiatanList.value = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'title': doc['title'],
          'date': doc['date'],
          'description': doc['description'],
          'location': doc['location'],
        };
      }).toList();
    } catch (e) {
      print("Error fetching kegiatan: $e");
    }
  }

  // Method untuk mengupdate format kalender
  void updateCalendarFormat(CalendarFormat format) {
    calenderFormat.value = format;
  }

  @override
  void onInit() {
    super.onInit();
    fetchKegiatan(); // Ambil data kegiatan saat controller diinisialisasi
  }
}
