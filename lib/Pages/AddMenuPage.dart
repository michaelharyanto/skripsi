import 'dart:io';

import 'package:animated_visibility/animated_visibility.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:skripsi/Controllers/AddMenuPageController.dart';
import 'package:skripsi/GlobalVar.dart';
import 'package:skripsi/Widgets/HeroPhotoView.dart';

class AddMenuPage extends StatefulWidget {
  const AddMenuPage({super.key});

  @override
  State<AddMenuPage> createState() => _AddMenuPageState();
}

class _AddMenuPageState extends State<AddMenuPage> {
  AddMenuPageConrtoller a = Get.put(AddMenuPageConrtoller());
  GlobalKey<FormState> key = GlobalKey<FormState>();
  var nameTF = TextEditingController(),
      descTF = TextEditingController(),
      priceTF = TextEditingController(),
      stockTF = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Form(
              key: key,
              child: Column(
                children: [
                  Expanded(
                      child: SingleChildScrollView(
                    child: Container(
                      width: Get.width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 13),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: GestureDetector(
                            onTap: () {
                              a.getImageFromGallery();
                            },
                            child: Obx(
                              () => DottedBorder(
                                  borderType: BorderType.RRect,
                                  color: a.imagePath.value.isEmpty
                                      ? Colors.red
                                      : Colors.black,
                                  radius: const Radius.circular(40),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 160,
                                        height: 160,
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFEBEBEB),
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        child: a.imagePath.value.isEmpty
                                            ? const Icon(
                                                Icons.add_photo_alternate,
                                                size: 100,
                                              )
                                            : Center(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    a.invokeButtonFunc();
                                                  },
                                                  child: Hero(
                                                    tag: 'image',
                                                    child: Image.file(File(
                                                        a.imagePath.value)),
                                                  ),
                                                ),
                                              ),
                                      ),
                                      Visibility(
                                          child: Positioned(
                                              bottom: 0,
                                              left: 15,
                                              right: 15,
                                              child: AnimatedVisibility(
                                                visible: a.invokeButton.value,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      child: IconButton(
                                                          onPressed: () {
                                                            Get.to(HeroPhotoView(
                                                                imagePath: a
                                                                    .imagePath
                                                                    .value,
                                                                tag: 'image'));
                                                          },
                                                          icon: const Icon(
                                                            Icons.visibility,
                                                            color: Colors.white,
                                                          )),
                                                    ),
                                                    CircleAvatar(
                                                      backgroundColor:
                                                          Colors.red,
                                                      child: IconButton(
                                                          onPressed: () {
                                                            a.imagePath.value =
                                                                '';
                                                          },
                                                          icon: Icon(
                                                            MdiIcons.trashCan,
                                                            color: Colors.white,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              )))
                                    ],
                                  )),
                            ),
                          )),
                          const SizedBox(
                            height: 4,
                          ),
                          Obx(() => Visibility(
                              visible: a.imagePath.value.isEmpty,
                              child: const Center(
                                child: Text(
                                  'Wajib Unggah Gambar',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontFamily: 'Poppins',
                                      fontSize: 14),
                                ),
                              ))),
                          const SizedBox(
                            height: 20,
                          ),
                          const Row(
                            children: [
                              Text(
                                'Nama Menu',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '*',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          TextFormField(
                            controller: nameTF,
                            validator: (value) {
                              return value!.isEmpty ? 'Harus diisi' : null;
                            },
                            style: const TextStyle(
                                color: Color(0xFF60626E),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.red)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.grey)),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Row(
                            children: [
                              Text(
                                'Deskripsi Menu',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '*',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          TextFormField(
                            controller: descTF,
                            validator: (value) {
                              return value!.isEmpty ? 'Harus diisi' : null;
                            },
                            style: const TextStyle(
                                color: Color(0xFF60626E),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.red)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.grey)),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Row(
                            children: [
                              Text(
                                'Harga Produk',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '*',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          TextFormField(
                            controller: priceTF,
                            validator: (value) {
                              return value!.isEmpty ? 'Harus diisi' : null;
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              CurrencyTextInputFormatter.currency(
                                  decimalDigits: 0,
                                  locale: const Locale('id', 'ID').countryCode,
                                  symbol: '')
                            ],
                            style: const TextStyle(
                                color: Color(0xFF60626E),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.red)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.grey)),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Row(
                            children: [
                              Text(
                                'Stok Produk',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '*',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          TextFormField(
                            controller: stockTF,
                            validator: (value) {
                              return value!.isEmpty ? 'Harus diisi' : null;
                            },
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                                color: Color(0xFF60626E),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.red)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.grey)),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: InkWell(
                              onTap: () {
                                var isValid = key.currentState?.validate();
                                if (isValid! && a.imagePath.value.isNotEmpty) {
                                  var price = int.tryParse(priceTF
                                          .text.removeAllWhitespace
                                          .trim()
                                          .replaceAll('.', '')) ??
                                      0;
                                  var stock = int.tryParse(stockTF
                                          .text.removeAllWhitespace
                                          .trim()
                                          .replaceAll('.', '')) ??
                                      0;
                                  a.showAddModal(context, a.imagePath.value, nameTF.text,
                                      descTF.text, price, stock, GlobalVar.currentUser.user_id);
                                }
                              },
                              child: Container(
                                width: Get.width,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(8)),
                                child: const Center(
                                  child: Text(
                                    'Simpan & Kirim',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ))
                ],
              ))),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Tambah Menu',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 18),
        ),
      ),
    );
  }
}
