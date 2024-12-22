import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/audio_controller.dart';

class AudioView extends StatelessWidget {
  final AudioController audioController = Get.put(AudioController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.top,
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Materi",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Container(
        color: Colors.lightGreen[50],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Modul Pramuka',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Obx(() => Text(
                  "${audioController.currentDuration.value} / ${audioController.totalDuration.value}",
                  style: const TextStyle(fontSize: 20.0),
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: audioController.pickAudioFile,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("Pilih File Audio"),
            ),
            const SizedBox(height: 20),
            const Text(
              "Daftar Audio",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: audioController.audioList.length,
                    itemBuilder: (context, index) {
                      String audio = audioController.audioList[index];
                      return ListTile(
                        title: Text(audio.split('/').last),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            audioController.removeAudioFromList(audio);
                          },
                        ),
                        onTap: () {
                          audioController.selectedAudio.value = audio;
                          audioController.playAudio();
                        },
                      );
                    },
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.play_arrow),
                  iconSize: 40,
                  color: Colors.green,
                  onPressed: audioController.playAudio,
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.pause),
                  iconSize: 40,
                  color: Colors.orange,
                  onPressed: audioController.pauseAudio,
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.stop),
                  iconSize: 40,
                  color: Colors.red,
                  onPressed: audioController.stopAudio,
                ),
              ],
            ),
          ],
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
      home: AudioView(),
    ),
  );
}

