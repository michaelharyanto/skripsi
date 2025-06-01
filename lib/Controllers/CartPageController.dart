
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:skripsi/Data%20Model/menu.dart';
import 'package:skripsi/GlobalVar.dart';
import 'package:skripsi/Widgets/PopUpLoading.dart';

class CartPageController extends GetxController {
  RxList<cartList> userCart = <cartList>[].obs;
  RxInt totalPrice = 0.obs;
  RxInt checkCount = 0.obs;

  menuCheckboxClick(int tenantIndex, int menuIndex, bool value) {
    userCart[tenantIndex].foodList[menuIndex].checked.value = value;
    if (userCart[tenantIndex].foodList[menuIndex].checked.value) {
      checkCount.value++;
    } else {
      checkCount.value--;
    }
    tenantCheckboxUpdate(tenantIndex);
  }

  tenantCheckboxClick(int tenantIndex, bool value) {
    userCart[tenantIndex].checked.value = value;
    setAllMenuCheckbox(tenantIndex, value);
  }

  tenantCheckboxUpdate(int tenantIndex) {
    bool check = userCart[tenantIndex]
        .foodList
        .every((element) => element.checked.value == true);
    userCart[tenantIndex].checked.value = check;
    getTotal();
  }

  setAllMenuCheckbox(int tenantIndex, bool value) {
    for (var element in userCart[tenantIndex].foodList) {
      if (element.menu_stock == 0 || !element.isActive!.value) {
        continue;
      }
      if (element.checked.value == value) {
        element.checked.value = value;
        continue;
      }
      element.checked.value = value;
      if (element.checked.value) {
        checkCount.value++;
      } else {
        checkCount.value--;
      }
    }
    tenantCheckboxUpdate(tenantIndex);
    getTotal();
  }

  getTotal() {
    totalPrice.value = 0;
    for (var cart in userCart) {
      for (var item in cart.foodList) {
        if (item.checked.value) {
          totalPrice += item.menu_price! * item.quantity;
        }
      }
    }
  }

  getUserCart() {
    FirebaseFirestore.instance
        .collection('user cart')
        .doc(GlobalVar.currentUser.user_email)
        .collection('cart detail')
        .orderBy('tenant_id')
        .snapshots(includeMetadataChanges: true)
        .listen((event) async {
      List<cart> _cart = [];
      userCart.clear();
      for (var item in event.docs) {
        _cart.add(cart(
            menu_id: item['menu_id'],
            tenant_id: item['tenant_id'],
            tenant_name: item['tenant_name'],
            checked: false.obs,
            quantity: item['quantity'],
            isActive: false.obs,
            notes: item['notes'],
            status: 'Dine In'));
      }
      int index = 0;
      for (var i = 0; i < _cart.length; i++) {
        if (i == 0) {
          userCart.add(cartList(
              checked: false.obs,
              foodList: [],
              tenant_name: _cart[i].tenant_name));
        }
        if (i >= 1) {
          if (_cart[i].tenant_id != _cart[i - 1].tenant_id) {
            index++;
            userCart.add(cartList(
                checked: false.obs,
                foodList: [],
                tenant_name: _cart[i].tenant_name));
          }
          userCart[index].foodList.add(_cart[i]);
        } else {
          userCart[index].foodList.add(_cart[i]);
        }
      }
    });
  }

  addQty(int qty, int maxStock, cart currentItem) {
    qty++;
    if (qty > maxStock) {
      return;
    }
    try {
      FirebaseFirestore.instance
          .collection('user cart')
          .doc(GlobalVar.currentUser.user_email)
          .collection('cart detail')
          .doc(currentItem.menu_id)
          .update({'quantity': qty});
    } catch (e) {
      print(e);
    }
    getTotal();
  }

  subtractQty(int qty, int maxStock, cart currentItem, BuildContext context) {
    qty--;
    if (qty <= 0) {
      showDeleteModal(context, currentItem.menu_id);
      return;
    }
    try {
      FirebaseFirestore.instance
          .collection('user cart')
          .doc(GlobalVar.currentUser.user_email)
          .collection('cart detail')
          .doc(currentItem.menu_id)
          .update({'quantity': qty});
    } catch (e) {
      print(e);
    }
    getTotal();
  }

  showDeleteModal(BuildContext context, String menu_id) {
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
                decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Hapus Menu dari Keranjang',
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
                      Text('Apakah Anda yakin untuk keluar?',
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
                    PopUpLoading().showdialog(context);
                    await FirebaseFirestore.instance
                        .collection('user cart')
                        .doc(GlobalVar.currentUser.user_email)
                        .collection('cart detail')
                        .doc(menu_id)
                        .delete()
                        .whenComplete(() {
                      Get.back();
                      Get.back();
                    });
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hapus',
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

  showNotesModal(BuildContext context, String notes, String menu_id) {
    TextEditingController notesTF = TextEditingController();
    notesTF.text = notes;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          height: Get.height * 0.3 + MediaQuery.of(context).viewInsets.bottom,
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
                      'Tambah Catatan',
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
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: notesTF,
                        style: const TextStyle(
                            fontFamily: 'Poppins', fontWeight: FontWeight.w500),
                        minLines: 4,
                        maxLines: 4,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.red)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  const BorderSide(color:Colors.grey)),
                        ),
                      ),
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
                    FirebaseFirestore.instance
                        .collection('user cart')
                        .doc(GlobalVar.currentUser.user_email)
                        .collection('cart detail')
                        .doc(menu_id)
                        .update({'notes': notesTF.text}).whenComplete(() {
                      Get.back();
                    });
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
                          'Simpan',
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

  Future<List<cartList>> filterList() async {
    List<cartList> cl = [];
    cartList temp = cartList(foodList: [], checked: false.obs, tenant_name: '');
    cart temp2 = cart(
        menu_id: '',
        tenant_id: '',
        tenant_name: '',
        checked: false.obs,
        quantity: 0,
        notes: '',
        status: '');
        for (var element in userCart) {
          if (element.checked.value) {
            cl.add(element);
            continue;
          }
          for (var menu in element.foodList) {
            if (menu.checked.value) {
              temp2 = menu;
              temp.foodList.add(temp2);
            }
          }
          if (temp.foodList.isNotEmpty) {
            cl.add(temp);
            temp = cartList(foodList: [], checked: false.obs, tenant_name: '');
          }
        }
    return cl;
  }
}
