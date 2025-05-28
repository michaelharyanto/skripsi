import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    // TODO: implement initState
    super.initState();
    Future.delayed(
      Duration(milliseconds: 500),
      () async {
        int? status;
        status = await DatabaseController().getStatus();
        Get.off(status == 0 ? HomePage() : LoginPage());
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
