import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:skripsi/GlobalVar.dart';
import 'package:skripsi/NotificationService.dart';
import 'package:skripsi/Pages/HomePage.dart';
import 'package:skripsi/Pages/SplashScreen.dart';
import 'package:skripsi/firebase_options.dart';

// Function agar app bisa nerima notif walaupun kondisi app di background ataupun di terminate (app dimatikan seutuhnya)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // notif yang diterima disimpan di Firebase Firestore agar dapat diakses historynya
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();
  const AndroidNotificationChannel androidChannel = AndroidNotificationChannel(
    'android_local_notifications',
    'Android Local Notifications',
    description: 'Used to show foreground notifications on Android.',
    importance: Importance.max,
  );

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final DarwinInitializationSettings darwinInitializationSettings =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification: (id, title, body, payload) {},
  );

  await plugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidChannel);
  plugin.initialize(
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: darwinInitializationSettings),
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    NotificationService.displayNotif(message);
  });
  FirebaseFirestore.instance.collection('API').doc('data').get().then((value) {
    GlobalVar.carouselLink = value.data()!['storageLink'];
    GlobalVar.carouselToken = value.data()!['storageKey'];
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        locale: const Locale('id'),
        supportedLocales: const [Locale('id')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        builder: EasyLoading.init(),
        getPages: [GetPage(name: '/homepage', page: () => const HomePage(animateToIndex: null,))],
        theme: ThemeData(
          primaryColor: Colors.blue[300],
          textSelectionTheme: TextSelectionThemeData(
              cursorColor: Colors.blue[300],
              selectionColor: Colors.blue[300]!.withOpacity(0.5),
              selectionHandleColor: Colors.blue[300]),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue[300]!),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

Future<void> handleMessage(RemoteMessage message) async {
  if (message.data['docType'] == 'Chat') {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      
      // Get.to(() => ChatroomPage(
      //     orderID: message.data['documentno'],
      //     userName: message.data['sender']));
    });
  }
}
