import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_imagekit/flutter_imagekit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:skripsi/GlobalVar.dart';
import 'package:skripsi/NotificationService.dart';

class ChatroomPageController extends GetxController {
  ScrollController sc = ScrollController();
  RxBool isSending = false.obs;
  RxString imagePath = ''.obs;

  sendMessage(
    BuildContext context,
    String orderID,
    String message,
    String image,
    String sender,
    String receiver,
    String sentDate,
  ) async {
    String imageURL = '';
    if (image.isNotEmpty) {
      try {
        imageURL = await sendToStorage(orderID, image);
      } on FirebaseException catch (e) {
        print(e);
        return;
      }
    }
    FirebaseFirestore.instance
        .collection('pesanan')
        .doc(orderID)
        .collection('chatroom')
        .add({
      'sender': sender,
      'sentDate': sentDate,
      'image': imageURL,
      'message': message,
      'isRead': false
    }).whenComplete(() async {
      FirebaseFirestore.instance
          .collection('pesanan')
          .doc(orderID)
          .set({'hasChat': true}, SetOptions(merge: true));
      var data = await FirebaseFirestore.instance
          .collection('users')
          .where('user_name', isEqualTo: receiver)
          .get();
      var token = data.docs.first['fcm_token'];

      await NotificationService().sendNotif(
          token,
          orderID,
          "${image.isNotEmpty ? "🖼 (Gambar dilampirkan) " : ""}$message",
          "${GlobalVar.currentUser.user_name} | $orderID",
          'Chat',
          GlobalVar.currentUser.user_name);
    });
  }

  updateRead(DocumentReference doc) async {
    try {
      doc.update({'isRead': true});
    } on FirebaseException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  Future<String> sendToStorage(String orderID, String image) async {
    String imagePath = '';
    imagePath = await ImageKit.io(
        folder: 'ChatroomImage/$orderID',
        File(image),
        privateKey: GlobalVar.carouselToken);

    return imagePath;
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
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
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
        imagePath.value = pickedFile.path;
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
        imagePath.value = pickedFile.path;
      }
    } catch (e) {
      return;
    }
  }
}
