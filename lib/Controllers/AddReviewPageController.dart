import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AddReviewPageController extends GetxController {
  RxString selectedImage = ''.obs;
  showReviewModal(BuildContext context, String menu_name) {
    RxDouble value = 0.0.obs;
    TextEditingController reviewTF = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          height: Get.height * 0.5 + MediaQuery.of(context).viewInsets.bottom,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
          child: Column(
            children: [
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      menu_name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        MdiIcons.closeCircle,
                        size: 32,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),
                    child: Column(
                      children: [
                        const Text(
                          'Ulas Menu',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(() => RatingBar.builder(
                                  initialRating: value.value,
                                  maxRating: 5,
                                  minRating: 0,
                                  direction: Axis.horizontal,
                                  itemCount: 5,
                                  // ignoreGestures: foodRating != null,
                                  unratedColor: Colors.grey,
                                  tapOnlyMode: true,
                                  itemSize: 50,
                                  itemBuilder: (context, _) => Icon(Icons.star,
                                      color: Color(int.parse(
                                          "#FFF8D24C".replaceAll('#', ""),
                                          radix: 16))),
                                  onRatingUpdate: (newValue) {
                                    value.value = newValue;
                                  },
                                )),
                          ],
                        ),
                        Text(
                          'Komentar',
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .headlineLarge!
                                  .color,
                              fontFamily: 'SF-Pro-Display',
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 13),
                        TextFormField(
                          controller: reviewTF,
                          // readOnly: foodRating != null,
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
                            filled: true,
                            fillColor: Colors.white,
                            isDense: true,
                          ),
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.black),
                          textAlign: TextAlign.left,
                          minLines: 1,
                          maxLines: 4,
                          keyboardType: TextInputType.multiline,
                        ),
                        Center(
                            child: GestureDetector(
                          onTap: () {
                            
                              selectedImage.value = '';
                            
                          },
                          child: Badge(
                            isLabelVisible: (selectedImage.isNotEmpty ),
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            backgroundColor: Colors.red,
                            largeSize: 30,
                            offset: Offset(10, -10),
                            label: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                // pickImage(3, context);
                              },
                              child: DottedBorder(
                                color: Color(int.parse(
                                    "#FF979797".replaceAll('#', ""),
                                    radix: 16)),
                                radius: Radius.circular(4),
                                child: Container(
                                  width: 111,
                                  height: 111,
                                  child: 
                                  // foodRating != null
                                  //     ? CachedNetworkImage(
                                  //         imageUrl: selectedImage3.value)
                                  //     : 
                                      selectedImage.value.isNotEmpty
                                          ? Image.file(
                                              File(selectedImage.value))
                                          : Icon(Icons.add_photo_alternate_rounded),
                                ),
                              ),
                            ),
                          ),
                        ))
                      ],
                    )),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration:
                    const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3))
                ]),
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Tambah',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
