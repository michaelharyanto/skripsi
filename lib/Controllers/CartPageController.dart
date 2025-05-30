import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:skripsi/Data%20Model/menu.dart';
import 'package:skripsi/GlobalVar.dart';

class CartPageController extends GetxController {
  RxList<cartList> userCart = <cartList>[].obs;
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
}
