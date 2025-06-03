import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ntp/ntp.dart';
import 'package:skripsi/Data%20Model/menu.dart';
import 'package:skripsi/Widgets/PopUpLoading.dart';

class HistoryDetailPageController extends GetxController {
  RxBool isExpanded = false.obs;
  RxBool valid = false.obs;

  int getTotal(List<cart> detail) {
    int total = 0;
    for (var element in detail) {
      total += element.quantity * element.menu_price!;
    }
    return total;
  }

  acceptOrder(
      String order_id, List<dynamic> timeline, BuildContext context) async {
    PopUpLoading().showdialog(context);
    var today = await NTP.now();
    String currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(today);
    timeline.add({'date': currentDate, 'status': 'ONGOING'});
    await FirebaseFirestore.instance.collection('pesanan').doc(order_id).update(
        {'isProcessed': true, 'timeline': timeline, 'lastStatus': 'ONGOING'});
    AwesomeDialog(
      // ignore: use_build_context_synchronously
      context: context,
      dialogType: DialogType.success,
      title: 'Pesanan Diterima',
      titleTextStyle: const TextStyle(
          color: Colors.black,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500),
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      animType: AnimType.scale,
    ).show();
    await Future.delayed(const Duration(seconds: 2));
    Get.back();
    Get.offAllNamed('/homepage');
  }

  showRejectModal(BuildContext context, String orderID, List<dynamic> timeline,
      String orderEmail, List<cart> foods, bool voucherApplied) {
    TextEditingController rejectTF = TextEditingController();
    valid.value = false;
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => Container(
              height: 333 + MediaQuery.of(context).viewInsets.bottom,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30))),
              child: Column(
                children: [
                  Container(
                    height: 60,
                    decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Menolak Pesanan',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                fontSize: 16),
                          ),
                          GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(
                                MdiIcons.closeCircle,
                                size: 32,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Apakah Anda yakin ingin menolak pesanan?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: RichText(
                                  text: const TextSpan(children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          'Mohon masukkan alasan pembatalan pesanan ini',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 13,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ]),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            onChanged: (value) {
                              enableButton(rejectTF.text);
                            },
                            controller: rejectTF,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(int.parse(
                                          "#FF79747E".replaceAll('#', ""),
                                          radix: 16)),
                                      width: 1)),
                              hintText: '',
                              counterText: '',
                              labelText: '',
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor)),
                              contentPadding: const EdgeInsets.all(10),
                              isDense: true,
                            ),
                            style: const TextStyle(
                                fontSize: 16, fontFamily: 'Poppins'),
                            textAlign: TextAlign.left,
                            minLines: 4,
                            maxLines: 4,
                            keyboardType: TextInputType.multiline,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: TextButton(
                          onPressed: () {
                            if (valid.value) {
                              rejectOrder(
                                  context,
                                  orderID,
                                  timeline,
                                  orderEmail,
                                  foods,
                                  rejectTF.text,
                                  voucherApplied);
                            }
                          },
                          style: TextButton.styleFrom(
                              backgroundColor: valid.value
                                  ? Colors.red
                                  : const Color(0xFF979797),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: const Text(
                            "OK",
                            style: TextStyle(
                                fontFamily: 'Poppins', color: Colors.white),
                          )),
                    ),
                  ),
                ],
              ),
            ));
  }

  enableButton(String text) {
    if (text.isEmpty) {
      valid.value = false;
    } else {
      valid.value = true;
    }
  }

  rejectOrder(
      BuildContext context,
      String orderID,
      List<dynamic> timeline,
      String orderEmail,
      List<cart> foods,
      String reason,
      bool voucherApplied) async {
    PopUpLoading().showdialog(context);
    var today = await NTP.now();
    String currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(today);
    timeline.add({'date': currentDate, 'status': 'REJECTED'});
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference orderRef =
          FirebaseFirestore.instance.collection('pesanan').doc(orderID);
      DocumentSnapshot orderSnapshot = await transaction.get(orderRef);

      List<DocumentSnapshot> foodSnapshots = [];
      for (var element in foods) {
        DocumentReference foodRef = FirebaseFirestore.instance
            .collection('menu list')
            .doc(element.menu_id);
        foodSnapshots.add(await transaction.get(foodRef));
      }

      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(orderEmail);
      DocumentSnapshot userSnapshot = await transaction.get(userRef);

      // Now, proceed with all the writes after reading
      // Update the order document
      transaction.set(
        orderRef,
        {'dateComplete': currentDate, 'rejectReason': reason},
        SetOptions(merge: true),
      );

      transaction.update(
        orderRef,
        {
          'timeline': timeline,
          'lastStatus': 'REJECTED',
          'voucherApplied': false,
          'isProcessed': true,
        },
      );

      // Update the stock for each food item
      for (int i = 0; i < foods.length; i++) {
        DocumentReference foodRef = FirebaseFirestore.instance
            .collection('menu list')
            .doc(foods[i].menu_id);
        int oldQty = foodSnapshots[i]['menu_stock'];
        int qty = oldQty + int.tryParse(foods[i].quantity.toString())!;

        transaction.update(foodRef, {'menu_stock': qty});
      }

      // Handle voucher logic if voucher is applied
      if (voucherApplied) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        DateTime now = await NTP.now();
        DateTime lastUsedVoucher =
            DateFormat('yyyy-MM-dd').parse(userData['lastUsedVoucher']);
        DateTime lastAcceptedVoucher = DateFormat('yyyy-MM-dd').parse(
          userData.containsKey('lastAcceptedVoucher')
              ? userData['lastAcceptedVoucher']
              : DateFormat('yyyy-MM-dd')
                  .format(now.add(const Duration(days: 1))),
        );

        if (lastUsedVoucher != lastAcceptedVoucher) {
          transaction.update(userRef, {'lastUsedVoucher': FieldValue.delete()});
        }
      }
    });
    // tambahkan fcm
    AwesomeDialog(
      // ignore: use_build_context_synchronously
      context: context,
      dialogType: DialogType.success,
      title: 'Pesanan Ditolak',
      titleTextStyle: const TextStyle(
          color: Colors.black,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500),
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      animType: AnimType.scale,
    ).show();
    await Future.delayed(const Duration(seconds: 2));
    Get.back();
    Get.offAllNamed('/homepage');
  }

  readyOrder(
      String order_id, List<dynamic> timeline, BuildContext context) async {
    PopUpLoading().showdialog(context);
    var today = await NTP.now();
    String currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(today);
    timeline.add({'date': currentDate, 'status': 'READY'});
    await FirebaseFirestore.instance
        .collection('pesanan')
        .doc(order_id)
        .update({'timeline': timeline, 'lastStatus': 'READY'});
    // tambahkan fcm
    AwesomeDialog(
      // ignore: use_build_context_synchronously
      context: context,
      dialogType: DialogType.success,
      title: 'Notifikasi telah dikirim pembeli',
      titleTextStyle: const TextStyle(
          color: Colors.black,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500),
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      animType: AnimType.scale,
    ).show();
    await Future.delayed(const Duration(seconds: 2));
    Get.back();
    Get.offAllNamed('/homepage');
  }

  completeOrder(
      String order_id, List<dynamic> timeline, BuildContext context) async {
    PopUpLoading().showdialog(context);
    var today = await NTP.now();
    String currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(today);
    timeline.add({'date': currentDate, 'status': 'COMPLETED'});
    await FirebaseFirestore.instance
        .collection('pesanan')
        .doc(order_id)
        .update({'timeline': timeline, 'lastStatus': 'COMPLETED'});
    await FirebaseFirestore.instance
        .collection('pesanan')
        .doc(order_id)
        .update({'dateComplete': currentDate});
    // tambahkan fcm
    AwesomeDialog(
      // ignore: use_build_context_synchronously
      context: context,
      dialogType: DialogType.success,
      title: 'Pesanan Selesai',
      titleTextStyle: const TextStyle(
          color: Colors.black,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500),
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      animType: AnimType.scale,
    ).show();
    await Future.delayed(const Duration(seconds: 2));
    Get.back();
    Get.offAllNamed('/homepage');
  }
}
