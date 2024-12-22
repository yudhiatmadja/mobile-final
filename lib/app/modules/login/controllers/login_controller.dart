import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:mobile/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final getStorage = GetStorage();

  Future<void> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Dapatkan peran pengguna dan arahkan ke halaman yang sesuai
      await _navigateBasedOnRole(userCredential.user!.uid);
    } catch (e) {
      Get.snackbar(
        "Login Gagal",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      UserCredential userCredential = await _auth.signInWithPopup(googleProvider);

      // Dapatkan peran pengguna dan arahkan ke halaman yang sesuai
      await _navigateBasedOnRole(userCredential.user!.uid);
    } catch (e) {
      Get.snackbar(
        "Login Gagal",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _navigateBasedOnRole(String userId) async {
    try {
      // Ambil peran pengguna dari Firestore
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();

      // Cek jika dokumen pengguna ada dan memiliki field "role"
      if (userDoc.exists && userDoc['role'] != null) {
        String role = userDoc['role'];

        // Simpan status login dan peran di GetStorage
        getStorage.write("status", "login");
        getStorage.write("role", role);
        getStorage.write('userId', userId);

        // Arahkan ke halaman berdasarkan peran
        if (role == "admin") {
          Get.offAllNamed(Routes.HOMEPAGE_A);  // Rute ke halaman admin
        } else if (role == "user") {
          Get.offAllNamed(Routes.HOMEPAGE_U);   // Rute ke halaman user
        }
      } else {
        throw Exception("Peran pengguna tidak ditemukan.");
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal mendapatkan peran pengguna: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> resetPassword(String email) async {
  try {
    await _auth.sendPasswordResetEmail(email: email);
    Get.snackbar(
      "Success",
      "Password reset email sent. Please check your inbox.",
      snackPosition: SnackPosition.BOTTOM,
    );
  } catch (e) {
    Get.snackbar(
      "Error",
      "Failed to send password reset email: ${e.toString()}",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

  void logout() async {
    await _auth.signOut();
    getStorage.remove("status");
    getStorage.remove("role");
    Get.offAllNamed(Routes.LOGIN);
  }
}
