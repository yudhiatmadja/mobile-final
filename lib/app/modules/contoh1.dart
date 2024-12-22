// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import '../controllers/foto_controller.dart';

// class FotoView extends GetView<FotoController> {
//   final FotoController controller = Get.put(FotoController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFF009D44), // Warna hijau pada AppBar
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Get.back(); // Kembali ke halaman sebelumnya
//           },
//         ),
//       ),
//       backgroundColor: Color(0xFFEDE1D0),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "Upload File or Take Photo",
//                 style: TextStyle(
//                   fontSize: 20.0,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               SizedBox(height: 30.0),

//               // Display selected photo or default icon
//               Obx(() => CircleAvatar(
//                     radius: 60.0,
//                     backgroundColor: Colors.grey.shade200,
//                     backgroundImage: controller.selectedImagePath.value != ''
//                         ? FileImage(File(controller.selectedImagePath.value))
//                         : null,
//                     child: controller.selectedImagePath.value == ''
//                         ? Icon(
//                             Icons.person_outline,
//                             size: 60.0,
//                             color: Colors.black,
//                           )
//                         : null,
//               )),

//               SizedBox(height: 20.0),

//               // Take Photo and Upload Photo buttons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () async {
//                       await controller.pickImage(ImageSource.camera);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xFF009D44), // Hijau
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                     ),
//                     child: Text(
//                       "Take Photo",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16.0,
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 10.0),
//                   OutlinedButton(
//                     onPressed: () async {
//                       await controller.pickImage(ImageSource.gallery);
//                     },
//                     style: OutlinedButton.styleFrom(
//                       side: BorderSide(color: Color(0xFF009D44)),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                     ),
//                     child: Text(
//                       "Upload Photo",
//                       style: TextStyle(
//                         color: Color(0xFF009D44),
//                         fontSize: 16.0,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 30.0),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await GetStorage.init();// Pastikan Firebase terinisialisasi
//   runApp(GetMaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: FotoView(),
//   ));
// }

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get_storage/get_storage.dart';

// class FotoController extends GetxController {
//   var selectedImage = Rx<File?>(null);
//   final ImagePicker _picker = ImagePicker();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final box = GetStorage();

//   var selectedImagePath = ''.obs;
//   var isImageLoading = false.obs;
//   var isConnected = true.obs;
//   var isUploading = false.obs;
//   var uploadQueue = <Map<String, dynamic>>[].obs;

//   @override
//   void onInit() {
//     super.onInit();

//     // Pantau perubahan status koneksi
//     ever(isConnected, (bool connected) {
//       if (connected) {
//         Get.snackbar(
//           "Koneksi Tersambung",
//           "Aplikasi sekarang terhubung ke internet.",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//           duration: const Duration(seconds: 3),
//         );
//         uploadPendingData(); // Coba upload data pending
//       } else {
//         Get.snackbar(
//           "Koneksi Terputus",
//           "Aplikasi tidak terhubung ke internet.",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//           duration: const Duration(seconds: 3),
//         );
//       }
//     });


//     // Muat antrian unggahan dari GetStorage
//     loadUploadQueue();

//     // Jika koneksi tersambung, unggah data pending
//     ever(isConnected, (connected) {
//       if (connected) {
//         uploadPendingData();
//       }
//     });
//   }

//   Future<void> pickImage(ImageSource source) async {
//     try {
//       isImageLoading.value = true;
//       final XFile? pickedFile = await _picker.pickImage(source: source);
//       if (pickedFile != null) {
//         selectedImagePath.value = pickedFile.path;
//         selectedImage.value = File(pickedFile.path);
//         await uploadData(type: "image", filePath: pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     } catch (e) {
//       print('Error picking image: $e');
//     } finally {
//       isImageLoading.value = false;
//     }
//   }

//   void addDataToQueue(Map<String, dynamic> data) {
//     uploadQueue.add(data);
//     saveUploadQueue();
//   }

//   void saveUploadQueue() {
//     box.write("uploadQueue", uploadQueue.toList());
//   }

//   void loadUploadQueue() {
//     List<dynamic>? storedQueue = box.read<List<dynamic>>("uploadQueue");
//     if (storedQueue != null) {
//       uploadQueue.assignAll(storedQueue.cast<Map<String, dynamic>>());
//     }
//   }

//   void removeDataFromQueue(Map<String, dynamic> data) {
//     uploadQueue.remove(data);
//     saveUploadQueue();
//   }

//   Future<void> uploadData({required String type, required String filePath}) async {
//     Map<String, dynamic> data = {
//       'type': type,
//       'filePath': filePath,
//       'timestamp': FieldValue.serverTimestamp(),
//     };

//     if (isConnected.value) {
//       isUploading.value = true;
//       try {
//         if (!File(filePath).existsSync()) {
//           print("File does not exist at path: $filePath");
//           return;
//         }
//         await _firestore.collection('images').add(data);
//         print("Data uploaded successfully: $data");
//       } catch (e) {
//         print("Upload failed, adding to queue: $e");
//         addDataToQueue(data);
//       } finally {
//         isUploading.value = false;
//       }
//     } else {
//       print("No connection, adding data to queue.");
//       addDataToQueue(data);
//     }
//   }

//   Future<void> uploadPendingData() async {
//     if (uploadQueue.isEmpty) return;

//     isUploading.value = true;
//     for (var data in List.from(uploadQueue)) {
//       try {
//         await _firestore.collection('images').add(data);
//         removeDataFromQueue(data);
//         print("Pending data uploaded successfully: $data");
//       } catch (e) {
//         print("Failed to upload pending data: $e");
//       }
//     }
//     isUploading.value = false;
//   }

//   void resetMedia() {
//     selectedImage.value = null;
//     selectedImagePath.value = '';
//   }
// }

//  Widget _buildUploadedMediaTab(BuildContext context) {
//   // Panggil fungsi fetchUploadedMedia saat tab ini dibuka
//     controller.fetchUploadedMedia();

//     return Obx(() {
//       if (controller.uploadedMedia.isEmpty) {
//         return const Center(
//           child: Text(
//             "Tidak ada media yang diunggah.",
//             style: TextStyle(fontSize: 16),
//           ),
//         );
//       }

//       return ListView.builder(
//         itemCount: controller.uploadedMedia.length,
//         itemBuilder: (context, index) {
//           final media = controller.uploadedMedia[index];
//           final isImage = media['type'] == "image";

//           return Card(
//             margin: const EdgeInsets.all(8.0),
//             child: ListTile(
//               leading: SizedBox(
//                 width: 50,
//                 height: 50,
//                 child: isImage
//                     ? Image.file(
//                         File(media['filePath']),
//                         fit: BoxFit.cover,
//                       )
//                     : const Icon(Icons.video_library, color: Colors.green),
//               ),
//               title: Text(
//                 "${media['type']} - ${media['filePath']}",
//                 style: const TextStyle(fontSize: 14),
//               ),
//               subtitle: Text(
//                 "Timestamp: ${media['timestamp'] ?? 'N/A'}",
//                 style: const TextStyle(fontSize: 12),
//               ),
//             ),
//           );
//         },
//       );
//     });
//   }



