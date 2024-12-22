import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile/app/modules/dokumentasi/controllers/dokumentasi_controller.dart';
import 'package:mobile/firebase_options.dart';
import 'package:video_player/video_player.dart';

class DokumentasiView extends GetView<DokumentasiController> {
  final DokumentasiController controller = Get.put(DokumentasiController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.top,
      ],
    );
    return DefaultTabController(
      length: 4, // Jumlah tab
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text(
            'Dokumentasi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: "Foto"),
              Tab(text: "Video"),
              Tab(text: "Lainnya"),
              Tab(text: "Media Diunggah"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFotoTab(context),
            _buildVideoTab(context),
            _buildPendingTab(context),
            _buildUploadedMediaTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFotoTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Obx(() {
              return GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                children: [
                  if (controller.selectedImage.value != null)
                    _buildDokumentasiItem(
                      "Foto Terpilih",
                      "Gambar yang dipilih atau diambil",
                      null,
                      isCustomImage: true,
                      customImage: controller.selectedImage.value,
                    ),
                ],
              );
            }),
          ),
          const SizedBox(height: 20),
          Obx(() => controller.isUploading.value
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () => _showImageSourceDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Ambil Foto",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                )),
        ],
      ),
    );
  }

  Widget _buildVideoTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Obx(() {
              return GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                children: [
                  if (controller.selectedVideo.value != null)
                    _buildDokumentasiItem(
                      "Video Terpilih",
                      "Video yang dipilih atau diambil",
                      null,
                      isCustomImage: false,
                      customImage: controller.selectedVideo.value,
                      isVideo: true,
                    ),
                ],
              );
            }),
          ),
          const SizedBox(height: 20),
          Obx(() => controller.isUploading.value
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () => _showVideoSourceDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Ambil Video",
                    style: TextStyle(fontSize: 16),
                  ),
                )),
        ],
      ),
    );
  }

  Widget _buildPendingTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Obx(() {
        if (controller.uploadQueue.isEmpty) {
          return const Center(
            child: Text(
              "Tidak ada data",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.uploadQueue.length,
          itemBuilder: (context, index) {
            final data = controller.uploadQueue[index];
            return Card(
              child:  ListTile(
                leading: SizedBox(
                  width: 50, // Atur lebar tetap
                  height: 50, // Atur tinggi tetap
                  child: Icon(
                    data['type'] == "image" ? Icons.image : Icons.video_library,
                    color: Colors.green,
                  ),
                ),
                title: Text("${data['type']} - ${data['filePath']}"),
                subtitle: Text("Path: ${data['filePath']}"),
                trailing: IconButton(
                  onPressed: (){
                    controller.deletePendingData(index);
                  }, 
                  icon: Icon(Icons.delete, color: Colors.red)),
            ),
            );
          },
        );
      }),
    );
  }

  Widget _buildDokumentasiItem(String title, String description, String? imageUrl,
      {bool isCustomImage = false, File? customImage, bool isVideo = false}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: isVideo
                  ? customImage != null
                      ? VideoPlayerWidget(videoFile: customImage)
                      : const Icon(Icons.video_library, size: 100)
                  : isCustomImage && customImage != null
                      ? Image.file(
                          customImage,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : imageUrl != null
                          ? Image.asset(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : const Icon(Icons.image, size: 100),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pilih Sumber Gambar"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text("Kamera"),
                onTap: () {
                  Get.back();
                  controller.ambilFotoDariKamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Galeri"),
                onTap: () {
                  Get.back();
                  controller.ambilFotoDariGaleri();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showVideoSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pilih Sumber Video"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text("Kamera"),
                onTap: () {
                  Get.back();
                  controller.ambilVideoDariKamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.video_library),
                title: const Text("Galeri"),
                onTap: () {
                  Get.back();
                  controller.ambilVideoDariGaleri();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUploadedMediaTab(BuildContext context) {
  // Panggil fungsi fetchUploadedMedia saat tab ini dibuka
  controller.fetchUploadedMedia();

  return Obx(() {
    if (controller.uploadedMedia.isEmpty) {
      return const Center(
        child: Text(
          "Tidak ada media yang diunggah.",
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Jumlah kolom
        crossAxisSpacing: 8.0, // Jarak horizontal antar kolom
        mainAxisSpacing: 8.0, // Jarak vertikal antar baris
        childAspectRatio: 1, // Rasio lebar dan tinggi dari setiap item
      ),
      itemCount: controller.uploadedMedia.length,
      itemBuilder: (context, index) {
        final media = controller.uploadedMedia[index];
        final isImage = media['type'] == "image";

        return Card(
          margin: EdgeInsets.zero, // Hilangkan margin agar GridView lebih rapat
          child: isImage
              ? Image.file(
                  File(media['filePath']),
                  fit: BoxFit.cover,
                )
              : const Icon(Icons.video_library, color: Colors.green),
        );
      },
    );
  });
}

}

class VideoPlayerWidget extends StatefulWidget {
  final File videoFile;
  const VideoPlayerWidget({Key? key, required this.videoFile}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          _controller.value.isPlaying
              ? _controller.pause()
              : _controller.play();
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
      ),
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
    home: DokumentasiView(),
  ));
}
