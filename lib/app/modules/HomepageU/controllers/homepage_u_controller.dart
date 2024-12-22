import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomepageUController extends GetxController {
  //TODO: Implement HomepageUController

  var currentIndex = 0.obs;
  var name = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData(); // Fetch user data when the controller initializes
  }

  void changePage(int index){
    currentIndex.value = index;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

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
