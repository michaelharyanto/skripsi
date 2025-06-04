import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skripsi/Controllers/DatabaseController.dart';
import 'package:skripsi/Pages/HomePage.dart';
import 'package:skripsi/Pages/LoginPage.dart';
import 'package:skripsi/Widgets/MainLinearGradient.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 500),
      () async {
        if (!kIsWeb) {
          final firebase = FirebaseMessaging.instance;
          await firebase.requestPermission(
              sound: true, badge: true, alert: true, provisional: true);
          await [Permission.camera, Permission.notification, Permission.photos]
              .request();
        } else {
          try {
            await [
              // Permission.camera,
              Permission.notification,
            ].request();
            final firebase = FirebaseMessaging.instance;
            await firebase.requestPermission(
                sound: true, badge: true, alert: true, provisional: true);
          } catch (e) {
            print(e);
          }
        }
        int? status;
        status = await DatabaseController().getStatus();
        Get.off(status == 0 ? const HomePage(animateToIndex: null,) : const LoginPage());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        decoration:
            BoxDecoration(gradient: MainLinearGradient.mainlinearGradient),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlutterLogo(
                size: 150,
              ),
              Text(
                'App Name',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
      ),
    );
  }
}
