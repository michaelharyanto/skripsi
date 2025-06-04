import 'package:get/get.dart';
import 'package:skripsi/GlobalVar.dart';

class ChatroomListFragmentController extends GetxController{
  bool checkRecent(var items) {
    for (var element in items) {
      if ((element['sender'].toString() != GlobalVar.currentUser.user_email) &&
          !element['isRead']) {
        return true;
      }
    }
    return false;
  }
}