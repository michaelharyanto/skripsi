import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:skripsi/Data%20Model/menu.dart';
import 'package:skripsi/GlobalVar.dart';
import 'package:skripsi/Widgets/PopUpLoading.dart';

class MenuDetailPageController extends GetxController {
  RxBool isWishlist = false.obs;

  checkWishlist(String menu_id) async {
    var doc = await FirebaseFirestore.instance 
        .collection('users')
        .doc(GlobalVar.currentUser.user_id)
        .collection('wishlist')
        .doc(menu_id)
        .get();
    if (doc.exists) {
      isWishlist.value = true;
    } else {
      isWishlist.value = false;
    }
  }

  addWishlist(BuildContext context, String menu_id) async {
    PopUpLoading().showdialog(context);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(GlobalVar.currentUser.user_id)
        .collection('wishlist')
        .doc(menu_id)
        .set({'menu_id': menu_id});
    isWishlist.value = true;
    Get.back();
  }

  removeWishlist(BuildContext context, String menu_id) async {
    PopUpLoading().showdialog(context);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(GlobalVar.currentUser.user_id)
        .collection('wishlist')
        .doc(menu_id)
        .delete();
    isWishlist.value = false;
    Get.back();
  }

  showBuyModal(BuildContext context, menu menu) {
    TextEditingController quantityTF = TextEditingController();
    quantityTF.text = '1';
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
                      'Tambah Ke Keranjang',
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 90,
                            width: 90,
                            child:
                                CachedNetworkImage(imageUrl: menu.menu_image!),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                menu.menu_name!,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Stok: ${menu.menu_stock}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                NumberFormat.currency(
                                        locale: 'id_ID',
                                        decimalDigits: 0,
                                        symbol: 'Rp')
                                    .format(menu.menu_price),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ))
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Jumlah',
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
                                  if (quantity > menu.menu_stock!) {
                                    quantity = menu.menu_stock!;
                                  }
                                  if (quantity == 0) {
                                    quantity = 1;
                                  }
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
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    readOnly: true,
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
                                  if (quantity > menu.menu_stock!) {
                                    quantity = menu.menu_stock!;
                                  }
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
                    addMenuToCart(context, quantityTF.text, menu, true);
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          MdiIcons.cartPlus,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text(
                          'Tambah Ke Keranjang',
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

  addMenuToCart(
      BuildContext context, String quantity, menu menu, bool fromDetail) async {
    EasyLoading.instance
      ..indicatorWidget = SpinKitPouringHourGlassRefined(
        color: Theme.of(context).primaryColor,
      )
      ..textColor = Colors.white
      ..progressColor = Colors.white
      ..indicatorColor = Colors.white
      ..backgroundColor = Colors.white;

    EasyLoading.show(status: 'Loading...', maskType: EasyLoadingMaskType.black);

    await FirebaseFirestore.instance
        .collection('user cart')
        .doc(GlobalVar.currentUser.user_email)
        .set({'dummy': 'dummy'});

    DocumentReference doc = FirebaseFirestore.instance
        .collection('user cart')
        .doc(GlobalVar.currentUser.user_email)
        .collection('cart detail')
        .doc(menu.menu_id);
    try {
      int newQty = 0;
      var docRef = await doc.get();
      if (docRef.exists && docRef.data() != null) {
        int qty1 = int.tryParse(quantity) ?? 0;
        int qty2 = docRef.get('quantity');
        newQty = qty1 + qty2;
        if (menu.menu_stock! < newQty) {
          EasyLoading.dismiss();
          Get.snackbar(
            "Error",
            "Terjadi error, coba lagi nanti",
            icon: const Icon(
              Icons.error,
              color: Colors.white,
            ),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            borderRadius: 20,
            margin: const EdgeInsets.all(15),
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
          return;
        }
      } else {
        newQty = int.tryParse(quantity) ?? 0;
      }
      var tenantData = await FirebaseFirestore.instance
          .collection('users')
          .doc(menu.tenant_id)
          .get();
      Map<String, dynamic> data = {
        'menu_id': menu.menu_id,
        'tenant_id': menu.tenant_id,
        'tenant_name': tenantData.data()!['user_name'],
        'notes': '',
        'quantity': newQty
      };
      doc.set(data).whenComplete(() {
        if (fromDetail) {
          Get.back();
        }
        EasyLoading.dismiss();
        Get.snackbar("Error", '',
            titleText: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  MdiIcons.cartCheck,
                  size: 27,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                const Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "SUCCESS",
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Roboto',
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Added to Cart",
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 11,
                            color: Colors.white),
                        softWrap: true,
                      )
                    ],
                  ),
                )
              ],
            ),
            borderRadius: 33,
            messageText: const SizedBox.shrink(),
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
              top: 15,
              bottom: 8,
            ),
            margin: const EdgeInsets.symmetric(vertical: 75, horizontal: 70),
            snackPosition: SnackPosition.BOTTOM,
            colorText: Theme.of(context).primaryColor,
            backgroundColor: Colors.green,
            duration: const Duration(milliseconds: 800));
      });
    } catch (e) {
      print(e);
    }
  }
}
