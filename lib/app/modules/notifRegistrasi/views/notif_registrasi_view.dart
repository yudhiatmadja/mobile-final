import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mobile/app/routes/app_pages.dart';

import '../controllers/notif_registrasi_controller.dart';

class NotifRegistrasiView extends GetView<NotifRegistrasiController> {
  const NotifRegistrasiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDE1D0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/logo.png",
            width: MediaQuery.of(context).size.width/2),
            SizedBox(height: 30.0),
            Text(
              "Registration Successful!",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            Icon(Icons.check_circle_outline,
            color: Color(0xFF009D44),
            size: 100.0
            ),
            SizedBox(height: 20.0),
            Text(
              "You will be redirected to the login in 5 seconds...",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.0),
            GestureDetector(
              onTap: (){
                Get.offAllNamed(Routes.LOGIN);
              },
              child: RichText(text: TextSpan(
                text: "Click",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 14.0,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: " here",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(
                    text: "    if you are not redirected automatically",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}

void main(){
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: NotifRegistrasiView(),
    getPages: AppPages.routes,
  ));
}
