import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsi/Data%20Model/user.dart';

class GlobalVar extends GetxController {
  static RxInt currentNavBarIndex = 0.obs;
  static RxInt cartCount = 0.obs;
  static String carouselLink = '';
  static String carouselToken = '';
  static  GlobalKey<ConvexAppBarState>? appBarKey;
  static user currentUser = user(
      phone_number: '',
      user_email: '',
      user_id: '',
      user_name: '',
      user_role: '');
}
