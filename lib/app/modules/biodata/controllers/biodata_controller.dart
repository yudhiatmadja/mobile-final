import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class Biodata {
  final String title;
  final String imagePath;

  Biodata(this.title, this.imagePath);
}

class BiodataController extends GetxController {
  var biodataList = <Biodata>[].obs;
  
  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchAllUsers(); // Fetch all users when the controller initializes
  }

  // Method to fetch all users from Firestore and add them to the biodataList
  void fetchAllUsers() async {
    try {
      // Get all documents from the 'users' collection
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      biodataList.clear(); // Clear the list to avoid duplicates on reload

      // Loop through each document and add it to the biodataList
      for (var doc in snapshot.docs) {
        String userName = doc['name'] ?? 'Unnamed'; // Get the user's name
        String profileImage = 'assets/logo.jpg'; // Placeholder image path
        
        // Add each user to the biodataList
        biodataList.add(Biodata(userName, profileImage));
      }
    } catch (e) {
      print("Error fetching users: $e");
    }
  }
}
