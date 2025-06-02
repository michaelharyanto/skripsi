import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:skripsi/Controllers/MenuFragmentController.dart';
import 'package:skripsi/Pages/AddMenuPage.dart';
import 'package:skripsi/Pages/EditMenuPage.dart';

class MenuFragment extends StatefulWidget {
  const MenuFragment({super.key});

  @override
  State<MenuFragment> createState() => _MenuFragmentState();
}

class _MenuFragmentState extends State<MenuFragment> {
  MenuFragmentController m = Get.put(MenuFragmentController());
  @override
  void initState() {
    super.initState();
    m.initMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              TextFormField(
                // controller: emailTF,
                style: const TextStyle(
                    fontFamily: 'Poppins', fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: 'Cari Produk...',
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
              const SizedBox(
                height: 10,
              ),
              Obx(() => Expanded(
                      child: ListView.builder(
                    itemCount: m.menuList.length,
                    itemBuilder: (context, index) {
                      var menu = m.menuList[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Material(
                          color: Colors.white,
                          elevation: 5,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 80,
                                          width: 80,
                                          child: CachedNetworkImage(
                                              color: (menu.menu_stock == 0 ||
                                                      !(menu.isActive!.value))
                                                  ? Colors.grey[400]
                                                  : Colors.transparent,
                                              colorBlendMode:
                                                  BlendMode.saturation,
                                              fit: BoxFit.fill,
                                              imageUrl: menu.menu_image!),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              Get.to(EditMenuPage(
                                                  currentMenu: menu));
                                            },
                                            icon: Icon(
                                              MdiIcons.pencil,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ))
                                      ],
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    flex: 3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          menu.menu_name!,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w700),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
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
                                            CupertinoSwitch(
                                              value: menu.isActive!.value,
                                              onChanged: (value) {
                                                FirebaseFirestore.instance
                                                    .collection('menu list')
                                                    .doc(menu.menu_id)
                                                    .update(
                                                        {'isActive': value});
                                              },
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Stok: ${menu.menu_stock}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Visibility(
                                                visible: menu.menu_stock! <= 0,
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 5,
                                                      horizontal: 8),
                                                  decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: const Text(
                                                    'STOK HABIS',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily: 'Poppins',
                                                        fontSize: 14,
                                                        color: Colors.white),
                                                  ),
                                                )),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                                child: InkWell(
                                              onTap: () {
                                                m.showEditModal(context, menu);
                                              },
                                              child: Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xFFA8AAB7)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: const Center(
                                                  child: Text(
                                                    'Ubah Stok',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'Poppins',
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                              ),
                                            )),
                                          ],
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )))
            ],
          ),
        ),
      ),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Menu',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 18),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(const AddMenuPage());
            },
            icon: const Icon(
              Icons.add,
              size: 30,
            ),
          )
        ],
      ),
    );
  }
}
