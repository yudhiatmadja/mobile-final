import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/schedule/views/schedule_view.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controllers/jadwal_u_controller.dart';
import 'package:mobile/app/routes/app_pages.dart'; // Pastikan ini sesuai dengan rute di proyek Anda

class JadwalUView extends GetView<JadwalUController> {
  final JadwalUController controller = Get.put(JadwalUController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Jadwal'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          }
        ),
      
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Logika menu
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() => TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: DateTime.now(),
              calendarFormat: controller.calenderFormat.value,
              onFormatChanged: (CalendarFormat _format) {
                controller.updateCalendarFormat(_format);
              },
              selectedDayPredicate: (day) {
                return isSameDay(day, DateTime.now());
              },
              onDaySelected: (selectedDay, focusedDay) {
                // Logika ketika tanggal dipilih
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.red.shade300,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.red.shade100,
                  shape: BoxShape.circle,
                ),
              ),
            )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Schedule',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.SCHEDULE); // Navigasi ke halaman detail jadwal
                  },
                  child: Text(
                    "More",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey.shade600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: controller.kegiatanList.length,
                itemBuilder: (context, index) {
                  final kegiatan = controller.kegiatanList[index];
                  return Card(
                    color: Colors.green.shade50,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.image, size: 50, color: Colors.grey),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                kegiatan['title']!,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text(kegiatan['date']!,
                                  style: TextStyle(fontSize: 12)),
                              SizedBox(height: 5),
                              Text(kegiatan['description']!),
                            ],
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: JadwalUView(),
    initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => ScheduleView()),
      ],
  ));
}

