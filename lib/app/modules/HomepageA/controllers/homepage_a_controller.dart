import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomepageAController extends GetxController {
  var currentIndex = 0.obs;
  var name = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData(); // Fetch user data when the controller initializes
  }

  void changePage(int index) {
    currentIndex.value = index;
  }
  

  // Fetches user data from Firestore
  void fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        name.value = userDoc.data()?['name'] ?? 'Guest';
      }
    }
  }
}
