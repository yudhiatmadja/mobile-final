import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile/firebase_options.dart';
import '../controllers/otp_page_controller.dart';
import 'package:mobile/app/routes/app_pages.dart';

class OtpPageView extends StatefulWidget {
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPageView> {
  final TextEditingController otpController = TextEditingController();
  final OtpPageController controller = Get.put(OtpPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDE1D0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Section
            Image.asset(
              'assets/logo.png', // Update the logo path
              height: 150,
            ),
            SizedBox(height: 30.0),

            // OTP Title
            Text(
              'Enter OTP',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20.0),

            // OTP Info and Phone Number from Firestore
            Text(
              'An OTP has been sent to',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black54,
              ),
            ),
            Obx(() => Text(
                  controller.phoneNumber.value.isEmpty
                      ? 'Loading...'
                      : controller.phoneNumber.value,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )),
            SizedBox(height: 30.0),

            // OTP Input Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      onChanged: (value) {
                        if (value.length == 1 && index < 3) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 20.0),

            // Link to Request OTP Again
            GestureDetector(
              onTap: () {
                // Action to request OTP again
              },
              child: Text(
                "Didn't get code?",
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black54,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // Action to request OTP again
              },
              child: Text(
                "Request again",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 30.0),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                // Action to submit OTP
                Get.toNamed(Routes.NOTIF_REGISTRASI);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF009944),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Submit',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: OtpPageView(),
    getPages: AppPages.routes,
  ));
}
