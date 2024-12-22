import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile/firebase_options.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mobile/app/modules/jadwal/controllers/jadwal_controller.dart';

class JadwalView extends StatelessWidget {
  final JadwalController controller = Get.put(JadwalController());
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController(); 
  final locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Jadwal Kegiatan'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back), 
          onPressed: (){
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
            padding: const EdgeInsets.all(8.0),
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
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Schedule',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    showAddEditDialog(context);
                  },
                ),
              ],
            ),
          ),
          // Gantilah bagian ListView di JadwalView
          Expanded(
            child: Obx(() {
              return ListView.builder(
                padding: const EdgeInsets.all(5.0),
                itemCount: controller.kegiatanList.length,
                itemBuilder: (context, index) {
                  final kegiatan = controller.kegiatanList[index];
                  return Card(
                    color: Colors.green.shade50,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.image, size: 25, color: Colors.grey),
                          SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                kegiatan['title'],
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                              SizedBox(height: 3),
                              Text(kegiatan['date'], style: TextStyle(fontSize: 9)),
                              SizedBox(height: 3),
                              Text(kegiatan['description'], style: TextStyle(fontSize: 8)),
                            ],
                          ),
                          Spacer(),
                          Row(
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  controller.deleteKegiatan(kegiatan['id']);
                                },
                                icon: Icon(Icons.delete, color: Colors.red, size: 10),
                                label: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red, fontSize: 10.0),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  showAddEditDialog(context, index: index, documentId: kegiatan['id']);
                                },
                                icon: Icon(Icons.edit, color: Colors.black, size: 10),
                                label: Text(
                                  'Edit',
                                  style: TextStyle(color: Colors.black, fontSize: 10.0),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          )

        ],
      ),
    );
  }

  // Fungsi untuk menampilkan dialog tambah/edit kegiatan
  void showAddEditDialog(BuildContext context, {int? index, String? documentId}) {
  final isEditing = documentId != null;

  if (isEditing && index != null) {
    final kegiatan = controller.kegiatanList[index];
    titleController.text = kegiatan['title'];
    descriptionController.text = kegiatan['description'];
    dateController.text = kegiatan['date'];
    locationController.text = kegiatan['location'];
  } else {
    titleController.clear();
    descriptionController.clear();
    dateController.clear();
    locationController.clear();
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(isEditing ? 'Edit Kegiatan' : 'Tambah Kegiatan'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Judul Kegiatan'),
              ),
              TextField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'Tanggal Kegiatan'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Deskripsi Kegiatan'),
              ),
              TextField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Lokasi Kegiatan'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Tutup dialog tanpa menyimpan
            },
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (isEditing) {
                controller.editKegiatan(
                  documentId,
                  titleController.text,
                  dateController.text,
                  descriptionController.text,
                  locationController.text,
                );
              } else {
                controller.addKegiatan(
                  titleController.text,
                  dateController.text,
                  descriptionController.text,
                  locationController.text,
                );
              }
              Get.back(); // Tutup dialog setelah menyimpan
            },
            child: Text('Simpan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
          ),
        ],
      );
    },
  );
}

}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: JadwalView(),
  ));
}
