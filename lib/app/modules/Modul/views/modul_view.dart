import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile/app/modules/Modul/controllers/modul.dart';
import 'package:mobile/app/modules/Modul/controllers/modul_controller.dart';
import 'package:mobile/firebase_options.dart';

class ModulView extends StatelessWidget {
  final ModulController controller = Get.put(ModulController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Modul List'),
      ),
      body: Obx(() {
        return ListView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: controller.modulList.length,
          itemBuilder: (context, index) {
            final modul = controller.modulList[index];
            return Card(
              color: Colors.green.shade50,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.image, size: 50, color: Colors.grey),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(modul.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(modul.penulis, style: TextStyle(fontSize: 12)),
                            SizedBox(height: 5),
                            Text(
                              modul.deskripsi,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              DateFormat('dd-MM-yyyy').format(modul.date.toDate()),
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      modul.isi_modul,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(modul.title),
                              content: SingleChildScrollView(
                                child: Text(modul.isi_modul),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Close'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text('Read More'),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            controller.deleteModul(modul.id);
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                          label: Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            showAddEditDialog(context, modul: modul);
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
          showAddEditDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  void showAddEditDialog(BuildContext context, {Modul? modul}) {
    final isEditing = modul != null;

    if (isEditing) {
      controller.titleController.text = modul.title;
      controller.penulisController.text = modul.penulis;
      controller.deskripsiController.text = modul.deskripsi;
      controller.isiModulController.text = modul.isi_modul;
    } else {
      controller.titleController.clear();
      controller.penulisController.clear();
      controller.deskripsiController.clear();
      controller.isiModulController.clear();
    }

    Get.defaultDialog(
      title: isEditing ? 'Edit Modul' : 'Tambah Modul',
      content: Column(
        children: [
          buildTextField('Judul', controller.titleController),
          buildTextField('Penulis', controller.penulisController),
          buildTextField('Deskripsi', controller.deskripsiController),
          buildTextField('Isi Modul', controller.isiModulController),
        ],
      ),
      textConfirm: 'Simpan',
      onConfirm: () {
        if (isEditing) {
          controller.updateModul(
            modul.id,
            controller.titleController.text,
            controller.penulisController.text,
            controller.deskripsiController.text,
            controller.isiModulController.text,
          );
        } else {
          controller.addModul(
            controller.titleController.text,
            controller.penulisController.text,
            controller.deskripsiController.text,
            controller.isiModulController.text,
          );
        }
        Get.back();
      },
      textCancel: 'Batal',
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: ModulView(),
  ));
}
