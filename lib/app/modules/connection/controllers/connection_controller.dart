import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile/app/routes/app_pages.dart';
import '../views/connection_view.dart';

class ConnectionController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GetStorage getStorage = GetStorage();

  @override
  void onInit() {
    super.onInit();

    // Pantau perubahan koneksi
    _connectivity.onConnectivityChanged.listen((connectivityResults) {
      _updateConnectionStatus(connectivityResults.first);
    });
  }

  // Fungsi untuk mengupdate status koneksi
  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      // Tidak ada koneksi
      Get.offAll(() => const ConnectionView());
    } else {
      // Ada koneksi, navigasikan berdasarkan role
      if (Get.currentRoute == '/ConnectionView') {
        _navigateBasedOnRole();
      }
    }
  }

  Future<void> _navigateBasedOnRole() async {
    try {
      // Ambil userId dari GetStorage (misalnya disimpan setelah login)
      String? userId = getStorage.read('userId');
      if (userId == null) {
        throw Exception("User ID tidak ditemukan. Harap login kembali.");
      }

      // Ambil peran pengguna dari Firestore
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists && userDoc['role'] != null) {
        String role = userDoc['role'];

        // Simpan status login dan role ke GetStorage
        getStorage.write("status", "login");
        getStorage.write("role", role);

        // Navigasi berdasarkan role
        if (role == "admin") {
          Get.offAllNamed(Routes.HOMEPAGE_A); // Halaman admin
        } else if (role == "user") {
          Get.offAllNamed(Routes.HOMEPAGE_U); // Halaman user
        } else {
          throw Exception("Peran pengguna tidak valid.");
        }
      } else {
        throw Exception("Dokumen pengguna tidak valid atau peran tidak ditemukan.");
      }
    } catch (e) {
      // Tampilkan pesan error menggunakan GetSnackbar
      Get.snackbar(
        "Error",
        "Gagal mendapatkan peran pengguna: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
