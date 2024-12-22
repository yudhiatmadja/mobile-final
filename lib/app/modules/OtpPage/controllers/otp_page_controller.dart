import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class OtpPageController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RxString phoneNumber = ''.obs; // Observable untuk menyimpan nomor telepon
  String verificationId = '';

  @override
  void onInit() {
    super.onInit();
    fetchPhoneNumber();
  }

  Future<void> fetchPhoneNumber() async {
    try {
      // Mendapatkan UID pengguna yang sedang Register
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        // Mengambil data pengguna dari Firestore berdasarkan UID
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
        
        if (userDoc.exists && userDoc['phone_number'] != null) {
          phoneNumber.value = userDoc['phone_number'];
          await sendOtp(phoneNumber.value);
        } else {
          Get.snackbar('Error', 'Nomor telepon tidak ditemukan.');
        }
      } else {
        Get.snackbar('Error', 'User tidak terdeteksi.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil nomor telepon: ${e.toString()}');
    }
  }

  Future<void> sendOtp(String phone) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(minutes: 2),
      verificationCompleted: (PhoneAuthCredential credential) {
        // Opsi auto-resolving OTP jika diinginkan
      },
      verificationFailed: (FirebaseAuthException e) {
        Get.snackbar('Error', 'Gagal mengirim OTP: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        this.verificationId = verificationId;
        Get.snackbar('Info', 'Kode OTP telah dikirim ke nomor $phone.');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        this.verificationId = verificationId;
      },
    );
  }

  Future<void> resendOtp() async {
    if (phoneNumber.isNotEmpty) {
      await sendOtp(phoneNumber.value);  // Kirim ulang OTP
    } else {
      Get.snackbar('Error', 'Nomor telepon tidak valid.');
    }
  }
}
