import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                        Get.to(HistoryDetailPage(order_id: order.order_id, detail: order.detail,));
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
                                                        fontWeight: FontWeight.w500,
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
                                                        color: Theme.of(context).primaryColor,
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
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Riwayat Pesanan',
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
