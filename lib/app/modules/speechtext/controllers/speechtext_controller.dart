import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechtextController extends GetxController {
  //TODO: Implement SpeechtextController

  var isListening = false.obs;
  var recognizedText = ''.obs;
  late stt.SpeechToText _speech;

  @override
  void onInit() {
    super.onInit();
    _speech = stt.SpeechToText();
  }

  Future<void> startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('Status: $status'),
      onError: (error) => print('Error: $error'),
    );
    if (available) {
      isListening.value = true;
      _speech.listen(
        onResult: (result) {
          recognizedText.value = result.recognizedWords;
        },
      );
    } else {
      print("The user has denied the use of speech recognition.");
    }
  }

  void stopListening() {
    _speech.stop();
    isListening.value = false;
  }
}
