import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_storage/get_storage.dart';

class AudioController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  var isPlaying = false.obs; // Status audio sedang dimainkan
  var currentDuration = "00:00".obs; // Durasi berjalan
  var totalDuration = "00:00".obs; // Total durasi audio
  var selectedAudio = "pramuka.mp3".obs; // Audio file yang dipilih
  var audioList = <String>[].obs; // Daftar file audio yang bisa diputar
  final box = GetStorage(); // Storage lokal

  // Mengatur event listener untuk mendapatkan durasi
  AudioController() {
    _audioPlayer.onPositionChanged.listen((Duration position) {
      currentDuration.value = _formatDuration(position);
    });

    _audioPlayer.onDurationChanged.listen((Duration duration) {
      totalDuration.value = _formatDuration(duration);
    });

    // Muat daftar audio dari GetStorage
    loadAudioList();
  }


  // Fungsi untuk memutar audio
  Future<void> playAudio() async {
    try {
      if (selectedAudio.value.contains('/')) {
      // Jika file memiliki path (dari File Picker), gunakan DeviceFileSource
        await _audioPlayer.play(DeviceFileSource(selectedAudio.value));
      } else {
      // Jika file adalah aset di dalam aplikasi, gunakan AssetSource
        await _audioPlayer.play(AssetSource(selectedAudio.value));
      }
      isPlaying.value = true;
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  // Fungsi untuk pause audio
  Future<void> pauseAudio() async {
    try {
      await _audioPlayer.pause();
      isPlaying.value = false;
    } catch (e) {
      print("Error pausing audio: $e");
    }
  }

  // Fungsi untuk stop audio
  Future<void> stopAudio() async {
    try {
      await _audioPlayer.stop();
      isPlaying.value = false;
      currentDuration.value = "00:00";
    } catch (e) {
      print("Error stopping audio: $e");
    }
  }

  // Fungsi untuk memilih file audio dan menambahkannya ke daftar
  Future<void> pickAudioFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
      );
      if (result != null) {
        selectedAudio.value = result.files.single.path ?? ""; // Ambil path file
        addAudioToList(selectedAudio.value); // Tambahkan ke daftar
        print("Selected file: ${selectedAudio.value}");
      } else {
        print("File selection canceled.");
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  // Tambahkan file audio ke daftar dan simpan ke storage
  void addAudioToList(String filePath) {
    if (!audioList.contains(filePath)) {
      audioList.add(filePath);
      saveAudioList();
    }
  }

  // Hapus audio dari daftar
  void removeAudioFromList(String filePath) {
    audioList.remove(filePath);
    saveAudioList();
  }

  // Simpan daftar audio ke GetStorage
  void saveAudioList() {
    box.write("audioList", audioList);
  }

  // Muat daftar audio dari GetStorage
  // Muat daftar audio dari GetStorage
  void loadAudioList() {
    try {
      List<dynamic>? storedList = box.read<List<dynamic>>("audioList");
      if (storedList != null) {
        audioList.assignAll(storedList.cast<String>());
      }
    } catch (e) {
      print("Error loading audio list: $e");
    }
  }


  // Format durasi menjadi MM:SS
  String _formatDuration(Duration duration) {
    String minutes = duration.inMinutes.toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void onClose() {
    _audioPlayer.dispose(); // Membersihkan resources
    super.onClose();
  }
}
