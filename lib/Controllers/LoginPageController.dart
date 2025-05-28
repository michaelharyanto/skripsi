import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsi/Controllers/DatabaseController.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:skripsi/GlobalVar.dart';
import 'package:skripsi/Pages/HomePage.dart';
import 'package:skripsi/Widgets/ErrorSnackBar.dart';
import 'package:skripsi/Widgets/PopUpLoading.dart';

class LoginPageController extends GetxController {
  onLoginTapped(String email, String password, BuildContext context) async {
    PopUpLoading().showdialog(context);
    await validateData(email, password, context);
  }

  validateData(String email, String password, BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user == null) {
        Get.back();
        ErrorSnackBar().showSnack(context, 'Data yang diinput invalid', 70);
      } else {
        print(credential.user);
        var data = await FirebaseFirestore.instance
            .collection('users')
            .where('user_email', isEqualTo: credential.user!.email)
            .get();
        var userData = data.docs.first;
        addFCMToken(userData['user_id']);
        await DatabaseController().addStatus(
            0,
            userData['user_id'],
            userData['user_name'],
            userData['user_role'],
            userData['user_email'],
            userData['phone_number']);
        GlobalVar.currentUser = (await DatabaseController().getUser())!;
        Get.offAll(HomePage());
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      Get.back();
      ErrorSnackBar().showSnack(context, 'Data yang diinput invalid', 70);
      print('ga ada user disini 2');
    }
  }

  addFCMToken(String user_id) async {
    String fcm_token = '';
    String device_token = '';
    final fm = FirebaseMessaging.instance;
    fcm_token = (await fm.getToken()) ?? '';
    device_token = await getDeviceString() ?? '';
    FirebaseFirestore.instance.collection('users').doc(user_id).set(
        {'fcm_token': fcm_token, 'deviceID': device_token},
        SetOptions(merge: true));
  }

  Future<String?> getDeviceString() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var ios = await deviceInfo.iosInfo;
      return ios.identifierForVendor;
    } else if (Platform.isAndroid) {
      var android = await deviceInfo.androidInfo;
      return android.id;
    } else if (kIsWeb) {
      var web = await deviceInfo.webBrowserInfo;
      return web.userAgent ?? '';
    } else {
      return '';
    }
  }
}
