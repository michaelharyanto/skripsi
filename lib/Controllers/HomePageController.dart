import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:skripsi/GlobalVar.dart';

class HomePageController extends GetxController {
  RxList<String> carouselList = <String>[].obs;
  RxInt carouselIndex = 0.obs;

  getCarrousel() async {
    carouselList.clear();
    final dio = Dio();
    var auth = base64Encode(utf8.encode('${GlobalVar.carouselToken}:'));
    try {
      var response = await dio.get(GlobalVar.carouselLink,
          options: Options(headers: {'Authorization': 'Basic $auth'}));
      if (response.statusCode == 200) {
        var list = response.data;
        for (var element in list) {
          carouselList.add(element['url']);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  getCartCount() {
    FirebaseFirestore.instance
        .collection('user cart')
        .doc(GlobalVar.currentUser.user_email)
        .collection('cart detail')
        .snapshots(includeMetadataChanges: true)
        .listen((event) {
      try {
        GlobalVar.cartCount.value = 0;
        for (var item in event.docs) {
          int count = item.get('quantity');
          GlobalVar.cartCount.value += count;
          print(GlobalVar.cartCount.value);
        }
      } catch (e) {
        print(e);
      }
    });
  }
}
