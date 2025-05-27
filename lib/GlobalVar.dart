import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlobalVar extends GetxController {
  static RxInt currentNavBarIndex = 0.obs;
  static final GlobalKey<ConvexAppBarState> appBarKey =
      GlobalKey<ConvexAppBarState>();
}
