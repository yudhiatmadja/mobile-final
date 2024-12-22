import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mobile/app/modules/presensi/controllers/presensi.dart';
import 'package:mobile/app/modules/presensi/controllers/presensi_controller.dart';
import 'package:mobile/firebase_options.dart';

class PresensiView extends StatelessWidget {
  final PresensiController controller = Get.put(PresensiController());
  final TextEditingController namaController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Presensi"),
        backgroundColor: Colors.green,
      ),
      body: Obx(() => ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: controller.presensiList.length,
        itemBuilder: (context, index) {
          final presensi = controller.presensiList[index];
          return Card(
            color: Colors.green.shade50,
            margin: EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              leading: CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: Icon(Icons.person, color: Colors.grey.shade700),
              ),
              title: Text(
                presensi.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text(DateFormat('dd-MM-yyyy').format(presensi.date)),
                  SizedBox(height: 5),
                  Text("Keterangan: ${presensi.keterangan.isNotEmpty ? presensi.keterangan : '-'}"),
                ],
              ),
              trailing: Wrap(
                spacing: 12,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => controller.deletePresensi(presensi.id),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.grey),
                    onPressed: () => showEditDialog(context, presensi),
                  ),
                  Checkbox(
                    value: presensi.status,
                    onChanged: (value) {
                      controller.updatePresensi(
                        Presensi(
                          id: presensi.id, 
                          name: presensi.name, 
                          status: value!, 
                          keterangan: presensi.keterangan, 
                          date: presensi.date,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  void showEditDialog(BuildContext context, Presensi presensi) {
    namaController.text = presensi.name;
    dateController.text = DateFormat('dd-MM-yyyy').format(presensi.date);
    keteranganController.text = presensi.keterangan;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return buildDialog(context, 'Edit Presensi', onSave: () {
          controller.updatePresensi(Presensi(
            id: presensi.id,
            name: namaController.text,
            status: presensi.status,
            keterangan: keteranganController.text,
            date: DateFormat('dd-MM-yyyy').parse(dateController.text),
          ));
          Get.back();
        });
      },
    );
  }

  void showAddDialog(BuildContext context) {
    namaController.clear();
    dateController.clear();
    keteranganController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return buildDialog(context, 'Add New Presensi', onSave: () {
          controller.addPresensi(Presensi(
            id: '',
            name: namaController.text,
            status: false,
            keterangan: keteranganController.text,
            date: DateFormat('dd-MM-yyyy').parse(dateController.text),
          ));
          Get.back();
        });
      },
    );
  }

  Widget buildDialog(BuildContext context, String title, {required VoidCallback onSave}) {
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: namaController, decoration: InputDecoration(labelText: 'Name')),
          TextField(
            controller: dateController,
            decoration: InputDecoration(labelText: 'Date'),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
              }
            },
          ),
          TextField(controller: keteranganController, decoration: InputDecoration(labelText: 'Keterangan')),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
        TextButton(onPressed: onSave, child: Text('Save')),
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
    home: PresensiView(),
  ));
}
