import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/activity_controller.dart';

class ActivityView extends GetView<ActivityController> {
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kegiatan 1'),
        backgroundColor: Colors.green,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back), 
          onPressed: (){
            Get.back();
          },
        ),
      ),
      backgroundColor: Color(0xFFEDE1D0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 75,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Image.asset(
                  'assets/hizbul.JPG', // Replace with your asset path or Network image
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                "Hizbul Wathan adalah organisasi kepanduan yang berperan penting dalam membentuk karakter dan jiwa kepemimpinan pada generasi muda. Melalui berbagai kegiatan, Hizbul Wathan menanamkan nilai-nilai kebersamaan, tanggung jawab, dan cinta tanah air.",
                style: TextStyle(
                  fontSize: 8.0,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 5.0),
              Text(
                "Kegiatan ini bertujuan untuk melatih keterampilan dan meningkatkan jiwa nasionalisme para anggota Hizbul Wathan. Dengan semangat gotong royong, para anggota dilatih untuk menjadi pemimpin yang tangguh dan berintegritas.",
                style: TextStyle(
                  fontSize: 8.0,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 5.0),
              Text(
                "Di bawah bimbingan para pelatih, para anggota Hizbul Wathan mengikuti serangkaian latihan fisik dan mental yang terstruktur. Mereka diajarkan untuk memiliki kedisiplinan tinggi serta ketangguhan dalam menghadapi berbagai tantangan.",
                style: TextStyle(
                  fontSize: 8.0,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 5.0),
              Text(
                "Semoga kegiatan ini dapat memberikan manfaat yang besar bagi para peserta dan mengukuhkan komitmen Hizbul Wathan dalam membangun generasi muda yang berkualitas.",
                style: TextStyle(
                  fontSize: 8.0,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: Size(double.infinity, 25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                onPressed: () {
                  // Handle attendance logic
                },
                child: Text(
                  'Absen',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 5.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(double.infinity, 25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                onPressed: () {
                  // Handle certificate logic
                },
                child: Text(
                  'Sertifikat',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: ActivityView(),
  ));
}
