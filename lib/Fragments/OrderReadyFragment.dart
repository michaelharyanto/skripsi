import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skripsi/Controllers/CheckoutPageController.dart';
import 'package:skripsi/Controllers/OrderFragmentsController.dart';
import 'package:skripsi/Pages/HistoryDetailPage.dart';
import 'package:skripsi/Widgets/StatusWidget.dart';

class OrderReadyFragment extends StatefulWidget {
  const OrderReadyFragment({super.key});

  @override
  State<OrderReadyFragment> createState() => _OrderReadyFragmentState();
}

class _OrderReadyFragmentState extends State<OrderReadyFragment> {
  OrderFragmentsController o = Get.put(OrderFragmentsController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    o.initReadyHistory();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
                    children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextFormField(
                // controller: searchTF,
                onChanged: (value) {
                  // m.searchMenu(value);
                },
                style: const TextStyle(
                    fontFamily: 'Poppins', fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: 'Cari Pesanan...',
                  hintStyle: const TextStyle(fontFamily: 'Poppins'),
                  prefixIcon: const Icon(Icons.search),
                  prefixIconColor: Colors.grey,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.red)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey)),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Obx(() => Expanded(
                    child: ListView.builder(
                  // controller: sc,
                  itemCount: o.readyHistoryList.length,
                  itemBuilder: (context, index) {
                    var order = o.readyHistoryList[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8, left: 10, right: 10, top: 8),
                      child: Material(
                        color: Colors.white,
                        elevation: 5,
                        child: InkWell(
                          onTap: () {
                            Get.to(HistoryDetailPage(
                              order_id: order.order_id,
                              detail: order.detail,
                            ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                                          fontFamily: 'Poppins',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      ':${order.order_id}',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: 'Poppins',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          Expanded(
                                            flex: 3,
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: Text(
                                                DateFormat('dd-MM-yyyy HH:mm:ss')
                                                    .format(order.created),
                                                style: TextStyle(
                                                    color: Colors.grey[400],
                                                    fontFamily: 'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700),
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
                                                  padding: const EdgeInsets.only(
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
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: const TextStyle(
                                                              color: Colors.black,
                                                              fontWeight:
                                                                  FontWeight.w500,
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
                                                visible: order.detail.length > 3,
                                                child: Text(
                                                  '+${order.detail.length - 3} Menu Lainnya',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontWeight: FontWeight.w700,
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
                                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                                      .format(order.voucherApplied
                                                          ? (CheckoutPageController()
                                                                  .getTenantTotal(
                                                                      order
                                                                          .detail) -
                                                              order
                                                                  .voucher_value!)
                                                          : CheckoutPageController()
                                                              .getTenantTotal(
                                                                  order.detail)),
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w700,
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
                    );
                  },
                )))
                    ],
                  ),
          )),
    );
  }
}