import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/speechtext_controller.dart';

class SpeechtextView extends GetView<SpeechtextController> {
  final SpeechtextController _speechController = Get.put(SpeechtextController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Materi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
     body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() => Text(
                _speechController.recognizedText.value,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              )),
              SizedBox(height: 20),
              Obx(() => ElevatedButton(
                onPressed: _speechController.isListening.value
                    ? _speechController.stopListening
                    : _speechController.startListening,
                    child: Text(_speechController.isListening.value
                      ? 'Stop Listening'
                      : 'Start Listening'),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

void main() async{
  await GetStorage.init();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SpeechtextView(),
    ),
  );
}


