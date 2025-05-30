import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:skripsi/Controllers/CartPageController.dart';
import 'package:skripsi/GlobalVar.dart';

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
                              Checkbox(
                                value: c.userCart[index].checked.value,
                                onChanged: (value) {},
                                activeColor: Theme.of(context).primaryColor,
                              ),
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
                          itemCount: c.userCart[index].foodList.length,
                          itemBuilder: (context, menuIndex) {
                            var currentMenu =
                                c.userCart[index].foodList[menuIndex];
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
                                              Checkbox(
                                                value:
                                                    currentMenu.checked.value,
                                                onChanged: (value) {},
                                                activeColor: Theme.of(context)
                                                    .primaryColor,
                                              ),
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
                                                                          () {},
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
                                                                          () {},
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
                                                                                .w500,
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
                                                                          () {},
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
                                                                            FontWeight
                                                                                .w500)),
                                                                TextSpan(
                                                                    text:
                                                                        '${currentMenu.notes}',
                                                                    style: const TextStyle(
                                                                        color:Color(0xFF979797),
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500)),
                                                              ])),
                                                  const SizedBox(height: 8,),
                                                  
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: RichText(
                                                          text: TextSpan(
                                                              children: [
                                                            const TextSpan(
                                                                text:
                                                                    'Stok: ',
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xFF979797),
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500)),
                                                            TextSpan(
                                                                text:
                                                                    '${menuData['menu_stock']}',
                                                                style: const TextStyle(
                                                                    color: Color(0xFF979797),
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500)),
                                                          ])),
                                                    ),
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
                        )
                      ],
                    );
                  },
                ))
          ],
        ),
      )),
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
