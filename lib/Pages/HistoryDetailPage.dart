import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:skripsi/Controllers/HistoryDetailPageController.dart';
import 'package:skripsi/Data%20Model/menu.dart';
import 'package:skripsi/GlobalVar.dart';
import 'package:skripsi/Widgets/TimelineMaker.dart';

// ignore: must_be_immutable
class HistoryDetailPage extends StatefulWidget {
  String order_id;
  List<cart> detail;
  HistoryDetailPage({super.key, required this.order_id, required this.detail});

  @override
  State<HistoryDetailPage> createState() => _HistoryDetailPageState();
}

class _HistoryDetailPageState extends State<HistoryDetailPage> {
  HistoryDetailPageController h = Get.put(HistoryDetailPageController());
  RxInt totalPrice = 0.obs;
  @override
  void initState() {
    super.initState();
    totalPrice.value = h.getTotal(widget.detail);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('pesanan')
          .doc(widget.order_id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            body: Container(),
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              titleSpacing: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: Theme.of(context).primaryColor,
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Detail Pesanan',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 17),
                  ),
                ],
              ),
              actions: [
                IconButton(onPressed: () {}, icon: Icon(MdiIcons.chat))
              ],
            ),
          );
        } else {
          var orderData = snapshot.data!.data()!;
          var reverse = snapshot.data!['timeline'].reversed.toList();
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.grey))),
                      child: const Row(
                        children: [
                          Text(
                            'Detail Transaksi',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                                fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                    child: Text(
                                  'No. Pesanan',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      fontSize: 14),
                                )),
                                Expanded(
                                    child: Text(
                                  orderData['order_id'],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Poppins',
                                      fontSize: 14),
                                )),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                    child: Text(
                                  'Tanggal Buat Pesanan',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      fontSize: 14),
                                )),
                                Expanded(
                                    child: Text(
                                  DateFormat('EEEE, dd-MM-yyyy HH:mm:ss',
                                          const Locale('id').languageCode)
                                      .format(
                                          DateTime.parse(orderData['created'])),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Poppins',
                                      fontSize: 14),
                                )),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: GlobalVar.currentUser.user_role != 'tenant',
                          child: Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.grey))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Expanded(
                                      child: Text(
                                    'Tenant',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poppins',
                                        fontSize: 14),
                                  )),
                                  Expanded(
                                      child: Text(
                                    orderData['tenant_name'],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Poppins',
                                        fontSize: 14),
                                  )),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: GlobalVar.currentUser.user_role == 'tenant',
                          child: Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.grey))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Expanded(
                                      child: Text(
                                    'Nama Pembeli',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poppins',
                                        fontSize: 14),
                                  )),
                                  Expanded(
                                      child: Text(
                                    orderData['user_name'],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Poppins',
                                        fontSize: 14),
                                  )),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: GlobalVar.currentUser.user_role == 'tenant',
                          child: Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.grey))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Expanded(
                                      child: Text(
                                    'Email Pembeli',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poppins',
                                        fontSize: 14),
                                  )),
                                  Expanded(
                                      child: Text(
                                    orderData['user_email'],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Poppins',
                                        fontSize: 14),
                                  )),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                    child: Text(
                                  'Status Pesanan',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      fontSize: 14),
                                )),
                                Expanded(
                                    child: Text(
                                  orderData['lastStatus'] == 'NEW'
                                      ? 'PESANAN DIBUAT'
                                      : orderData['lastStatus'],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Poppins',
                                      fontSize: 14),
                                )),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: orderData.containsKey('rejectReason'),
                          child: Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.grey))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Expanded(
                                      child: Text(
                                    'Alasan Penolakan',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poppins',
                                        fontSize: 14),
                                  )),
                                  Expanded(
                                      child: Text(
                                    orderData.containsKey('rejectReason')
                                        ? orderData['rejectReason']
                                        : '',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Poppins',
                                        fontSize: 14),
                                  )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    color: Colors.grey[300],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.grey))),
                              child: const Padding(
                                padding: EdgeInsets.all(12),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Detail Pesanan',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Poppins',
                                        fontSize: 17),
                                  ),
                                ),
                              ),
                            ),
                            Obx(() => AnimatedSize(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.decelerate,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: h.isExpanded.value
                                        ? orderData['detail'].length
                                        : 1,
                                    itemBuilder: (context, menuIndex) {
                                      var menuData =
                                          orderData['detail'][menuIndex];
                                      return Container(
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey))),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 80,
                                                width: 80,
                                                child: CachedNetworkImage(
                                                    colorBlendMode:
                                                        BlendMode.saturation,
                                                    fit: BoxFit.fill,
                                                    imageUrl:
                                                        menuData['menu_image']),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                          flex: 1,
                                                          child: Text(
                                                            menuData[
                                                                'menu_name'],
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          )),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                          flex: 1,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Container(
                                                                height: 44,
                                                                width: 44,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    color: Color(int.parse(
                                                                        "#FFF0F0F0".replaceAll(
                                                                            '#',
                                                                            ""),
                                                                        radix:
                                                                            16))),
                                                                child: Text(
                                                                  menuData[
                                                                          'quantity']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor),
                                                                ),
                                                              ),
                                                            ],
                                                          ))
                                                    ],
                                                  ),
                                                  Visibility(
                                                    visible: menuData['notes']
                                                        .isNotEmpty,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Column(
                                                        children: [
                                                          RichText(
                                                              text: TextSpan(
                                                                  children: [
                                                                const TextSpan(
                                                                    text:
                                                                        'Catatan: ',
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xFF979797),
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500)),
                                                                TextSpan(
                                                                    text: menuData[
                                                                        'notes'],
                                                                    style: const TextStyle(
                                                                        color: Color(
                                                                            0xFF979797),
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500)),
                                                              ])),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(menuData['status'],
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xFF979797),
                                                          fontFamily: 'Poppins',
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700)),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        NumberFormat.currency(
                                                                locale: 'id_ID',
                                                                decimalDigits:
                                                                    0,
                                                                symbol: 'Rp')
                                                            .format(menuData[
                                                                'menu_price']),
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Poppins',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ))
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )),
                            Obx(
                              () => Visibility(
                                visible: orderData['detail'].length > 1,
                                child: GestureDetector(
                                  onTap: () {
                                    h.isExpanded.value = !h.isExpanded.value;
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey))),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            h.isExpanded.value
                                                ? 'Lihat lebih sedikit'
                                                : 'Lihat ${orderData['detail'].length - 1} Produk Lainnya',
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w700,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                          Icon(
                                            h.isExpanded.value
                                                ? MdiIcons.chevronUp
                                                : MdiIcons.chevronDown,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Visibility(
                                    visible: orderData['voucherApplied'],
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Subtotal',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryTextTheme
                                                    .headlineLarge!
                                                    .color,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14),
                                          ),
                                          Text(
                                              NumberFormat.currency(
                                                locale:
                                                    '${Localizations.localeOf(context)}_ID',
                                                decimalDigits: 0,
                                                symbol: 'Rp',
                                              ).format(totalPrice.value),
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryTextTheme
                                                      .headlineLarge!
                                                      .color,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: orderData['voucherApplied'],
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Voucher',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryTextTheme
                                                    .headlineLarge!
                                                    .color,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14),
                                          ),
                                          Text(
                                              '- ${NumberFormat.currency(
                                                locale:
                                                    '${Localizations.localeOf(context)}_ID',
                                                decimalDigits: 0,
                                                symbol: 'Rp',
                                              ).format(orderData.containsKey('voucher_value') ? orderData['voucher_value'] : 0)}',
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total Akhir',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryTextTheme
                                                .headlineLarge!
                                                .color,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      ),
                                      Obx(() => Text(
                                          NumberFormat.currency(
                                            locale:
                                                '${Localizations.localeOf(context)}_ID',
                                            decimalDigits: 0,
                                            symbol: 'Rp',
                                          ).format(orderData['voucherApplied']
                                              ? totalPrice.value -
                                                  orderData['voucher_value']
                                              : totalPrice.value),
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryTextTheme
                                                  .headlineLarge!
                                                  .color,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16))),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 12, top: 12, bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status Pesanan',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .headlineLarge!
                                  .color,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                        ),
                        Column(
                          children:
                              List<Widget>.generate(reverse.length, (index) {
                            return TimelineMaker(
                                indicatorXY: 0.5,
                                isCompelete:
                                    reverse[index]['status'] == 'COMPLETED',
                                isFirst: index == 0,
                                isLast: index == reverse.length - 1,
                                isPast: (index != 0 && (reverse.length != 1)),
                                isClosed:
                                    reverse[index]['status'] == 'REJECTED',
                                endChild: ListView(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              reverse[index]['status'] == 'NEW'
                                                  ? 'PESANAN DIBUAT'
                                                  : reverse[index]['status'],
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14),
                                            )),
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                              DateFormat(
                                                      'EEEE, dd-MM-yyyy HH:mm',
                                                      const Locale('id')
                                                          .languageCode)
                                                  .format(DateTime.tryParse(
                                                      reverse[index]['date'])!),
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                                padding: 0,
                                height: 70);
                          }),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            bottomNavigationBar: GlobalVar.currentUser.user_role == 'tenant'
                ? Visibility(
                    visible: (orderData['lastStatus'] != 'REJECTED' &&
                        orderData['lastStatus'] != 'COMPLETED'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      decoration:
                          const BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3))
                      ]),
                      child: orderData['lastStatus'] == 'ONGOING'
                          ? Row(
                              children: [
                                Expanded(
                                    child: InkWell(
                                        onTap: () async {
                                          h.readyOrder(
                                                  orderData['order_id'],
                                                  orderData['timeline'],
                                                  context);
                                        },
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: const Color(0xFFFF9800),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: const Center(
                                            child: Text(
                                              'Pesanan Siap Diambil',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ))),
                              ],
                            )
                          : orderData['lastStatus'] == 'READY'
                              ? Row(
                                  children: [
                                    Expanded(
                                        child: InkWell(
                                            onTap: () async {
                                              h.completeOrder(
                                                  orderData['order_id'],
                                                  orderData['timeline'],
                                                  context);
                                            },
                                            child: Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFF9C27B0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: const Center(
                                                child: Text(
                                                  'Selesaikan Pesanan',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                            ))),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: InkWell(
                                            onTap: () async {
                                              h.showRejectModal(
                                                  context,
                                                  orderData['order_id'],
                                                  orderData['timeline'],
                                                  orderData['user_email'],
                                                  widget.detail,
                                                  orderData['voucherApplied']);
                                            },
                                            child: Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: const Center(
                                                child: Text(
                                                  'Tolak',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                            ))),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: InkWell(
                                            onTap: () async {
                                              h.acceptOrder(
                                                  orderData['order_id'],
                                                  orderData['timeline'],
                                                  context);
                                            },
                                            child: Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: const Center(
                                                child: Text(
                                                  'Terima',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                            )))
                                  ],
                                ),
                    ),
                  )
                : Visibility(
                    visible: orderData['lastStatus'] == 'COMPLETED',
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      decoration:
                          const BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3))
                      ]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: InkWell(
                                  onTap: () async {},
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: const Center(
                                      child: Text(
                                        'Ulasan',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  )))
                        ],
                      ),
                    ),
                  ),
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              titleSpacing: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: Theme.of(context).primaryColor,
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Detail Pesanan',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 17),
                  ),
                ],
              ),
              actions: [
                IconButton(onPressed: () {}, icon: Icon(MdiIcons.chat))
              ],
            ),
          );
        }
      },
    );
  }
}
