import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skripsi/Controllers/ChatroomListFragmentController.dart';
import 'package:skripsi/GlobalVar.dart';
import 'package:skripsi/Pages/ChatroomPage.dart';

class ChatroomListFragment extends StatefulWidget {
  const ChatroomListFragment({super.key});

  @override
  State<ChatroomListFragment> createState() => _ChatroomListFragmentState();
}

class _ChatroomListFragmentState extends State<ChatroomListFragment> {
  ChatroomListFragmentController c = Get.put(ChatroomListFragmentController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('pesanan')
                  .where('tenant_id', isEqualTo: GlobalVar.currentUser.user_id)
                  .where('hasChat', isEqualTo: true)
                  .where('lastStatus', whereNotIn: ['COMPLETED', 'REJECTED'])
                  .orderBy('created')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index];
                      return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('pesanan')
                            .doc(data['order_id'])
                            .collection('chatroom')
                            .orderBy('sentDate', descending: true)
                            .snapshots(),
                        builder: (context, orderSnapshot) {
                          if (!orderSnapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                            );
                          } else {
                            var recentData = orderSnapshot.data!.docs[0];
                            var recentDate =
                                DateTime.tryParse(recentData['sentDate'])!;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(
                                    () => ChatroomPage(
                                      order_id: data['order_id'],
                                      user_name: data['user_name'],
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Color(0xFFD3D5DF),
                                              width: 2))),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: IntrinsicHeight(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      data['user_name']
                                                          .toString()
                                                          .split(' ')[0],
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily: 'Poppins',
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xFF222831),
                                                      ),
                                                    ),
                                                  ),
                                                  const VerticalDivider(
                                                    width: 20,
                                                    thickness: 2,
                                                    color: Colors.black,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      '${data['order_id']}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily: 'Poppins',
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xFF222831),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              DateTime.now()
                                                          .difference(
                                                              recentDate)
                                                          .inDays <
                                                      1
                                                  ? DateFormat('HH:mm')
                                                      .format(recentDate)
                                                  : DateFormat('dd/MM')
                                                      .format(recentDate),
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 14,
                                                color: Color(0xFF222831),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              recentData['message']
                                                      .toString()
                                                      .isNotEmpty
                                                  ? '${recentData['image'].toString().isNotEmpty ? '🖼 (Gambar) ' : ''}${recentData['message']}'
                                                  : '🖼 (Gambar)',
                                              textAlign: TextAlign.start,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 14,
                                                color: Color(0xFF222831),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 30,
                                          ),
                                          Container(
                                            width: 15,
                                            height: 15,
                                            decoration: BoxDecoration(
                                                color: c.checkRecent(
                                                        orderSnapshot
                                                            .data!.docs)
                                                    ? const Color(0xFF337AB7)
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  );
                }
              },
            )),
          ],
        ),
      ),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'List Chat yang Sedang Aktif',
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
