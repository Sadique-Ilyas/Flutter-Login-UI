import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_fb_google/Services/Auth%20Services.dart';
import 'package:flutter_login_fb_google/ui/Splash%20Screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // runApp(DevicePreview(
  //   enabled: true,
  //   builder: (context) => MyApp(), // Wrap your app
  // ),);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: SplashScreen());
  }
}
