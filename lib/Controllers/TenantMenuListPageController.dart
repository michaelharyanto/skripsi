import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:skripsi/Data%20Model/menu.dart';

class MenuListPageController extends GetxController {
  RxList<menu> menuList = <menu>[].obs;
  DocumentSnapshot? lastMenu;
  StreamSubscription<QuerySnapshot>? ss;
  getTenantMenu(String tenant_id) {
    ss?.cancel();
    var query = FirebaseFirestore.instance
        .collection('menu list')
        .where('tenant_id', isEqualTo: tenant_id)
        .where('isActive', isEqualTo: true)
        .orderBy('menu_stock', descending: true)
        .orderBy('menu_name')
        .limit(10);
    ss = query.snapshots().listen((event) {
      menuList.clear();
      if (event.docs.isNotEmpty) {
        lastMenu = event.docs.last;
        for (var menus in event.docs) {
          menuList.add(menu.fromJson(menus.data()));
        }
      }
    });
  }

  getMoreTenantMenu(String tenant_id) {
    var query = FirebaseFirestore.instance
        .collection('menu list')
        .where('tenant_id', isEqualTo: tenant_id)
        .where('isActive', isEqualTo: true)
        .orderBy('menu_stock', descending: true)
        .orderBy('menu_name')
        .startAfterDocument(lastMenu!)
        .limit(10);
    query.snapshots().listen((event) {
      if (event.docs.isNotEmpty) {
        lastMenu = event.docs.last;
        for (var menus in event.docs) {
          menuList.add(menu.fromJson(menus.data()));
        }
      }
    });
  }

  searchTenantMenu(String tenant_id, String search){
    ss?.cancel();
    menuList.clear();
    var query = FirebaseFirestore.instance
        .collection('menu list')
        .where('tenant_id', isEqualTo: tenant_id)
        .where('isActive', isEqualTo: true)
        .orderBy('menu_stock', descending: true)
        .orderBy('menu_name');
    ss = query.snapshots().listen((event) {
      lastMenu = null;
      menuList.clear();
      List<menu> tempList = [];
      if (event.docs.isNotEmpty) {
        lastMenu = event.docs.last;
        for (var menus in event.docs) {
          tempList.add(menu.fromJson(menus.data()));
        }
        menuList.addAll(tempList.where((element) =>
            element.menu_name!.toLowerCase().contains(search.toLowerCase())));
      }
    });
  }
}
