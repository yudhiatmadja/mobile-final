import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class JadwalController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  var calenderFormat = CalendarFormat.month.obs; // State untuk format kalender
  var kegiatanList = <Map<String, dynamic>>[].obs; // Daftar kegiatan

  // Fungsi untuk menambahkan kegiatan ke Firestore
  Future<void> addKegiatan(String title, String date, String description, String location) async {
    try {
      await _firestore.collection('kegiatan').add({
        'title': title,
        'date': date,
        'description': description,
        'location': location, // Lokasi default
      });
      fetchKegiatan(); // Refresh data setelah menambahkan
    } catch (e) {
      print("Error adding kegiatan: $e");
    }
  }

  // Fungsi untuk mengedit kegiatan di Firestore
  Future<void> editKegiatan(String documentId, String title, String date, String description, String location) async {
    try {
      await _firestore.collection('kegiatan').doc(documentId).update({
        'title': title,
        'date': date,
        'description': description,
        'location': location,
      });
      fetchKegiatan(); // Refresh data setelah mengedit
    } catch (e) {
      print("Error updating kegiatan: $e");
    }
  }

  // Fungsi untuk menghapus kegiatan dari Firestore
  Future<void> deleteKegiatan(String documentId) async {
    try {
      await _firestore.collection('kegiatan').doc(documentId).delete();
      fetchKegiatan(); // Refresh data setelah menghapus
    } catch (e) {
      print("Error deleting kegiatan: $e");
    }
  }

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

