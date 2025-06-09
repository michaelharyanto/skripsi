import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skripsi/Controllers/CheckoutPageController.dart';
import 'package:skripsi/Controllers/HistoryFragmentController.dart';
import 'package:skripsi/Pages/HistoryDetailPage.dart';
import 'package:skripsi/Widgets/StatusWidget.dart';

class HistoryFragment extends StatefulWidget {
  const HistoryFragment({super.key});

  @override
  State<HistoryFragment> createState() => _HistoryFragmentState();
}

class _HistoryFragmentState extends State<HistoryFragment> {
  HistoryFragmentController h = Get.put(HistoryFragmentController());
  ScrollController sc = ScrollController();
  TextEditingController fromTF = TextEditingController();
  TextEditingController toTF = TextEditingController();
  RxBool searchToggle = false.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    h.initHistory();
    sc.addListener(() {
      if (sc.position.pixels == sc.position.maxScrollExtent) {
        h.getMoreHistory();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Obx(() => Expanded(
                  child: ListView.builder(
                controller: sc,
                itemCount: h.historyList.length,
                itemBuilder: (context, index) {
                  var order = h.historyList[index];
                  return Material(
                    child: InkWell(
                      onTap: () {
                        Get.to(HistoryDetailPage(
                          order_id: order.order_id,
                          detail: order.detail,
                        ));
                      },
                      child: Container(
                        color: Colors.grey[300],
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: [
                                                    const Expanded(
                                                      child: Text(
                                                        'No. Pesanan',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        ':${order.order_id}',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                            Expanded(
                                              flex: 3,
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: Text(
                                                  DateFormat(
                                                          'dd-MM-yyyy HH:mm:ss')
                                                      .format(order.created),
                                                  style: TextStyle(
                                                      color: Colors.grey[400],
                                                      fontFamily: 'Poppins',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      border: Border.symmetric(
                                          horizontal:
                                              BorderSide(color: Colors.grey)),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 12),
                                            decoration: const BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors.grey))),
                                            child: Row(
                                              children: [
                                                RichText(
                                                    text: TextSpan(children: [
                                                  const TextSpan(
                                                    text: 'Tenant',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: 'Poppins',
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        ' : ${order.tenant_name}',
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'Poppins',
                                                        fontSize: 14),
                                                  ),
                                                ])),
                                              ],
                                            )),
                                        Container(
                                          width: Get.width,
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                children: List.generate(
                                                    order.detail.length <= 3
                                                        ? order.detail.length
                                                        : 3, (menuIndex) {
                                                  var menu =
                                                      order.detail[menuIndex];
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8),
                                                    child: SizedBox(
                                                      width: 100,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            width: 100,
                                                            height: 100,
                                                            decoration:
                                                                const BoxDecoration(
                                                                    color: Color(
                                                                        0xFFF5F5F5)),
                                                            child: CachedNetworkImage(
                                                                imageUrl: menu
                                                                    .currentMenu!
                                                                    .menu_image!),
                                                          ),
                                                          Text(
                                                            menu.currentMenu!
                                                                .menu_name!,
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 14),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Visibility(
                                                  visible:
                                                      order.detail.length > 3,
                                                  child: Text(
                                                    '+${order.detail.length - 3} Menu Lainnya',
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily: 'Poppins',
                                                        fontSize: 14),
                                                  ))
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            StatusWidget(
                                                statusName: order.lastStatus)
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              children: [
                                                RichText(
                                                    text: TextSpan(children: [
                                                  const TextSpan(
                                                    text: 'Total Harga: ',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: 'Poppins',
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  TextSpan(
                                                    text: NumberFormat.currency(
                                                            locale: 'id_ID',
                                                            decimalDigits: 0,
                                                            symbol: 'Rp')
                                                        .format(order
                                                                .voucherApplied
                                                            ? (CheckoutPageController()
                                                                    .getTenantTotal(
                                                                        order
                                                                            .detail) -
                                                                order
                                                                    .voucher_value!)
                                                            : CheckoutPageController()
                                                                .getTenantTotal(
                                                                    order
                                                                        .detail)),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily: 'Poppins',
                                                        fontSize: 14),
                                                  ),
                                                ])),
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )))
        ],
      )),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Riwayat Pesanan',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  searchToggle.value = !(searchToggle.value);
                });
              },
              child: const Icon(
                Icons.search,
                size: 30,
              ),
            )
          ],
        ),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(searchToggle.value ? 100 : 0),
            child: searchToggle.value? Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: FormBuilderDateTimePicker(
                            name: '',
                            controller: fromTF,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins'),
                            inputType: InputType.date,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                            format: DateFormat('dd-MM-yyyy'),
                            decoration: InputDecoration(
                                isDense: true,
                                filled: true,
                                fillColor: Colors.white,
                                suffixIcon: InkWell(
                                  onTap: () {
                                    fromTF.text = '';
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 20,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: Colors.grey)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        BorderSide(color: Colors.blue[400]!)),
                                labelStyle: TextStyle(
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    fontFamily: 'Poppins'),
                                labelText: 'Tanggal Awal'),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: FormBuilderDateTimePicker(
                              name: '',
                              controller: toTF,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins'),
                              inputType: InputType.date,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                              format: DateFormat('dd-MM-yyyy'),
                              decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      toTF.text = '';
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      size: 20,
                                    ),
                                  ),
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          const BorderSide(color: Colors.grey)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.blue[400]!)),
                                  labelStyle: TextStyle(
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      fontFamily: 'Poppins'),
                                  labelText: 'Tanggal Akhir'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: InkWell(
                      onTap: () {
                        h.searchHistory(fromTF.text, toTF.text);
                      },
                      child: Container(
                        width: Get.width,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.blue[700],
                            borderRadius: BorderRadius.circular(8)),
                        child: const Center(
                          child: Text(
                            'Cari',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ):const SizedBox.shrink()),
      ),
    );
  }
}
