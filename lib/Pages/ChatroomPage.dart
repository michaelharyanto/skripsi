import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:ntp/ntp.dart';
import 'package:skripsi/Controllers/ChatroomPageController.dart';
import 'package:skripsi/GlobalVar.dart';
import 'package:skripsi/Widgets/HeroPhotoView.dart';

// ignore: must_be_immutable
class ChatroomPage extends StatefulWidget {
  String order_id;
  String user_name;
  ChatroomPage({
    Key? key,
    required this.order_id,
    required this.user_name,
  });

  @override
  State<ChatroomPage> createState() => _ChatroomPageState();
}

class _ChatroomPageState extends State<ChatroomPage> {
  ChatroomPageController c = Get.put(ChatroomPageController());
  ScrollController sc = ScrollController();
  TextEditingController messageTF = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).expansionTileTheme.iconColor,
              ),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('pesanan')
                    .doc(widget.order_id)
                    .collection('chatroom')
                    .orderBy('sentDate')
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      sc.jumpTo(sc.position.maxScrollExtent);
                    });
                    return ListView.builder(
                      controller: sc,
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data.docs[index];
                        if (data['sender'] ==
                            GlobalVar.currentUser.user_email) {
                          return Column(
                            children: [
                              Visibility(
                                visible: index == 0 ||
                                    (DateFormat('dd MMMM yyyy',
                                                const Locale('id').languageCode)
                                            .format(DateTime.tryParse(
                                                data['sentDate'])!) !=
                                        DateFormat('dd MMMM yyyy',
                                                const Locale('id').languageCode)
                                            .format(DateTime.tryParse(
                                                snapshot.data.docs[index - 1]
                                                    ['sentDate'])!)),
                                child: Text(
                                  DateFormat('dd MMMM',
                                          const Locale('id').languageCode)
                                      .format(
                                          DateTime.tryParse(data['sentDate'])!),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      children: [
                                        Visibility(
                                          visible: data['isRead'],
                                          child: const Text(
                                            'Read',
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                        Text(
                                          DateFormat('HH:mm').format(
                                              DateFormat('yyyy-MM-dd HH:mm:ss')
                                                  .parse(data['sentDate'])),
                                          style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 4),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        data['image'].toString().isNotEmpty
                                            ? Container(
                                                constraints: BoxConstraints(
                                                    maxHeight: Get.height * 0.4,
                                                    maxWidth: Get.width * 0.7),
                                                padding:
                                                    const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  borderRadius:
                                                      const BorderRadiusDirectional
                                                          .only(
                                                          topStart: Radius
                                                              .circular(20),
                                                          topEnd:
                                                              Radius.circular(
                                                                  20),
                                                          bottomStart:
                                                              Radius.circular(
                                                                  20)),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Get.to(() =>
                                                              HeroPhotoView(
                                                                imagePath: data[
                                                                    'image'],
                                                                tag:
                                                                    'image$index',
                                                              ));
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          child: Hero(
                                                            tag: 'image$index',
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  data['image'],
                                                              fit: BoxFit.cover,
                                                              height:
                                                                  Get.height *
                                                                      0.3,
                                                              placeholder:
                                                                  (context,
                                                                      url) {
                                                                return Container(
                                                                    height:
                                                                        Get.height *
                                                                            0.4,
                                                                    width: 0,
                                                                    color: Colors
                                                                        .transparent);
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: data['message']
                                                          .toString()
                                                          .isNotEmpty,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 5,
                                                                left: 5,
                                                                right: 5),
                                                        child: Text(
                                                          data['message'],
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Container(
                                                constraints: BoxConstraints(
                                                    maxWidth: Get.width * 0.7),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                        vertical: 8),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  borderRadius:
                                                      const BorderRadiusDirectional
                                                          .only(
                                                          topStart: Radius
                                                              .circular(20),
                                                          topEnd:
                                                              Radius.circular(
                                                                  20),
                                                          bottomStart:
                                                              Radius.circular(
                                                                  20)),
                                                ),
                                                child: Text(
                                                  data['message'],
                                                  style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          if (!data['isRead']) {
                            c.updateRead(data.reference);
                          }
                          return Column(
                            children: [
                              Visibility(
                                visible: index == 0 ||
                                    (DateFormat('dd MMMM yyyy',
                                                const Locale('id').languageCode)
                                            .format(DateTime.tryParse(
                                                data['sentDate'])!) !=
                                        DateFormat('dd MMMM yyyy',
                                                const Locale('id').languageCode)
                                            .format(DateTime.tryParse(
                                                snapshot.data.docs[index - 1]
                                                    ['sentDate'])!)),
                                child: Text(
                                  DateFormat('dd MMMM',
                                          const Locale('id').languageCode)
                                      .format(
                                          DateTime.tryParse(data['sentDate'])!),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10, left: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      children: [
                                        data['image'].toString().isNotEmpty
                                            ? Container(
                                                constraints: BoxConstraints(
                                                    maxHeight: Get.height * 0.4,
                                                    maxWidth: Get.width * 0.7),
                                                padding:
                                                    const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadiusDirectional
                                                            .only(
                                                            topStart:
                                                                Radius.circular(
                                                                    20),
                                                            topEnd:
                                                                Radius.circular(
                                                                    20),
                                                            bottomEnd:
                                                                Radius.circular(
                                                                    20)),
                                                    color: Colors.grey[300]),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Get.to(() =>
                                                              HeroPhotoView(
                                                                imagePath: data[
                                                                    'image'],
                                                                tag:
                                                                    'image$index',
                                                              ));
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(28),
                                                          child: Hero(
                                                            tag: 'image$index',
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  data['image'],
                                                              fit: BoxFit.cover,
                                                              height:
                                                                  Get.height *
                                                                      0.3,
                                                              placeholder:
                                                                  (context,
                                                                      url) {
                                                                return Container(
                                                                    height:
                                                                        Get.height *
                                                                            0.4,
                                                                    width: 0,
                                                                    color: Colors
                                                                        .transparent);
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: data['message']
                                                          .toString()
                                                          .isNotEmpty,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 5,
                                                                left: 5,
                                                                right: 5),
                                                        child: Text(
                                                          data['message'],
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Container(
                                                constraints: BoxConstraints(
                                                    maxWidth: Get.width * 0.7),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                        vertical: 8),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadiusDirectional
                                                            .only(
                                                            topStart:
                                                                Radius.circular(
                                                                    20),
                                                            topEnd:
                                                                Radius.circular(
                                                                    20),
                                                            bottomEnd:
                                                                Radius.circular(
                                                                    20)),
                                                    color: Colors.grey[300]),
                                                child: Text(
                                                  data['message'],
                                                  style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                      ],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      DateFormat('HH:mm').format(
                                          DateFormat('yyyy-MM-dd HH:mm:ss')
                                              .parse(data['sentDate'])),
                                      style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Obx(() => Column(
                  children: [
                    c.imagePath.value != ''
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: GestureDetector(
                              onTap: () {
                                c.imagePath.value = '';
                              },
                              child: Badge(
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                backgroundColor: Colors.red,
                                largeSize: 30,
                                offset: const Offset(15, 0),
                                label: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => HeroPhotoView(
                                        imagePath: c.imagePath.value,
                                        tag: 'image'));
                                  },
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    color: Colors.black,
                                    radius: const Radius.circular(8),
                                    child: ClipRRect(
                                      clipBehavior: Clip.hardEdge,
                                      borderRadius: BorderRadius.circular(8),
                                      child: Hero(
                                        tag: 'image',
                                        child: Image.file(
                                          File(c.imagePath.value),
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: !kIsWeb,
                          child: IconButton(
                              onPressed: () {
                                c.pickImage(context);
                              },
                              icon: Icon(
                                MdiIcons.imagePlus,
                                color: Colors.grey[400],
                              )),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: messageTF,
                            style: const TextStyle(
                                fontFamily: 'Poppins', color: Colors.black),
                            minLines: 1,
                            maxLines: 6,
                            decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        BorderSide(color: Colors.grey[400]!)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        BorderSide(color: Colors.grey[400]!)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        BorderSide(color: Colors.grey[400]!))),
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              if (messageTF.text.isNotEmpty) {
                                var today = await NTP.now();

                                c.sendMessage(
                                    context,
                                    widget.order_id,
                                    messageTF.text,
                                    c.imagePath.value,
                                    GlobalVar.currentUser.user_email,
                                    widget.user_name,
                                    DateFormat('yyyy-MM-dd HH:mm:ss')
                                        .format(today));
                                messageTF.text = '';
                                c.imagePath.value = '';
                              }
                            },
                            icon: Icon(MdiIcons.send, color: Colors.grey[400])),
                      ],
                    ),
                  ],
                )),
          ),
        ],
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        surfaceTintColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.user_name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.order_id,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
