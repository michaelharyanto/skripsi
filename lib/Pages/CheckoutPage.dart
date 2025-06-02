import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skripsi/Controllers/CheckoutPageController.dart';
import 'package:skripsi/Data%20Model/menu.dart';
import 'package:skripsi/Widgets/ErrorSnackBar.dart';
import 'package:toggle_switch/toggle_switch.dart';

// ignore: must_be_immutable
class CheckoutPage extends StatefulWidget {
  List<cartList> items;
  CheckoutPage({super.key, required this.items});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  CheckoutPageController c = Get.put(CheckoutPageController());
  List<String> status = ['Dine In', 'Take Away'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.items.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var data = widget.items[index];
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey[400]!))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data.tenant_name,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.menuList.length,
                      itemBuilder: (context, menuIndex) {
                        var menu = data.menuList[menuIndex];
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 80,
                                width: 80,
                                child: CachedNetworkImage(
                                    colorBlendMode: BlendMode.saturation,
                                    fit: BoxFit.fill,
                                    imageUrl: menu.currentMenu!.menu_image!),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            menu.currentMenu!.menu_name!,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w700),
                                          )),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                    visible: menu.notes.isNotEmpty,
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        children: [
                                          RichText(
                                              text: TextSpan(children: [
                                            const TextSpan(
                                                text: 'Catatan: ',
                                                style: TextStyle(
                                                    color: Color(0xFF979797),
                                                    fontFamily: 'Poppins',
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            TextSpan(
                                                text: menu.notes,
                                                style: const TextStyle(
                                                    color: Color(0xFF979797),
                                                    fontFamily: 'Poppins',
                                                    fontSize: 14,
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        NumberFormat.currency(
                                                locale: 'id_ID',
                                                decimalDigits: 0,
                                                symbol: 'Rp')
                                            .format(menu.menu_price),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        'x${menu.quantity}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                              const SizedBox(
                                width: 10,
                              ),
                              ToggleSwitch(
                                animate: true,
                                animationDuration: 100,
                                cornerRadius: 0,
                                radiusStyle: false,
                                isVertical: true,
                                minWidth: 100,
                                minHeight: 30,
                                customTextStyles: const [
                                  TextStyle(fontFamily: 'Poppins')
                                ],
                                activeBgColor: [Theme.of(context).primaryColor],
                                inactiveBgColor: Colors.grey[300],
                                inactiveFgColor: Colors.black,
                                activeFgColor: Colors.white,
                                labels: status,
                                onToggle: (idx) {
                                  widget.items[index].menuList[menuIndex]
                                      .status = status[idx!];
                                  print(widget
                                      .items[index].menuList[menuIndex].status);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      color: Colors.grey[200],
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '(${data.menuList.length} Pesanan)',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            ),
                            Text(
                              NumberFormat.currency(
                                      locale: 'id_ID',
                                      decimalDigits: 0,
                                      symbol: 'Rp')
                                  .format(c.getTenantTotal(data.menuList)),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
            InkWell(
              onTap: () async {
                if (await c.checkUserVoucher(context)) {
                  c.showVoucherListModal(context, c.getTotal(widget.items));
                } else {
                  ErrorSnackBar().showSnack(
                      context,
                      'Anda sudah menggunakan jatah voucher untuk hari ini',
                      70);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Voucher',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Expanded(
                        child: Obx(() => Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Visibility(
                                  visible: c.currentVoucher.value.voucher_id
                                      .isNotEmpty,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 6),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xFFffe6e6)),
                                        color: const Color(0xFFffe6e6)),
                                    child: Text(
                                      NumberFormat.currency(
                                              locale: 'id_ID',
                                              decimalDigits: 0,
                                              symbol: 'Rp')
                                          .format(c.currentVoucher.value
                                              .voucher_value),
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Poppins',
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey,
                                ),
                              ],
                            ))),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    'Rincian Pembayaran',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Subtotal',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          NumberFormat.currency(
                                  locale: 'id_ID',
                                  decimalDigits: 0,
                                  symbol: 'Rp')
                              .format(c.getTotal(widget.items)),
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  Obx(() => Visibility(
                        visible: c.currentVoucher.value.voucher_id.isNotEmpty,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Potongan Voucher',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '-${NumberFormat.currency(locale: 'id_ID', decimalDigits: 0, symbol: 'Rp').format(c.currentVoucher.value.voucher_value)}',
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                  Obx(() => Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Total Akhir',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  NumberFormat.currency(
                                          locale: 'id_ID',
                                          decimalDigits: 0,
                                          symbol: 'Rp')
                                      .format(c.getTotal(widget.items) -
                                          c.currentVoucher.value.voucher_value),
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
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
                child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Harga',
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF979797),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700),
                ),
                Obx(() => Text(
                      NumberFormat.currency(
                              locale: 'id_ID', decimalDigits: 0, symbol: 'Rp')
                          .format(c.getTotal(widget.items) -
                              c.currentVoucher.value.voucher_value),
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700),
                    )),
              ],
            )),
            Expanded(
                child: InkWell(
                    onTap: () async {
                      List<String> menu_ids = [];
                      menu_ids = await c.filterID(widget.items);
                      print(menu_ids);
                      c.showConfirmModal(context, widget.items.first, menu_ids);
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text(
                          'Pesan',
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
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Checkout',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
