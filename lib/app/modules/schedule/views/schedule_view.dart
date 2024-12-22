import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mobile/app/modules/activity/views/activity_view.dart';

import '../controllers/schedule_controller.dart';

class ScheduleItem {
  final String title;
  final String date;
  final String time;

  ScheduleItem({
    required this.title,
    required this.date,
    required this.time,
  });
}


class ScheduleView extends StatelessWidget {
  final ScheduleController scheduleController = Get.put(ScheduleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Top date selector
          Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            color: Colors.green[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDateItem(context, 3, 'Wed'),
                _buildDateItem(context, 4, 'Thu'),
                _buildDateItem(context, 5, 'Fri'),
                _buildDateItem(context, 6, 'Sat'),
              ],
            ),
          ),
          // Button row for "Now" and "Comingsoon"
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    scheduleController.changeDate(DateTime.now());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: Text('Now'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: Text('Comingsoon'),
                ),
              ],
            ),
          ),
          // Schedule items list
          Expanded(
            child: Obx(() {
              var schedule = scheduleController.filteredSchedule;
              return ListView.builder(
                itemCount: schedule.length,
                itemBuilder: (context, index) {
                  return _buildScheduleItem(schedule[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDateItem(BuildContext context, int day, String weekday) {
    var currentDate = DateTime(2024, 10, day);
    return Obx(() {
      return GestureDetector(
        onTap: () {
          scheduleController.changeDate(currentDate);
        },
        child: Container(
          width: 50,
          height: 80,
          decoration: BoxDecoration(
            color: scheduleController.selectedDate.value == currentDate
                ? Colors.black
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$day',
                style: TextStyle(
                  color: scheduleController.selectedDate.value == currentDate
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                weekday,
                style: TextStyle(
                  color: scheduleController.selectedDate.value == currentDate
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildScheduleItem(ScheduleItem item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.time, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.image, size: 50, color: Colors.grey),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Date: ${item.date}'),
                  ],
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Get.offAll(() => ActivityView());
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  child: Text('View'),
                ),
                SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {},
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: ScheduleView(),
  ));
}

