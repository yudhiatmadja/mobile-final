import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class LokasiController extends GetxController {
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var weatherInfo = ''.obs; // Informasi cuaca

  final String apiKey = '1dec40ba9cadb24fd166785edc28025f'; // Ganti dengan API key dari OpenWeatherMap

  // Fungsi untuk mendapatkan lokasi
  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Cek apakah service lokasi diaktifkan
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("Error", "Location services are disabled.");
      return;
    }

    // Cek izin lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("Error", "Location permissions are denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("Error", "Location permissions are permanently denied.");
      return;
    }

    // Dapatkan lokasi terkini
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    latitude.value = position.latitude;
    longitude.value = position.longitude;

    // Setelah lokasi diperoleh, ambil data cuaca
    await fetchWeather();
  }

  // Fungsi untuk mengambil data cuaca
  Future<void> fetchWeather() async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=${latitude.value}&lon=${longitude.value}&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final description = data['weather'][0]['description'];
        final temp = data['main']['temp'];
        weatherInfo.value = 'Cuaca: $description, Suhu: $temp°C';
      } else {
        Get.snackbar("Error", "Failed to fetch weather data.");
      }
    } catch (e) {
      Get.snackbar("Error", "Error fetching weather: ${e.toString()}");
    }
  }

  // Fungsi untuk membuka lokasi di Google Maps
  Future<void> openGoogleMaps() async {
    Uri googleMapsUrl = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=${latitude.value},${longitude.value}");
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "Could not open Google Maps.");
    }
  }
}
