import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/app/routes/app_pages.dart';

class RegistrasiController extends GetxController {
  // Instance FirebaseAuth dan Firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Rx untuk menyimpan informasi pengguna
  var email = ''.obs;
  var name = ''.obs;
  var phoneNumber = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var role = 'user'.obs; // Default role adalah 'user'

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> register() async {
    // Validasi input
    if (name.value.isEmpty || email.value.isEmpty || phoneNumber.value.isEmpty || password.value.isEmpty || confirmPassword.value.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (password.value != confirmPassword.value) {
      Get.snackbar('Error', 'Passwords do not match', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      // Registrasi dengan email dan password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );

      String uid = userCredential.user!.uid;


      // Simpan data pengguna ke Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'email': email.value,
        'name': name.value,
        'phone_number': phoneNumber.value,
        'role': role.value, // Menyimpan role
        'created_at': FieldValue.serverTimestamp(),
        'password' : password.value,
      });

      // Navigasi ke halaman OTP (atau halaman berikutnya yang diinginkan)
      Get.offAllNamed(Routes.OTP_PAGE);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'An unknown error occurred', snackPosition: SnackPosition.BOTTOM);
   
    }
  }
}