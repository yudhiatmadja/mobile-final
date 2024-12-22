import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var name = ''.obs;
  var email = ''.obs;
  var phone_number = ''.obs;

  @override
  void onReady() {
    super.onReady();
    fetchUserProfile();
  }

  void fetchUserProfile() async {
    User? user = _auth.currentUser;
    if (user == null) {
      print("User is not logged in");
      return;
    }
    print("Fetching profile for user ID: ${user.uid}");
    
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
    if (userDoc.exists) {
      var data = userDoc.data() as Map<String, dynamic>;
      name.value = data['name'] ?? '';
      email.value = data['email'] ?? '';
      phone_number.value = data['phone_number'] ?? '';
    }
  }

  Future<void> updateUserProfile({String? newname, String? newphonenumber}) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': newname ?? name.value,
          'phone_number': newphonenumber ?? phone_number.value,
        }, SetOptions(merge: true));
        
        if (newname != null) name.value = newname;
        if (newphonenumber != null) phone_number.value = newphonenumber;
      }
    } catch (e) {
      print("Error updating user profile: $e");
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }
}