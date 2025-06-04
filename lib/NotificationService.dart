import 'dart:convert';

import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:skripsi/GlobalVar.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static Future<String> getAccessToken() async {
    
    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    // Obtain the access token
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);

    // Close the HTTP client
    client.close();

    // Return the access token
    return credentials.accessToken.data;
  }

  static Future<void> displayNotif(RemoteMessage message) async {
    final id =
        DateTime.tryParse(DateTime.now().toString())!.millisecondsSinceEpoch ~/
            1000;
    const NotificationDetails details = NotificationDetails(
        android: AndroidNotificationDetails(
            'android_local_notifications', 'Android Local Notifications',
            channelDescription:
                'Used to show foreground notifications on Android.',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher'));

    await plugin.show(
        id, message.notification!.title, message.notification!.body, details);
    plugin.initialize(
      const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher')),
      onDidReceiveNotificationResponse: (details) {
        if (details.notificationResponseType ==
            NotificationResponseType.selectedNotification) {
          print('tapped');
          if (message.data['docType'] == 'Chat') {}
          // Get.to(() => ChatroomPage(
          //     orderID: message.data['documentno'],
          //     userName: message.data['sender']));
        }
      },
    );
  }

  sendNotif(String token, String orderNumber, String body, String title,
      String type, String? user_name) async {
    try {
      var authToken = await NotificationService.getAccessToken();
      String fcmEndpoint = GlobalVar.fcmLink;
      final Map<String, dynamic> msg = {
        'message': {
          'token': token,
          'notification': {
            'body': body,
            'title': title,
          },
          'data': {
            'orderId': orderNumber.toString(),
            'type': type,
            if (user_name != null) 'user_name': user_name
          },
          "android": {
            "notification": {
              "channel_id": "notif",
              "click_action": "FLUTTER_NOTIFICATION_CLICK"
            }
          },
        }
      };
      final http.Response response = await http.post(
        Uri.parse(fcmEndpoint),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authToken}',
        },
        body: jsonEncode(msg),
      );
      print(response.statusCode);
      print(response.body);
    } catch (e) {}
  }
}
