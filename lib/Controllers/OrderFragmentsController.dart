import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:skripsi/Data%20Model/menu.dart';
import 'package:skripsi/Data%20Model/pesanan.dart';
import 'package:skripsi/GlobalVar.dart';

class OrderFragmentsController extends GetxController {
  DocumentSnapshot? lastOrder;
  StreamSubscription<QuerySnapshot>? ss;
  RxList<pesanan> historyList = <pesanan>[].obs;
  RxList<pesanan> readyHistoryList = <pesanan>[].obs;
  RxList<pesanan> completeHistoryList = <pesanan>[].obs;
  initHistory() {
    ss?.cancel();
    var query = FirebaseFirestore.instance
        .collection('pesanan')
        .where('tenant_id', isEqualTo: GlobalVar.currentUser.user_id)
        .where('lastStatus', isEqualTo: 'ONGOING')
        .orderBy('created')
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
          ));
        }
      }
    });
  }

  initReadyHistory() {
    ss?.cancel();
    var query = FirebaseFirestore.instance
        .collection('pesanan')
        .where('tenant_id', isEqualTo: GlobalVar.currentUser.user_id)
        .where('lastStatus', isEqualTo: 'READY')
        .orderBy('created')
        .limit(10);
    ss = query.snapshots().listen((event) {
      readyHistoryList.clear();
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
          readyHistoryList.add(pesanan(
            created: DateTime.parse(doc['created']),
            lastStatus: doc['lastStatus'],
            order_id: doc['order_id'],
            detail: detail,
            tenant_id: doc['tenant_id'],
            tenant_name: doc['tenant_name'],
            voucherApplied: doc['voucherApplied'],
            voucher_id: doc['voucherApplied'] ? doc['voucher_id'] : '',
            voucher_value: doc['voucherApplied'] ? doc['voucher_value'] : 0,
          ));
        }
      }
    });
  }

  initCompletedHistory() {
    ss?.cancel();
    var query = FirebaseFirestore.instance
        .collection('pesanan')
        .where('tenant_id', isEqualTo: GlobalVar.currentUser.user_id)
        .where('lastStatus', whereIn: ['COMPLETED', 'REJECTED'])
        .orderBy('created')
        .limit(10);
    ss = query.snapshots().listen((event) {
      completeHistoryList.clear();
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
          completeHistoryList.add(pesanan(
            created: DateTime.parse(doc['created']),
            lastStatus: doc['lastStatus'],
            order_id: doc['order_id'],
            detail: detail,
            tenant_id: doc['tenant_id'],
            tenant_name: doc['tenant_name'],
            voucherApplied: doc['voucherApplied'],
            voucher_id: doc['voucherApplied'] ? doc['voucher_id'] : '',
            voucher_value: doc['voucherApplied'] ? doc['voucher_value'] : 0,
          ));
        }
      }
    });
  }
}
