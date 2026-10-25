import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Centralized Session & Secure Storage Service.
/// Unifies token, user profile, language, theme, and location state management.
/// Automatically migrates plaintext tokens from SharedPreferences to FlutterSecureStorage.
class SessionService extends GetxService {
  static SessionService get to => Get.find<SessionService>();

  final SharedPreferences prefs;
  final FlutterSecureStorage secureStorage;

  String? _cachedToken;
  String? _cachedDeliveryToken;

  SessionService(
    this.prefs, {
    this.secureStorage = const FlutterSecureStorage(),
  });

  static Future<SessionService> init() async {
    final prefs = await SharedPreferences.getInstance();
    const secureStorage = FlutterSecureStorage();
    final service = SessionService(prefs, secureStorage: secureStorage);
    await service._migrateAndLoadTokens();
    return service;
  }

  Future<void> _migrateAndLoadTokens() async {
    try {
      // 1. Read from FlutterSecureStorage
      _cachedToken = await secureStorage.read(key: "token");

      // 2. Migration: If not in secure storage, check legacy SharedPreferences
      if (_cachedToken == null || _cachedToken!.isEmpty) {
        final legacyToken = prefs.getString("token");
        if (legacyToken != null && legacyToken.isNotEmpty) {
          _cachedToken = legacyToken;
          await secureStorage.write(key: "token", value: legacyToken);
        }
      }

      // 3. Repeat for delivery token
      _cachedDeliveryToken = await secureStorage.read(key: "tokenDelivery");
      if (_cachedDeliveryToken == null || _cachedDeliveryToken!.isEmpty) {
        final legacyDelToken = prefs.getString("tokenDelivery");
        if (legacyDelToken != null && legacyDelToken.isNotEmpty) {
          _cachedDeliveryToken = legacyDelToken;
          await secureStorage.write(key: "tokenDelivery", value: legacyDelToken);
        }
      }
    } catch (_) {
      // Safe fallback if secure storage encounters platform issues
      _cachedToken ??= prefs.getString("token");
      _cachedDeliveryToken ??= prefs.getString("tokenDelivery");
    }
  }

  // --- Token Management ---
  String? get token => _cachedToken ?? prefs.getString("token");

  Future<void> setToken(String? value) async {
    _cachedToken = value;
    if (value == null) {
      prefs.remove("token");
      try {
        await secureStorage.delete(key: "token");
      } catch (_) {}
    } else {
      prefs.setString("token", value);
      try {
        await secureStorage.write(key: "token", value: value);
      } catch (_) {}
    }
  }

  String? get deliveryToken =>
      _cachedDeliveryToken ?? prefs.getString("tokenDelivery");

  Future<void> setDeliveryToken(String? value) async {
    _cachedDeliveryToken = value;
    if (value == null) {
      prefs.remove("tokenDelivery");
      try {
        await secureStorage.delete(key: "tokenDelivery");
      } catch (_) {}
    } else {
      prefs.setString("tokenDelivery", value);
      try {
        await secureStorage.write(key: "tokenDelivery", value: value);
      } catch (_) {}
    }
  }

  bool get isLoggedIn => token != null && token!.isNotEmpty;
  bool get isDeliveryLoggedIn =>
      deliveryToken != null && deliveryToken!.isNotEmpty;

  // --- Language Management ---
  String get languageCode {
    final lang = prefs.getString("locale") ??
        prefs.getString("local") ??
        prefs.getString("Lang");
    return (lang?.toLowerCase() == "en") ? "en" : "ar";
  }

  Future<void> setLanguage(String code) async {
    final standardized = code.toLowerCase() == "en" ? "en" : "ar";
    await prefs.setString("locale", standardized);
    await prefs.setString("local", standardized);
    await prefs.setString("Lang", standardized == "en" ? "En" : "Ar");
  }

  // --- Theme Mode ---
  bool get isDarkMode => prefs.getString("Mood") == "Dark";

  Future<bool> setDarkMode(bool isDark) async {
    return prefs.setString("Mood", isDark ? "Dark" : "Light");
  }

  // --- User Profile ---
  String? get name => prefs.getString("name");
  String? get email => prefs.getString("email");
  String? get phone => prefs.getString("phone");
  String? get image => prefs.getString("image");
  String? get gender => prefs.getString("gender");

  // --- Location & Address ---
  String? get cityName => prefs.getString("cityName");
  String? get countryName => prefs.getString("countryName");
  String? get districtName => prefs.getString("districtName");

  int? get cityId {
    final val = prefs.getString("cityId");
    return val != null ? int.tryParse(val) : null;
  }

  int? get countryId {
    final val = prefs.getString("countryId");
    return val != null ? int.tryParse(val) : null;
  }

  int? get districtId {
    final val = prefs.getString("districtId");
    return val != null ? int.tryParse(val) : null;
  }

  // --- Navigation / Startup Flow ---
  String? get startPage => prefs.getString("pageStart");
  Future<bool> setStartPage(String page) => prefs.setString("pageStart", page);

  // --- Batch Login Session Saver ---
  Future<void> saveUserLogin({
    required String userToken,
    required String userName,
    required String userEmail,
    String? userPhone,
    String? userImage,
    String? userCityId,
    String? userCityName,
    String? userCountryId,
    String? userCountryName,
    String? userDistrictId,
    String? userDistrictName,
    String? userGender,
  }) async {
    await setToken(userToken);
    await prefs.setString("name", userName);
    await prefs.setString("email", userEmail);
    if (userPhone != null) await prefs.setString("phone", userPhone);
    if (userImage != null) await prefs.setString("image", userImage);
    if (userCityId != null) await prefs.setString("cityId", userCityId);
    if (userCityName != null) await prefs.setString("cityName", userCityName);
    if (userCountryId != null) await prefs.setString("countryId", userCountryId);
    if (userCountryName != null) {
      await prefs.setString("countryName", userCountryName);
    }
    if (userDistrictId != null) {
      await prefs.setString("districtId", userDistrictId);
    }
    if (userDistrictName != null) {
      await prefs.setString("districtName", userDistrictName);
    }
    if (userGender != null) await prefs.setString("gender", userGender);
    await prefs.setString("pageStart", "Home");
  }

  // --- Logout / Clear ---
  Future<void> clearUserSession() async {
    await setToken(null);
    await setDeliveryToken(null);
    await prefs.remove("name");
    await prefs.remove("email");
    await prefs.remove("phone");
    await prefs.remove("image");
    await prefs.remove("cityId");
    await prefs.remove("cityName");
    await prefs.remove("countryId");
    await prefs.remove("countryName");
    await prefs.remove("districtId");
    await prefs.remove("districtName");
    await prefs.remove("role");
    await prefs.remove("roleDelivery");
    await prefs.remove("id");
    await prefs.setString("pageStart", "Login");
  }
}
