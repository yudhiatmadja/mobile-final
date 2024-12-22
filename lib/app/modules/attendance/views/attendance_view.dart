import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/attendance_controller.dart';

class AttendanceView extends GetView<AttendanceController> {
  final AttendanceController controller = Get.put(AttendanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Presensi'),
        backgroundColor: Colors.green,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Get.back();
          },
        ),
      ),
      body: Container(
        color: Color(0xFFEDE1D0),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Obx(() {
          return ListView.builder(
            itemCount: controller.attendanceList.length,
            itemBuilder: (context, index) {
              var item = controller.attendanceList[index];
              return Card(
                color: Colors.lightGreen[50],
                margin: EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  title: Text(item['title'] ?? ''),
                  trailing: Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    decoration: BoxDecoration(
                      color: item['status'] == 'Hadir' ? Colors.green : Colors.red[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item['status'] ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: AttendanceView(),
  ));
}
