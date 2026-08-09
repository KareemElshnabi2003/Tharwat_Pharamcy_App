import 'dart:developer';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:screen_go/screen_go.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tharwat_pharmacy/View/Screeens/splash/splash_screen.dart';

SharedPreferences? sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    DevicePreview(
      enabled: false, // Enable in debug mode only
      builder: (context) => const MyApp(), // Your app widget
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenGo(
      materialApp: true,
      builder: (context, deviceInfo) => const GetMaterialApp(
        builder: DevicePreview.appBuilder, // Add this line
        useInheritedMediaQuery: true, // Add this line

        locale:
            // sharedPreferences!.getString("Lang") == "Ar"
            //   ?
            Locale("ar"),
        // : const Locale("en"),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
