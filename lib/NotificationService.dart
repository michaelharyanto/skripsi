import 'dart:convert';

import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static Future<String> getAccessToken() async {
    // Your client ID and client secret obtained from Google Cloud Console
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "skripsi-79bf8",
      "private_key_id": "159b950bb3f1b655310c5b318ecb795c4f48472d",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCl0jz0pI84jLWP\nqk4pwNOLgVPR9rheW7tBpxWGHU5p92sIPMzPJp6gBlydIcg2/noMekXQPz9a3427\nQ79/0NKNA2f7KxDYIPZOAC5DNhqJq29NfnFv/aTzolf4NjUTnMkFNN1aTTfyjw8D\n/tH4DuI8VlmZOb4TfTYGTh8JwHkFwkmLYLg1REt05S1s4rAq5w28WoCk/pAjwjnR\n5ATtYTis5eSfMUjov2/De+o3qrAD/6lGsHVjMu/g5b28BUwWFpgl4G5DIXytLFN9\nhq2C8ZJv2MrXaL2cUF+xO9Jlfv0Kw8HDqsjVi7PSC4NowcVkzbJWpR1L/cY7TEuV\nXWd9Esx3AgMBAAECggEABSJv6cFb5liqpikUJFEItXkKzLJF8WhuV9eVICLkxf1q\n+1I3cBijI8bFDZNTHRGfKA2NmNreGtgkp6fiFGw1mmrNe8A3ITVQFLugf+ThruHR\nX5LRPDI17kDyIvwgUGjaUdNzusz8tQGLnPuO3XTHufrDtnqZV9NYnc3229+LJjIm\nxB7Pil9SyiC8QgIA+Mmnoia2tHqcYrCXOo43RlRhqgd8ARBvM4GK+BIB910VtyR/\no/rn5pq0fkVvYvusSVjW8Y99zdx+QUp16Nkes56trs4/uHtZleCj75coys+XcH6J\nEPzvBExzdotVXi90tsy72Trmx09aKyIOk85fDapT6QKBgQDnKqt+BDt/tcgVxVC9\nwSQaY15iWHKgwcbhpEDXRq2cWEZTiMw9XUPSOBxxeCCJH7mL4j02hEEMsD1cFjCQ\n3wqsPctMraDZw1a4lKTOgast9rL5p+MGFHlBr8xZOl4j/34/MEIoLLtyawGKC5Iz\n5okfZUNKIozEYWaLr1NCDIHt2QKBgQC3on/Bp9LR/0ixOfYqH3Rn35IBQoC/+Ysu\nM6L5AJPlmSSTuwSedMuS2FdUi9YPZhUYJavQgw4boicrXMGcSuzAJPv35ZJIcHYy\nRzpCa5XuTwv9kxkEFrd2yZN0OiE7iFd3aI4OZRYsdj2efpNA7PXJOwkwgA2tju9P\ng7ksqeEKzwKBgDBwo5D7iBBB4lSVjU7F+y/AZNXM3PBMysUbqy6xM84QPWRhxRKS\nyZRyh5tLZd32FOZ4GQWkfxEOmT0DtVeWNWFUbZZ6x7r6EOEK3OIdD+bIzEY+ZPcw\nMRyPnw2PioyWjDjnfuV2Qi0+uQrZU+CmTVOT357YUJESK+/XZGXxwwQ5AoGAP4p9\n9G9ytnFEIPbyY87wg4TLy53MWSEq9LivWsPFaTvdeTTMO1wkmNI9HacpUbi78dgP\nJJ5EgnFQZmO5JrCSTUY+3Z9VR7WKYIle8l6xyX0WpA6DKHQH1ZWYbS40E5pw0YOf\nLAH0czwSxEX+BAg6YAAKhPq6QOTlj7j/mSHLGecCgYBdfXunpuh4t7z91rkuxBni\nVq3Rs8M09jCogSmukfF7dX3r+MLwLInz6wSV7uH/LX9NhbMZKk93NOKn2i7Deyeo\nq7h5LOqBs90zXABYWd0Tl5Ec6OMShGN43jEZYZrdNPOY3zAfGK99Vm3aizrBTNoV\nkLG2bkwMhTiXDsVp+H6aTw==\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-fbsvc@skripsi-79bf8.iam.gserviceaccount.com",
      "client_id": "102251132295968469132",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40skripsi-79bf8.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

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
      const String fcmEndpoint =
          'https://fcm.googleapis.com/v1/projects/skripsi-79bf8/messages:send';
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
