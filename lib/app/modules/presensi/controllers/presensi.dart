import 'package:cloud_firestore/cloud_firestore.dart';

class Presensi {
  String id;
  String name;
  bool status;
  String keterangan;
  DateTime date;

  Presensi({
    required this.id,
    required this.name,
    required this.status,
    required this.keterangan,
    required this.date,
  });

  // Factory method to create a Presensi instance from Firestore data
  factory Presensi.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Presensi(
      id: doc.id,
      name: data['name'] ?? '',
      status: data['status'] ?? false,
      keterangan: data['keterangan'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  // Convert Presensi to a Firestore-compatible format
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'status': status,
      'keterangan': keterangan,
      'date': Timestamp.fromDate(date),
    };
  }
}

