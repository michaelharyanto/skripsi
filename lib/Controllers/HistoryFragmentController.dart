import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:skripsi/Data%20Model/menu.dart';
import 'package:skripsi/Data%20Model/pesanan.dart';
import 'package:skripsi/GlobalVar.dart';

class HistoryFragmentController extends GetxController {
  RxList<pesanan> historyList = <pesanan>[].obs;
  DocumentSnapshot? lastOrder;
  StreamSubscription<QuerySnapshot>? ss;
  initHistory() {
    ss?.cancel();
    historyList.clear();
    var query = FirebaseFirestore.instance
        .collection('pesanan')
        .where('user_id', isEqualTo: GlobalVar.currentUser.user_id)
        .orderBy('created', descending: true)
        .limit(10);
    ss = query.snapshots().listen((event) {
      historyList.clear();
      if (event.docs.isNotEmpty) {
        lastOrder = event.docs.last;
        for (var doc in event.docs) {
          List<cart> detail = [];
          for (var element in doc['detail']) {
            detail.add(cart(
                menu_id: element['menu_id'],
                tenant_id: doc['tenant_id'],
                tenant_name: doc['tenant_name'],
                menu_price: element['menu_price'],
                menu_stock: element['menu_stock'],
                checked: false.obs,
                quantity: element['quantity'],
                notes: element['notes'],
                status: element['status'],
                currentMenu: menu(
                    menu_desc: element['menu_desc'],
                    menu_id: element['menu_id'],
                    menu_image: element['menu_image'],
                    menu_name: element['menu_name'],
                    menu_price: element['menu_price'],
                    menu_stock: element['menu_stock'],
                    tenant_id: doc['tenant_id'])));
          }
          historyList.add(pesanan(
            created: DateTime.parse(doc['created']),
            lastStatus: doc['lastStatus'],
            order_id: doc['order_id'],
            detail: detail,
            tenant_id: doc['tenant_id'],
            tenant_name: doc['tenant_name'],
            voucherApplied: doc['voucherApplied'],
            voucher_id: doc['voucherApplied'] ? doc['voucher_id'] : '',
            voucher_value: doc['voucherApplied'] ? doc['voucher_value'] : 0,
            user_email: doc['user_email'],
            user_id: doc['user_id'],
            user_name: doc['user_name']
          ));
        }
      }
    });
  }

  getMoreHistory() async {
    var docs = await FirebaseFirestore.instance
        .collection('pesanan')
        .where('user_id', isEqualTo: GlobalVar.currentUser.user_id)
        .orderBy('created', descending: true)
        .limit(10)
        .startAfterDocument(lastOrder!)
        .get();
    if (docs.docs.isNotEmpty) {
      lastOrder = docs.docs.last;
      for (var doc in docs.docs) {
        List<cart> detail = [];
        for (var element in doc['detail']) {
          detail.add(cart(
              menu_id: element['menu_id'],
              tenant_id: doc['tenant_id'],
              tenant_name: doc['tenant_name'],
              menu_price: element['menu_price'],
              menu_stock: element['menu_stock'],
              checked: false.obs,
              quantity: element['quantity'],
              notes: element['notes'],
              status: element['status'],
              currentMenu: menu(
                  menu_desc: element['menu_desc'],
                  menu_id: element['menu_id'],
                  menu_image: element['menu_image'],
                  menu_name: element['menu_name'],
                  menu_price: element['menu_price'],
                  menu_stock: element['menu_stock'],
                  tenant_id: doc['tenant_id'])));
        }
        historyList.add(pesanan(
          created: DateTime.parse(doc['created']),
          lastStatus: doc['lastStatus'],
          order_id: doc['order_id'],
          detail: detail,
          tenant_id: doc['tenant_id'],
          tenant_name: doc['tenant_name'],
          voucherApplied: doc['voucherApplied'],
          voucher_id: doc['voucherApplied'] ? doc['voucher_id'] : '',
          voucher_value: doc['voucherApplied'] ? doc['voucher_value'] : 0,
          user_email: doc['user_email'],
            user_id: doc['user_id'],
            user_name: doc['user_name']
        ));
      }
    }
  }
}
