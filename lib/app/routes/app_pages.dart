import 'package:get/get.dart';

import '../modules/HomepageA/bindings/homepage_a_binding.dart';
import '../modules/HomepageA/views/homepage_a_view.dart';
import '../modules/HomepageU/bindings/homepage_u_binding.dart';
import '../modules/HomepageU/views/homepage_u_view.dart';
import '../modules/Modul/bindings/modul_binding.dart';
import '../modules/Modul/views/modul_view.dart';
import '../modules/OtpPage/bindings/otp_page_binding.dart';
import '../modules/OtpPage/views/otp_page_view.dart';
import '../modules/Quiz/bindings/quiz_binding.dart';
import '../modules/Quiz/views/quiz_view.dart';
import '../modules/activity/bindings/activity_binding.dart';
import '../modules/activity/views/activity_view.dart';
import '../modules/attendance/bindings/attendance_binding.dart';
import '../modules/attendance/views/attendance_view.dart';
import '../modules/audio/bindings/audio_binding.dart';
import '../modules/audio/views/audio_view.dart';
import '../modules/baca_modul/bindings/baca_modul_binding.dart';
import '../modules/baca_modul/views/baca_modul_view.dart';
import '../modules/biodata/bindings/biodata_binding.dart';
import '../modules/biodata/views/biodata_view.dart';
import '../modules/connection/bindings/connection_binding.dart';
import '../modules/connection/views/connection_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/detail_struktur/bindings/detail_struktur_binding.dart';
import '../modules/detail_struktur/views/detail_struktur_view.dart';
import '../modules/dokumentasi/bindings/dokumentasi_binding.dart';
import '../modules/dokumentasi/views/dokumentasi_view.dart';
import '../modules/foto/bindings/foto_binding.dart';
import '../modules/foto/views/foto_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/jabatan/bindings/jabatan_binding.dart';
import '../modules/jabatan/views/jabatan_view.dart';
import '../modules/jadwal/bindings/jadwal_binding.dart';
import '../modules/jadwal/views/jadwal_view.dart';
import '../modules/jadwal_u/bindings/jadwal_u_binding.dart';
import '../modules/jadwal_u/views/jadwal_u_view.dart';
import '../modules/leaderboard/bindings/leaderboard_binding.dart';
import '../modules/leaderboard/views/leaderboard_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/lokasi/bindings/lokasi_binding.dart';
import '../modules/lokasi/views/lokasi_view.dart';
import '../modules/modul_u/bindings/modul_u_binding.dart';
import '../modules/modul_u/views/modul_u_view.dart';
import '../modules/notifRegistrasi/bindings/notif_registrasi_binding.dart';
import '../modules/notifRegistrasi/views/notif_registrasi_view.dart';
import '../modules/notifikasi/bindings/notifikasi_binding.dart';
import '../modules/notifikasi/views/notifikasi_view.dart';
import '../modules/pertanyaan/bindings/pertanyaan_binding.dart';
import '../modules/pertanyaan/views/pertanyaan_view.dart';
import '../modules/photo/bindings/photo_binding.dart';
import '../modules/photo/views/photo_view.dart';
import '../modules/presensi/bindings/presensi_binding.dart';
import '../modules/presensi/views/presensi_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/quiz_result/bindings/quiz_result_binding.dart';
import '../modules/quiz_result/views/quiz_result_view.dart';
import '../modules/quizuser/bindings/quizuser_binding.dart';
import '../modules/quizuser/views/quizuser_view.dart';
import '../modules/registrasi/bindings/registrasi_binding.dart';
import '../modules/registrasi/views/registrasi_view.dart';
import '../modules/schedule/bindings/schedule_binding.dart';
import '../modules/schedule/views/schedule_view.dart';
import '../modules/speechtext/bindings/speechtext_binding.dart';
import '../modules/speechtext/views/speechtext_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/struktur/bindings/struktur_binding.dart';
import '../modules/struktur/views/struktur_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTRASI,
      page: () => RegistrasiView(),
      binding: RegistrasiBinding(),
    ),
    GetPage(
      name: _Paths.NOTIF_REGISTRASI,
      page: () => const NotifRegistrasiView(),
      binding: NotifRegistrasiBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.HOMEPAGE_A,
      page: () => HomepageAView(),
      binding: HomepageABinding(),
    ),
    GetPage(
      name: _Paths.HOMEPAGE_U,
      page: () => HomepageUView(),
      binding: HomepageUBinding(),
    ),
    GetPage(
      name: _Paths.QUIZ,
      page: () => QuizView(),
      binding: QuizBinding(),
    ),
    GetPage(
      name: _Paths.OTP_PAGE,
      page: () => OtpPageView(),
      binding: OtpPageBinding(),
    ),
    GetPage(
      name: _Paths.PHOTO,
      page: () => PhotoView(),
      binding: PhotoBinding(),
    ),
    GetPage(
      name: _Paths.MODUL,
      page: () => ModulView(),
      binding: ModulBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFIKASI,
      page: () => NotifikasiView(),
      binding: NotifikasiBinding(),
    ),
    GetPage(
      name: _Paths.PRESENSI,
      page: () => PresensiView(),
      binding: PresensiBinding(),
    ),
    GetPage(
      name: _Paths.STRUKTUR,
      page: () => StrukturView(),
      binding: StrukturBinding(),
    ),
    GetPage(
      name: _Paths.JADWAL,
      page: () => JadwalView(),
      binding: JadwalBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.BIODATA,
      page: () => BiodataView(),
      binding: BiodataBinding(),
    ),
    GetPage(
      name: _Paths.LEADERBOARD,
      page: () => LeaderboardView(),
      binding: LeaderboardBinding(),
    ),
    GetPage(
      name: _Paths.SCHEDULE,
      page: () => ScheduleView(),
      binding: ScheduleBinding(),
    ),
    GetPage(
      name: _Paths.JADWAL_U,
      page: () => JadwalUView(),
      binding: JadwalUBinding(),
    ),
    GetPage(
      name: _Paths.ACTIVITY,
      page: () => ActivityView(),
      binding: ActivityBinding(),
    ),
    GetPage(
      name: _Paths.MODUL_U,
      page: () => ModulUView(),
      binding: ModulUBinding(),
    ),
    GetPage(
      name: _Paths.BACA_MODUL,
      page: () => BacaModulView(),
      binding: BacaModulBinding(),
    ),
    GetPage(
      name: _Paths.PERTANYAAN,
      page: () => PertanyaanView(),
      binding: PertanyaanBinding(),
    ),
    GetPage(
      name: _Paths.QUIZ_RESULT,
      page: () => QuizResultView(),
      binding: QuizResultBinding(),
    ),
    GetPage(
      name: _Paths.ATTENDANCE,
      page: () => AttendanceView(),
      binding: AttendanceBinding(),
    ),
    GetPage(
      name: _Paths.JABATAN,
      page: () => JabatanView(),
      binding: JabatanBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_STRUKTUR,
      page: () => DetailStrukturView(),
      binding: DetailStrukturBinding(),
    ),
    GetPage(
      name: _Paths.FOTO,
      page: () => FotoView(),
      binding: FotoBinding(),
    ),
    GetPage(
      name: _Paths.DOKUMENTASI,
      page: () => DokumentasiView(),
      binding: DokumentasiBinding(),
    ),
    GetPage(
      name: _Paths.LOKASI,
      page: () => LokasiView(),
      binding: LokasiBinding(),
    ),
    GetPage(
      name: _Paths.SPEECHTEXT,
      page: () => SpeechtextView(),
      binding: SpeechtextBinding(),
    ),
    GetPage(
      name: _Paths.AUDIO,
      page: () => AudioView(),
      binding: AudioBinding(),
    ),
    GetPage(
      name: _Paths.CONNECTION,
      page: () => const ConnectionView(),
      binding: ConnectionBinding(),
    ),
    GetPage(
      name: _Paths.QUIZUSER,
      page: () => QuizuserView(),
      binding: QuizuserBinding(),
    ),
  ];
}
