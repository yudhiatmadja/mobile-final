import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile/app/modules/struktur/controllers/struktur_controller.dart';
import 'package:mobile/firebase_options.dart';

class Struktur {
  final String id;
  final String nama;
  final String periode;
  final String jabatan;
  final String tugas;

  Struktur({required this.id, required this.nama, required this.periode, required this.jabatan, required this.tugas});

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'periode': periode,
      'jabatan': jabatan,
      'tugas': tugas,
    };
  }

  static Struktur fromMap(String id, Map<String, dynamic> map) {
    return Struktur(
      id: id,
      nama: map['nama'],
      periode: map['periode'],
      jabatan: map['jabatan'],
      tugas: map['tugas'],
    );
  }
}

class StrukturView extends StatelessWidget {
  final StrukturController controller = Get.put(StrukturController());
  final TextEditingController namaController = TextEditingController();
  final TextEditingController periodeController = TextEditingController();
  final TextEditingController jabatanController = TextEditingController();
  final TextEditingController tugasController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Struktur'),
        centerTitle: true,
      ),
      body: Obx(() {
        return ListView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: controller.strukturList.length,
          itemBuilder: (context, index) {
            final modul = controller.strukturList[index];
            return Card(
              color: Colors.green.shade50,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.image, size: 50, color: Colors.grey),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(modul.nama,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(modul.periode, style: TextStyle(fontSize: 12)),
                            SizedBox(height: 5),
                            Text(modul.jabatan),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            controller.deleteStruktur(modul.id);
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                          label: Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            showEditDialog(context, modul);
                          },
                          icon: Icon(Icons.edit, color: Colors.black),
                          label: Text('Edit'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  void showEditDialog(BuildContext context, Struktur struktur) {
    namaController.text = struktur.nama;
    periodeController.text = struktur.periode;
    jabatanController.text = struktur.jabatan;
    tugasController.text = struktur.tugas;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return buildDialog(context, 'Edit', () {
          controller.updateStruktur(struktur.id, namaController.text,
              periodeController.text, jabatanController.text, tugasController.text);
          Get.back();
        });
      },
    );
  }

  void showAddDialog(BuildContext context) {
    namaController.clear();
    periodeController.clear();
    jabatanController.clear();
    tugasController.clear;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return buildDialog(context, 'Tambah', () {
          controller.addStruktur(namaController.text, periodeController.text,
              jabatanController.text, tugasController.text);
          Get.back();
        });
      },
    );
  }

  Widget buildDialog(BuildContext context, String title, VoidCallback onSave) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              child: IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () {
                  // Implement photo selection logic
                },
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: namaController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: periodeController,
              decoration: InputDecoration(labelText: 'Periode'),
            ),
            TextField(
              controller: jabatanController,
              decoration: InputDecoration(labelText: 'Jabatan'),
            ),
            TextField(
              controller: tugasController,
              decoration: InputDecoration(labelText: 'Tugas'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // Close the dialog without saving
          },
          child: Text('Batal'),
        ),
        ElevatedButton(
          onPressed: onSave,
          child: Text('Simpan'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
        ),
      ],
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
    home: StrukturView(),
  ));
}
