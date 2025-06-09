import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skripsi/Data%20Model/menu.dart';
import 'package:skripsi/Data%20Model/pesanan.dart';
import 'package:skripsi/GlobalVar.dart';

class OrderFragmentsController extends GetxController {
  DocumentSnapshot? lastOrder;
  DocumentSnapshot? lastReadyOrder;
  DocumentSnapshot? lastCompleteOrder;
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
              user_email: doc['user_email'],
              user_id: doc['user_id'],
              user_name: doc['user_name']));
        }
      }
    });
  }

  getMoreHistory() {
    var query = FirebaseFirestore.instance
        .collection('pesanan')
        .where('tenant_id', isEqualTo: GlobalVar.currentUser.user_id)
        .where('lastStatus', isEqualTo: 'ONGOING')
        .orderBy('created')
        .startAfterDocument(lastOrder!)
        .limit(10);
    query.snapshots().listen((event) {
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
              user_name: doc['user_name']));
        }
      }
    });
  }

  searchHistory(String search) {
    var query = FirebaseFirestore.instance
        .collection('pesanan')
        .where('tenant_id', isEqualTo: GlobalVar.currentUser.user_id)
        .where('lastStatus', isEqualTo: 'ONGOING')
        .orderBy('created');
    query.snapshots().listen((event) {
      lastOrder = null;
      if (event.docs.isNotEmpty) {
        List<pesanan> temp = [];
        historyList.clear();
        lastCompleteOrder = event.docs.last;
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
          temp.add(pesanan(
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
              user_name: doc['user_name']));
        }
        historyList.addAll(temp.where((element) =>
            (element.order_id.toLowerCase().contains(search.toLowerCase()) ||
                element.detail.any((element) => element.currentMenu!.menu_name!
                    .toLowerCase()
                    .contains(search.toLowerCase())))));
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
        lastReadyOrder = event.docs.last;
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
              user_email: doc['user_email'],
              user_id: doc['user_id'],
              user_name: doc['user_name']));
        }
      }
    });
  }

  getMoreReadyHistory() {
    var query = FirebaseFirestore.instance
        .collection('pesanan')
        .where('tenant_id', isEqualTo: GlobalVar.currentUser.user_id)
        .where('lastStatus', isEqualTo: 'READY')
        .orderBy('created')
        .startAfterDocument(lastReadyOrder!)
        .limit(10);
    query.snapshots().listen((event) {
      if (event.docs.isNotEmpty) {
        lastReadyOrder = event.docs.last;
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
              user_email: doc['user_email'],
              user_id: doc['user_id'],
              user_name: doc['user_name']));
        }
      }
    });
  }

  searchReadyHistory(String search) {
    var query = FirebaseFirestore.instance
        .collection('pesanan')
        .where('tenant_id', isEqualTo: GlobalVar.currentUser.user_id)
        .where('lastStatus', isEqualTo: 'READY')
        .orderBy('created');
    query.snapshots().listen((event) {
      lastReadyOrder = null;
      if (event.docs.isNotEmpty) {
        List<pesanan> temp = [];
        readyHistoryList.clear();
        lastCompleteOrder = event.docs.last;
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
          temp.add(pesanan(
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
              user_name: doc['user_name']));
        }
        readyHistoryList.addAll(temp.where((element) =>
            (element.order_id.toLowerCase().contains(search.toLowerCase()) ||
                element.detail.any((element) => element.currentMenu!.menu_name!
                    .toLowerCase()
                    .contains(search.toLowerCase())))));
      }
    });
  }

  initCompletedHistory() {
    ss?.cancel();
    var query = FirebaseFirestore.instance
        .collection('pesanan')
        .where('tenant_id', isEqualTo: GlobalVar.currentUser.user_id)
        .where('lastStatus', whereIn: ['COMPLETED', 'REJECTED'])
        .where('dateComplete',
            isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd 23:59:59').format(
                DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day - 3)))
        .where('dateComplete',
            isLessThanOrEqualTo: DateFormat('yyyy-MM-dd').format(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 1)))
        .orderBy('dateComplete', descending: true)
        .limit(10);
    ss = query.snapshots().listen((event) {
      if (event.docs.isNotEmpty) {
        completeHistoryList.clear();
        lastCompleteOrder = event.docs.last;
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
              user_email: doc['user_email'],
              user_id: doc['user_id'],
              user_name: doc['user_name']));
        }
      }
    });
  }

  getMoreCompletedHistory() {
    var query = FirebaseFirestore.instance
        .collection('pesanan')
        .where('tenant_id', isEqualTo: GlobalVar.currentUser.user_id)
        .where('lastStatus', whereIn: ['COMPLETED', 'REJECTED'])
        .where('dateComplete',
            isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd 23:59:59').format(
                DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day - 3)))
        .where('dateComplete',
            isLessThanOrEqualTo: DateFormat('yyyy-MM-dd').format(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 1)))
        .orderBy('dateComplete', descending: true)
        .startAfterDocument(lastCompleteOrder!)
        .limit(10);
    query.snapshots().listen((event) {
      if (event.docs.isNotEmpty) {
        lastCompleteOrder = event.docs.last;
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
              user_email: doc['user_email'],
              user_id: doc['user_id'],
              user_name: doc['user_name']));
        }
      }
    });
  }

  searchCompletedHistory(String search) {
    var query = FirebaseFirestore.instance
        .collection('pesanan')
        .where('tenant_id', isEqualTo: GlobalVar.currentUser.user_id)
        .where('lastStatus', whereIn: ['COMPLETED', 'REJECTED'])
        .where('dateComplete',
            isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd 23:59:59').format(
                DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day - 3)))
        .where('dateComplete',
            isLessThanOrEqualTo: DateFormat('yyyy-MM-dd').format(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 1)))
        .orderBy('dateComplete', descending: true);
    query.snapshots().listen((event) {
      lastCompleteOrder = null;
      if (event.docs.isNotEmpty) {
        List<pesanan> temp = [];
        completeHistoryList.clear();
        lastCompleteOrder = event.docs.last;
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
          temp.add(pesanan(
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
              user_name: doc['user_name']));
        }
        completeHistoryList.addAll(temp.where((element) =>
            (element.order_id.toLowerCase().contains(search.toLowerCase()) ||
                element.detail.any((element) => element.currentMenu!.menu_name!
                    .toLowerCase()
                    .contains(search.toLowerCase())))));
      }
    });
  }
}
