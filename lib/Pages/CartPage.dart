import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:skripsi/Controllers/CartPageController.dart';
import 'package:skripsi/Data%20Model/menu.dart';
import 'package:skripsi/GlobalVar.dart';
import 'package:skripsi/Pages/CheckoutPage.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  CartPageController c = Get.put(CartPageController());
  @override
  void initState() {
    super.initState();
    c.getUserCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() => ListView.builder(
                  shrinkWrap: true,
                  itemCount: c.userCart.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 5),
                          child: Row(
                            children: [
                              Obx(() => Checkbox(
                                    value: c.userCart[index].checked.value,
                                    onChanged: (value) {
                                      if (!c
                                          .hasOtherCartWithProductsTickedMoreThanOne(
                                              index)) {
                                        c.tenantCheckboxClick(index, value!);
                                      }
                                    },
                                    activeColor: Theme.of(context).primaryColor,
                                  )),
                              const Text(
                                'Tenant : ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                c.userCart[index].tenant_name,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: c.userCart[index].menuList.length,
                          itemBuilder: (context, menuIndex) {
                            var currentMenu =
                                c.userCart[index].menuList[menuIndex];
                            return StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('menu list')
                                  .doc(currentMenu.menu_id)
                                  .snapshots(),
                              builder: (context, menuSnapshot) {
                                if (!menuSnapshot.hasData) {
                                  return Container();
                                } else {
                                  var menuData = menuSnapshot.data!.data()!;
                                  c.userCart[index].menuList[menuIndex]
                                      .menu_stock = menuData['menu_stock'];
                                  c.userCart[index].menuList[menuIndex]
                                      .menu_price = menuData['menu_price'];
                                  c.userCart[index].menuList[menuIndex]
                                      .isActive!.value = menuData['isActive'];
                                  c.userCart[index].menuList[menuIndex]
                                      .currentMenu = menu.fromJson(menuData);
                                  return Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                color: Colors.grey[400]!))),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4, right: 8, top: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Obx(() => IgnorePointer(
                                                ignoring: (menuData[
                                                                    'menu_stock'] ==
                                                                0 ||
                                                            menuData[
                                                                    'isActive'] ==
                                                                false),
                                                child: Checkbox(
                                                      value: currentMenu
                                                          .checked.value,
                                                      onChanged: (value) {
                                                        if (!c
                                                            .hasOtherCartWithProductsTickedMoreThanOne(
                                                                index)) {
                                                          c.menuCheckboxClick(
                                                              index,
                                                              menuIndex,
                                                              value!);
                                                        }
                                                      },
                                                      activeColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                    ),
                                              )),
                                              SizedBox(
                                                height: 80,
                                                width: 80,
                                                child: CachedNetworkImage(
                                                    color: (menuData[
                                                                    'menu_stock'] ==
                                                                0 ||
                                                            menuData[
                                                                    'isActive'] ==
                                                                false)
                                                        ? Colors.grey[400]
                                                        : Colors.transparent,
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
                                                          child: (menuData[
                                                                          'menu_stock'] ==
                                                                      0 ||
                                                                  menuData[
                                                                          'isActive'] ==
                                                                      false)
                                                              ? Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    IconButton(
                                                                      icon:
                                                                          Icon(
                                                                        MdiIcons
                                                                            .trashCan,
                                                                        color: Colors
                                                                            .red,
                                                                        size:
                                                                            24,
                                                                      ),
                                                                      iconSize:
                                                                          24,
                                                                      onPressed:
                                                                          () {
                                                                            c.showDeleteModal(context, currentMenu.menu_id);
                                                                          },
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                    ),
                                                                  ],
                                                                )
                                                              : Row(
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        c.subtractQty(
                                                                            currentMenu.quantity,
                                                                            currentMenu.menu_stock!,
                                                                            currentMenu,
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            28,
                                                                        height:
                                                                            28,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.red,
                                                                            borderRadius: BorderRadius.circular(8)),
                                                                        child:
                                                                            const Center(
                                                                          child:
                                                                              Icon(
                                                                            Icons.remove,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                14,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    Container(
                                                                      height:
                                                                          44,
                                                                      width: 44,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              10),
                                                                          color: Color(int.parse(
                                                                              "#FFF0F0F0".replaceAll('#', ""),
                                                                              radix: 16))),
                                                                      child:
                                                                          Text(
                                                                        currentMenu
                                                                            .quantity
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .w700,
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            color:
                                                                                Theme.of(context).primaryColor),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        c.addQty(
                                                                            currentMenu.quantity,
                                                                            currentMenu.menu_stock!,
                                                                            currentMenu);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            28,
                                                                        height:
                                                                            28,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.blue,
                                                                            borderRadius: BorderRadius.circular(8)),
                                                                        child:
                                                                            const Center(
                                                                          child:
                                                                              Icon(
                                                                            Icons.add,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                14,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ))
                                                    ],
                                                  ),
                                                  Visibility(
                                                    visible: currentMenu
                                                        .notes.isNotEmpty,
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
                                                                    text: currentMenu
                                                                        .notes,
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
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: RichText(
                                                        text:
                                                            TextSpan(children: [
                                                      const TextSpan(
                                                          text: 'Stok: ',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF979797),
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                      TextSpan(
                                                          text:
                                                              '${menuData['menu_stock']}',
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xFF979797),
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                    ])),
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
                                                      IconButton(
                                                        onPressed: () {
                                                          if ((menuData[
                                                                      'menu_stock'] ==
                                                                  0 ||
                                                              menuData[
                                                                      'isActive'] ==
                                                                  false)) {
                                                          } else {
                                                            c.showNotesModal(
                                                                context,
                                                                currentMenu
                                                                    .notes,
                                                                currentMenu
                                                                    .menu_id);
                                                          }
                                                        },
                                                        icon: Icon(MdiIcons
                                                            .fileDocumentEdit),
                                                        iconSize: 32,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                        index != c.userCart.length - 1
                            ? Container(
                                height: 10,
                                width: Get.width,
                                color: Colors.grey[300],
                              )
                            : Container()
                      ],
                    );
                  },
                ))
          ],
        ),
      )),
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
                          .format(c.totalPrice.value),
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
                      List<cartList> checkedList = await c.filterList();
                      Get.to(CheckoutPage(items: checkedList));
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text(
                          'Checkout',
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Keranjang',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
            const SizedBox(width: 5),
            Badge(
              textStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              backgroundColor: Colors.white,
              largeSize: 30,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              label: Obx(() => Text(
                    GlobalVar.cartCount.value.toString(),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700),
                  )),
              isLabelVisible: true,
            ),
          ],
        ),
      ),
    );
  }
}
