import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_imagekit/flutter_imagekit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:skripsi/GlobalVar.dart';
import 'package:skripsi/Widgets/PopUpLoading.dart';

class EditMenuPageController extends GetxController {
  RxString imagePath = ''.obs;
  RxBool invokeButton = false.obs;

  getImageFromGallery() async {
    try {
      final pickedFile = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 50);
      if (pickedFile == null) {
        return;
      } else {
        imagePath.value = pickedFile.path;
      }
    } catch (e) {}
  }

  invokeButtonFunc() {
    invokeButton.value = true;
    Timer(const Duration(seconds: 2), () {
      invokeButton.value = false;
    });
  }

  showEditModal(BuildContext context, String menu_id, String imagePath,
      String menuName, String menuDesc, int menuPrice) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          height: Get.height * 0.2 + MediaQuery.of(context).viewInsets.bottom,
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
                    const Text(
                      'Edit Menu',
                      style: TextStyle(
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
              const Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Apakah Anda yakin untuk mengubah data menu ini?',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500))
                      ],
                    ),
                  ),
                ),
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
                  onTap: () {
                    editMenu(context, menu_id, imagePath, menuName, menuDesc,
                        menuPrice);
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
            ],
          ),
        );
      },
    );
  }

  editMenu(BuildContext context, String menu_id, String imagePath,
      String menuName, String menuDesc, int menuPrice) {
    PopUpLoading().showdialog(context);
    if (imagePath.isNotEmpty) {
      ImageKit.io(
              folder: 'Menu_Image',
              File(imagePath),
              privateKey: GlobalVar.carouselToken)
          .then((value) async {
        FirebaseFirestore.instance.collection('menu list').doc(menu_id).set({
          'menu_desc': menuDesc,
          'menu_image': value,
          'menu_name': menuName,
          'menu_price': menuPrice,
        }, SetOptions(merge: true)).then((value) async {
          Get.back();
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.success,
                  title: 'Berhasil Diedit',
                  titleTextStyle: const TextStyle(
                      fontFamily: 'Poppins', color: Colors.black),
                  dismissOnBackKeyPress: false,
                  dismissOnTouchOutside: false,
                  animType: AnimType.scale)
              .show();
          await Future.delayed(const Duration(seconds: 2));
          Get.back();
          Get.back();
          Get.back();
        });
      });
    } else {
      FirebaseFirestore.instance.collection('menu list').doc(menu_id).set({
        'menu_desc': menuDesc,
        'menu_name': menuName,
        'menu_price': menuPrice,
      }, SetOptions(merge: true)).then((value) async {
        Get.back();
        AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            title: 'Berhasil Diedit',
            titleTextStyle:
                const TextStyle(fontFamily: 'Poppins', color: Colors.black),
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            animType: AnimType.scale);
        await Future.delayed(const Duration(seconds: 2));
        Get.back();
        Get.back();
        Get.back();
      });
    }
  }
}
