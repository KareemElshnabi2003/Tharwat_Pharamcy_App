import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:screen_go/screen_go.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/View/Screeens/splash/splash_screen.dart';

SharedPreferences? sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  Get.put<Api>(Api(), permanent: true);
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
    final savedLang = sharedPreferences?.getString("locale") ??
        sharedPreferences?.getString("local") ??
        sharedPreferences?.getString("Lang");
    final initialLocale = (savedLang?.toLowerCase() == "en")
        ? const Locale("en")
        : const Locale("ar");

    return ScreenGo(
      materialApp: true,
      builder: (context, deviceInfo) => GetMaterialApp(
        builder: DevicePreview.appBuilder,
        useInheritedMediaQuery: true,
        locale: initialLocale,
        fallbackLocale: const Locale("ar"),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
