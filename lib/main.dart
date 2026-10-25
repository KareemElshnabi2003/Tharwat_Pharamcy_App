import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:screen_go/screen_go.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/Services/session_service.dart';
import 'package:tharwat_pharmacy/View/Screeens/splash/splash_screen.dart';

SharedPreferences? sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sessionService = await SessionService.init();
  sharedPreferences = sessionService.prefs;
  Get.put<SessionService>(sessionService, permanent: true);
  Get.put<Api>(Api(), permanent: true);

  runApp(
    // DevicePreview is only active in debug builds.
    // In release/profile mode it wraps with no-op builder.
    DevicePreview(
      enabled: kDebugMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final langCode = Get.isRegistered<SessionService>()
        ? SessionService.to.languageCode
        : "ar";
    final initialLocale = Locale(langCode);


    return ScreenGo(
      materialApp: true,
      builder: (context, deviceInfo) => GetMaterialApp(
        // DevicePreview.appBuilder is a no-op when device_preview is disabled.
        builder: DevicePreview.appBuilder,
        useInheritedMediaQuery: true,
        locale: initialLocale,
        fallbackLocale: const Locale("ar"),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
