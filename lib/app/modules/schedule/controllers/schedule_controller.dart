import 'package:get/get.dart';
import 'package:mobile/app/modules/schedule/views/schedule_view.dart';

class ScheduleController extends GetxController {
  //TODO: Implement ScheduleController

  final count = 0.obs;
  var selectedDate = DateTime.now().obs;

  // Sample schedule list
  var scheduleList = <ScheduleItem>[
    ScheduleItem(title: "Kegiatan 1", date: "2024-10-03", time: "09:00 AM"),
    ScheduleItem(title: "Kegiatan 2", date: "2024-10-04", time: "12:00 PM"),
  ].obs;

  // Filtered schedule based on the selected date
  List<ScheduleItem> get filteredSchedule {
    return scheduleList.where((item) {
      return item.date == selectedDate.value.toString().substring(0, 10);
    }).toList();
  }

  // Function to change the selected date
  void changeDate(DateTime date) {
    selectedDate.value = date;
  }


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

  void increment() => count.value++;
}
