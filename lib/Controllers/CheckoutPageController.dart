import 'package:get/get.dart';

import '../Data Model/menu.dart';

class CheckoutPageController extends GetxController {
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
      totalPrice += getTenantTotal(element.foodList);
    }
    return totalPrice;
  }
}
