import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventData {
  final String day;
  final int count;

  EventData(this.day, this.count);
}

class DashboardController extends GetxController {
  // State for user and leaderboard counts
  var userCount = 0.obs;
  var leaderboardCount = 0.obs;
  // Observable list of EventData for chart
  var eventDataList = <EventData>[].obs;

  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchUserCount(); 
    fetchEventData(); // Fetch event data when the controller initializes
  }

  void fetchEventData() async {
    try {
      // Retrieve documents from the 'events' collection
      QuerySnapshot snapshot = await _firestore.collection('kegiatan').get();

      // Map Firestore documents to EventData objects
      var events = snapshot.docs.map((doc) {
        return EventData(
          doc['day'],        
          doc['count'],      
        );
      }).toList();

      // Update the observable list with event data
      eventDataList.assignAll(events);
    } catch (e) {
      print("Error fetching event data: $e");
    }
  }

  // Method to fetch the user count from Firestore
  void fetchUserCount() async {
    try {
      _firestore.collection('users').snapshots().listen((snapshot) {
        userCount.value = snapshot.docs.length;
      });
    } catch (e) {
      print("Error fetching user count: $e");
    }
  }
}