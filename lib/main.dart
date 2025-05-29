import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:skripsi/GlobalVar.dart';
import 'package:skripsi/Pages/SplashScreen.dart';
import 'package:skripsi/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        theme: ThemeData(
          primaryColor: Colors.blue[300],
          textSelectionTheme: TextSelectionThemeData(
              cursorColor: Colors.blue[300],
              selectionColor: Colors.blue[300]!.withOpacity(0.5),
              selectionHandleColor: Colors.blue[300]),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
