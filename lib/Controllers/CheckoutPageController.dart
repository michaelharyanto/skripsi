import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ntp/ntp.dart';
import 'package:skripsi/Data%20Model/pesanan.dart';
import 'package:skripsi/GlobalVar.dart';
import 'package:skripsi/Widgets/ErrorSnackBar.dart';
import 'package:skripsi/Widgets/PopUpLoading.dart';
import 'package:uuid/v4.dart';

import '../Data Model/menu.dart';

class CheckoutPageController extends GetxController {
  Rx<voucher> selectedVoucher =
      voucher(voucher_id: '', voucher_value: 0, minimum: 0).obs;
  Rx<voucher> currentVoucher =
      voucher(voucher_id: '', voucher_value: 0, minimum: 0).obs;
  int getTenantTotal(List<cart> list) {
    int totalPrice = 0;
    for (var element in list) {
      totalPrice += element.quantity * element.menu_price!;
    }
    return totalPrice;
  }

  int getTotal(List<cartList> list) {
    int totalPrice = 0;
    for (var element in list) {
      totalPrice += getTenantTotal(element.menuList);
    }
    return totalPrice;
  }

  showVoucherListModal(BuildContext context, int subtotal) {
    selectedVoucher.value =
        voucher(voucher_id: '', voucher_value: 0, minimum: 0);
    if (currentVoucher.value.voucher_id.isNotEmpty) {
      selectedVoucher.value = currentVoucher.value;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          height: Get.height * 0.4 + MediaQuery.of(context).viewInsets.bottom,
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
                    const Text(
                      'Pakai Voucher',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700),
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
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('voucher list')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var voucherData = snapshot.data!.docs[index];
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Color(int.parse(
                                                  "#FFCECECE"
                                                      .replaceAll('#', ""),
                                                  radix: 16))))),
                                  child: Obx(() => RadioListTile(
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Voucher Potongan ${NumberFormat.currency(locale: 'id_ID', decimalDigits: 0, symbol: 'Rp').format(voucherData['voucher_value'])}",
                                            style: TextStyle(
                                                color: subtotal <
                                                        voucherData['minimum']
                                                    ? Colors.grey[400]
                                                    : Colors.black,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14),
                                          ),
                                          Text(
                                            "Minimal belanja ${NumberFormat.currency(locale: 'id_ID', decimalDigits: 0, symbol: 'Rp').format(voucherData['minimum'])}",
                                            style: TextStyle(
                                                color: subtotal <
                                                        voucherData['minimum']
                                                    ? Colors.grey[400]
                                                    : Colors.black,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      dense: true,
                                      toggleable: true,
                                      contentPadding: EdgeInsets.zero,
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      value: voucherData['voucher_id'],
                                      groupValue:
                                          selectedVoucher.value.voucher_id,
                                      onChanged: (value) {
                                        if (subtotal < voucherData['minimum']) {
                                        } else {
                                          if (value == null) {
                                            selectedVoucher.value.voucher_id =
                                                value ?? '';
                                            selectedVoucher.value = voucher(
                                                voucher_id: '',
                                                voucher_value: 0,
                                                minimum: 0);
                                            return;
                                          }
                                          selectedVoucher.value = voucher
                                              .fromJson(voucherData.data());
                                        }
                                      })),
                                );
                              },
                            );
                          }
                        })),
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
                  onTap: () {
                    currentVoucher.value = selectedVoucher.value;
                    Get.back();
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Tambah',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
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

  Future<bool> checkUserVoucher(BuildContext context) async {
    bool userValid = false;
    var ref = await FirebaseFirestore.instance
        .collection('users')
        .doc(GlobalVar.currentUser.user_id)
        .get();
    if (ref.data()!.containsKey('lastUsedVoucher')) {
      var lastUsed = DateTime.tryParse(ref.data()!['lastUsedVoucher']);
      var today = await NTP.now();

      var lastUsedDate = DateTime(lastUsed!.year, lastUsed.month, lastUsed.day);
      var todayDate = DateTime(today.year, today.month, today.day);
      var datenow = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      Duration difference = todayDate.difference(lastUsedDate);

      if (todayDate != datenow) {
        ErrorSnackBar().showSnack(context, 'Error', 70);
        return false;
      }

      // print(difference.inDays);
      if (difference.inDays >= 1) {
        userValid = true;
      } else {
        userValid = false;
      }
    } else {
      userValid = true;
    }
    return userValid;
  }

  showConfirmModal(BuildContext context, cartList items, List<String> ids) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          height: Get.height * 0.2 + MediaQuery.of(context).viewInsets.bottom,
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
                    const Text(
                      'Checkout',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700),
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
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Apakah Anda yakin untuk membuat pesanan?',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500))
                    ],
                  ),
                ),
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
                    DateTime today = await NTP.now();
                    checkout(context, items, ids, today);
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pesan',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
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

  filterID(List<cartList> list) {
    List<String> fc = [];
    for (var item in list) {
      for (var element in item.menuList) {
        fc.add(element.menu_id);
      }
    }
    return fc;
  }

  checkout(BuildContext context, cartList items, List<String> ids,
      DateTime today) async {
    try {
      PopUpLoading().showdialog(context);
      var tenantData = await FirebaseFirestore.instance
          .collection('users')
          .where('user_id', isEqualTo: items.menuList.first.tenant_id)
          .get();

      if (tenantData.docs.isEmpty) {
        throw Exception('Tenant not found');
      }
      var tenantToken = tenantData.docs.first.data().containsKey('dvcid')
          ? tenantData.docs.first['dvcid']
          : '';
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        List<DocumentSnapshot> menuSnapshots = [];
        for (var menu in items.menuList) {
          var menuRef = FirebaseFirestore.instance
              .collection('menu list')
              .doc(menu.menu_id);
          var menuSnapshot = await menuRef.get();
          menuSnapshots.add(menuSnapshot);
        }
        var userRef = FirebaseFirestore.instance
            .collection('users')
            .doc(GlobalVar.currentUser.user_id);
        var docNum = const UuidV4().generate();
        var orderRef =
            FirebaseFirestore.instance.collection('pesanan').doc(docNum);
        while ((await transaction.get(orderRef)).exists) {
          docNum = const UuidV4().generate();
          orderRef =
              FirebaseFirestore.instance.collection('pesanan').doc(docNum);
        }

        List<Map<String, dynamic>> detail = [];
        List<String> status = [];

        for (var i = 0; i < items.menuList.length; i++) {
          var menu = items.menuList[i];
          var menuSnapshot = menuSnapshots[i];
          var menuRef = menuSnapshot.reference;

          if (!menuSnapshot.exists || menuSnapshot['menu_stock'] <= 0) {
            throw Exception(
                'Stock unavailable for ${menu.currentMenu!.menu_name}');
          }

          int currentStock = menuSnapshot['menu_stock'] as int;
          if (currentStock < menu.quantity) {
            throw Exception(
                'Not enough stock for ${menu.currentMenu!.menu_name}');
          }

          // Add product details
          detail.add({
            'menu_id': menu.currentMenu!.menu_id,
            'menu_desc': menu.currentMenu!.menu_desc,
            'menu_image': menu.currentMenu!.menu_image,
            'menu_name': menu.currentMenu!.menu_name,
            'menu_price': menu.currentMenu!.menu_price,
            'menu_stock': menuSnapshot['menu_stock'],
            'notes': menu.notes,
            'status': menu.status,
            'quantity': menu.quantity,
          });
          status.add(menu.status);

          // Update stock
          transaction
              .update(menuRef, {'menu_stock': currentStock - menu.quantity});
        }
        Map<String, dynamic> senddata = {
          'order_id': docNum,
          'user_id': GlobalVar.currentUser.user_id,
          'user_name': GlobalVar.currentUser.user_name,
          'user_email': GlobalVar.currentUser.user_email,
          'tenant_name': tenantData.docs.first['user_name'],
          'tenant_id': tenantData.docs.first['user_id'],
          'created': DateFormat('yyyy-MM-dd HH:mm:ss').format(today),
          'timeline': [
            {
              'status': 'NEW',
              'date': DateFormat('yyyy-MM-dd HH:mm:ss').format(today)
            }
          ],
          'hasChat': false,
          'lastStatus': 'NEW',
          'isProcessed': false,
          'voucherApplied': currentVoucher.value.voucher_id.isNotEmpty,
          if (currentVoucher.value.voucher_id.isNotEmpty)
            'voucher_id': currentVoucher.value.voucher_id.toString(),
          if (currentVoucher.value.voucher_id.isNotEmpty)
            'voucher_value': currentVoucher.value.voucher_value,
          'detail': detail,
          'statusList': status,
        };
        transaction.set(orderRef, senddata);
        transaction.set(
            userRef,
            {
              'lastUsedVoucher': DateFormat('yyyy-MM-dd HH:mm:ss').format(today)
            },
            SetOptions(merge: true));
      });
      for (var item in ids) {
        // print(item);
        var ref = FirebaseFirestore.instance
            .collection('user cart')
            .doc(GlobalVar.currentUser.user_email)
            .collection('cart detail')
            .doc(item);
        await ref.delete();
      }
      // tambah push fcm
      Get.back();
      AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              title: 'Berhasil Dipesan',
              titleTextStyle:
                  const TextStyle(fontFamily: 'Poppins', color: Colors.black),
              dismissOnBackKeyPress: false,
              dismissOnTouchOutside: false,
              animType: AnimType.scale)
          .show();
      await Future.delayed(const Duration(seconds: 2));
      Get.offAllNamed('/homepage');
    } catch (e) {}
  }
}
