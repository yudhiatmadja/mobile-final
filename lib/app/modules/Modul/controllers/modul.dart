import 'package:cloud_firestore/cloud_firestore.dart';

class Modul {
  String id;
  String title;
  String penulis;
  String deskripsi;
  String isi_modul;
  Timestamp date;

  Modul({
    required this.id,
    required this.title,
    required this.penulis,
    required this.deskripsi,
    required this.isi_modul,
    required this.date,
  });

  // Convert Firestore document to Modul object
  Modul.fromMap(String id, Map<String, dynamic> map)
      : id = id,
        title = map['title'],
        penulis = map['penulis'],
        deskripsi = map['deskripsi'],
        isi_modul = map['isi_modul'],
        date = map['date'];

  // Convert Modul object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'penulis': penulis,
      'deskripsi': deskripsi,
      'isi_modul': isi_modul,
      'date': date,
    };
  }
}
