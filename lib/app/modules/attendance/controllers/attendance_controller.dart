import 'package:get/get.dart';

class AttendanceController extends GetxController {
  //TODO: Implement AttendanceController

  final count = 0.obs;
  // Sample data for the list
  var attendanceList = [
    {'title': 'Penjelajahan', 'status': 'Hadir'},
    {'title': 'Jambore', 'status': 'Hadir'},
    {'title': 'Perkemahan', 'status': 'Absen'},
    {'title': 'Baris-Berbaris', 'status': 'Hadir'},
    {'title': 'Bersih Alat', 'status': 'Hadir'},
    {'title': 'Upacara', 'status': 'Hadir'},
  ].obs;
  
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
