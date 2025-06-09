import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_imagekit/flutter_imagekit.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ntp/ntp.dart';
import 'package:skripsi/GlobalVar.dart';
import 'package:skripsi/Widgets/PopUpLoading.dart';

class AddReviewPageController extends GetxController {
  RxString selectedImage = ''.obs;
  showReviewModal(BuildContext context, String menu_name, String menu_id,
      String order_id, dynamic review) {
    selectedImage.value = '';
    RxDouble value = 0.0.obs;
    TextEditingController reviewTF = TextEditingController();
    if (review != null) {
      value.value = review['rating'];
      reviewTF.text = review['comment'];
    }
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
                    child: SingleChildScrollView(
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
                                    ignoreGestures: review != null,
                                    unratedColor: Colors.grey,
                                    tapOnlyMode: true,
                                    itemSize: 50,
                                    itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Color(0xFFF8D24C)),
                                    onRatingUpdate: (newValue) {
                                      value.value = newValue;
                                    },
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Komentar',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 13),
                          TextFormField(
                            controller: reviewTF,
                            readOnly: review != null,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey, width: 1)),
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
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Tambah Gambar',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Center(
                              child: Obx(() => GestureDetector(
                                    onTap: () {
                                      selectedImage.value = '';
                                    },
                                    child: Badge(
                                      isLabelVisible:
                                          (selectedImage.isNotEmpty),
                                      textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      backgroundColor: Colors.red,
                                      largeSize: 30,
                                      offset: const Offset(10, -10),
                                      label: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (review == null) {
                                            pickImage(context);
                                          }
                                        },
                                        child: DottedBorder(
                                          color: Colors.grey,
                                          radius: const Radius.circular(4),
                                          child: SizedBox(
                                            width: 111,
                                            height: 111,
                                            child: review != null
                                                ? CachedNetworkImage(
                                                    imageUrl: review['image'])
                                                : selectedImage.value.isNotEmpty
                                                    ? Image.file(File(
                                                        selectedImage.value))
                                                    : const Icon(
                                                        Icons
                                                            .add_photo_alternate_rounded,
                                                        size: 80,
                                                      ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )))
                        ],
                      ),
                    )),
              ),
              Visibility(
                visible: review == null,
                child: Container(
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
                    onTap: () async {
                      DateTime today = await NTP.now();
                      addMenuReview(context, value.value, reviewTF.text,
                          selectedImage.value, today, order_id, menu_id);
                    },
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
              ),
            ],
          ),
        );
      },
    );
  }

  pickImage(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => Container(
              height: 291 + MediaQuery.of(context).viewInsets.bottom,
              decoration: BoxDecoration(
                  color: Theme.of(context).expansionTileTheme.iconColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(30))),
              child: Column(
                children: [
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Import Gambar',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 20),
                          ),
                          GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(
                                MdiIcons.closeCircle,
                                size: 32,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Pilih cara untuk memasukkan gambar',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      getFromCamera();
                                      Get.back();
                                    },
                                    child: Column(
                                      children: [
                                        DottedBorder(
                                          color: Colors.black,
                                          child: SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: Icon(
                                              Icons.camera_alt,
                                              size: 50,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Text(
                                          'Kamera',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Poppins',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      getFromGallery();
                                      Get.back();
                                    },
                                    child: Column(
                                      children: [
                                        DottedBorder(
                                          color: Colors.black,
                                          child: SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: Icon(
                                              Icons.add_photo_alternate_rounded,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 50,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Text(
                                          'Galeri',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Poppins',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }

  getFromGallery() async {
    try {
      final pickedFile = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 50);
      if (pickedFile == null) {
        return;
      } else {
        selectedImage.value = pickedFile.path;
      }
    } catch (e) {
      print('error $e');
      return;
    }
  }

  getFromCamera() async {
    try {
      final pickedFile = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 50);
      if (pickedFile == null) {
        return;
      } else {
        selectedImage.value = pickedFile.path;
      }
    } catch (e) {
      return;
    }
  }

  addMenuReview(
      BuildContext context,
      double rating,
      String comment,
      String imagePath,
      DateTime created,
      String order_id,
      String menu_id) async {
    PopUpLoading().showdialog(context);
    String imageLink = '';
    if (imagePath.isNotEmpty) {
      imageLink = await sendToStorage(order_id, imagePath);
    }
    await FirebaseFirestore.instance
        .collection('menu list')
        .doc(menu_id)
        .collection('reviews')
        .doc(order_id)
        .set({
      'rating': rating,
      'image': imageLink,
      'createdBy': GlobalVar.currentUser.user_email,
      'createdByName': GlobalVar.currentUser.user_name,
      'created': DateFormat('yyyy-MM-dd HH:mm:ss').format(created),
      'comment': comment
    }).then((value) async {
      double average = 0;
      var countQuery = await FirebaseFirestore.instance
          .collection('menu list')
          .doc(menu_id)
          .collection('reviews')
          .count()
          .get();
      var oldAvgQuery = await FirebaseFirestore.instance
          .collection('menu list')
          .doc(menu_id)
          .get();
      var oldAvg = oldAvgQuery.data()!['averageRating'];
      var count = countQuery.count ?? 1;
      average = ((oldAvg * (count - 1) + rating)) / (count);
      await FirebaseFirestore.instance.collection('menu list').doc(menu_id).set(
          {'averageRating': double.parse(average.toStringAsFixed(2))},
          SetOptions(merge: true));
      Get.back();
      Get.back();
    });
  }

  Future<String> sendToStorage(String orderID, String image) async {
    String imagePath = '';
    imagePath = await ImageKit.io(
        folder: 'ReviewImage/$orderID',
        File(image),
        privateKey: GlobalVar.carouselToken);

    return imagePath;
  }
}
