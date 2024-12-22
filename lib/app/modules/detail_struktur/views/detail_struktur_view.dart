import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/detail_struktur_controller.dart';

class DetailStrukturView extends GetView<DetailStrukturController> {
  final DetailStrukturController controller = Get.put(DetailStrukturController());

  @override
  Widget build(BuildContext context) {
    // Mendapatkan ID dari argument yang dikirim dari halaman sebelumnya
    final String id = Get.arguments ?? 'default_id';

    // Memanggil fetchStrukturDetail untuk mengambil data
    controller.fetchStrukturDetail(id);

    return Scaffold(
      appBar: AppBar(
        title: Text('Struktur'),
        backgroundColor: Colors.green,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Obx(() {
        // Jika data belum tersedia
        if (controller.selectedStruktur.value == null) {
          return Center(child: CircularProgressIndicator());
        }

        // Mendapatkan data Struktur dari selectedStruktur
        final struktur = controller.selectedStruktur.value!;

        return Container(
          color: Color(0xFFEDE1D0),
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/hizbul.JPG', // Ganti dengan URL gambar aktual
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.lightGreen[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nama : ${struktur.nama}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Divider(),
                    Text(
                      'Jabatan : ${struktur.jabatan}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Divider(),
                    Text(
                      'Periode : ${struktur.periode}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Divider(),
                    SizedBox(height: 10),
                    Text(
                      'Tugas',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      struktur.tugas,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: DetailStrukturView(),
  ));
}
