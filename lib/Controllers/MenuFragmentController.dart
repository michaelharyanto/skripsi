import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:skripsi/Data%20Model/menu.dart';
import 'package:skripsi/GlobalVar.dart';

class MenuFragmentController extends GetxController {
  RxList<menu> menuList = <menu>[].obs;
  DocumentSnapshot? lastMenu;
  StreamSubscription<QuerySnapshot>? ss;
  initMenu() {
    ss?.cancel();
    menuList.clear();
    var query = FirebaseFirestore.instance
        .collection('menu list')
        .where('tenant_id', isEqualTo: GlobalVar.currentUser.user_id)
        .orderBy('isActive', descending: true)
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

  getMoreMenu() {
    var query = FirebaseFirestore.instance
        .collection('menu list')
        .where('tenant_id', isEqualTo: GlobalVar.currentUser.user_id)
        .orderBy('isActive', descending: true)
        .orderBy('menu_name')
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

  searchMenu(String search) {
    ss?.cancel();
    menuList.clear();
    var query = FirebaseFirestore.instance
        .collection('menu list')
        .where('tenant_id', isEqualTo: GlobalVar.currentUser.user_id)
        .orderBy('isActive', descending: true)
        .orderBy('menu_name');
    ss = query.snapshots().listen((event) {
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

  showEditModal(BuildContext context, menu currentMenu) {
    TextEditingController quantityTF = TextEditingController();
    quantityTF.text = currentMenu.menu_stock.toString();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          height: 214 + MediaQuery.of(context).viewInsets.bottom,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
          child: Column(
            children: [
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Ubah Stok ${currentMenu.menu_name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        MdiIcons.closeCircle,
                        size: 32,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Jumlah Stok',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500)),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                int quantity =
                                    int.tryParse(quantityTF.text) ?? 0;
                                quantity--;

                                quantityTF.text = quantity.toString();
                              },
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8)),
                                child: const Center(
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            SizedBox(
                              width: 46,
                              child: Center(
                                child: TextFormField(
                                  controller: quantityTF,
                                  autofocus: true,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                  ),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                      isDense: true,
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor))),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            InkWell(
                              onTap: () {
                                int quantity =
                                    int.tryParse(quantityTF.text) ?? 0;
                                quantity++;

                                quantityTF.text = quantity.toString();
                              },
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(8)),
                                child: const Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 34,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration:
                    const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3))
                ]),
                child: InkWell(
                  onTap: () async {
                    int qty = int.tryParse(quantityTF.text) ?? 0;
                    await FirebaseFirestore.instance
                        .collection('menu list')
                        .doc(currentMenu.menu_id)
                        .update({'menu_stock': qty});
                    Get.back();
                    Get.back();
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Simpan',
                          style: TextStyle(
                              fontFamily: 'Poppins', color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
