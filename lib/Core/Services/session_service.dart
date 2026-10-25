import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Centralized Session & Storage Service.
/// Unifies token, user profile, language, theme, and location state management.
/// Keeps the legacy SharedPreferences keys fully backward-compatible.
class SessionService extends GetxService {
  static SessionService get to => Get.find<SessionService>();

  SharedPreferences prefs;

  SessionService(this.prefs);

  static Future<SessionService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return SessionService(prefs);
  }

  // --- Token Management ---
  String? get token => prefs.getString("token");
  Future<bool> setToken(String? value) async {
    if (value == null) return prefs.remove("token");
    return prefs.setString("token", value);
  }

  String? get deliveryToken => prefs.getString("tokenDelivery");
  Future<bool> setDeliveryToken(String? value) async {
    if (value == null) return prefs.remove("tokenDelivery");
    return prefs.setString("tokenDelivery", value);
  }

  bool get isLoggedIn => token != null && token!.isNotEmpty;
  bool get isDeliveryLoggedIn => deliveryToken != null && deliveryToken!.isNotEmpty;

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
    await prefs.setString("token", userToken);
    await prefs.setString("name", userName);
    await prefs.setString("email", userEmail);
    if (userPhone != null) await prefs.setString("phone", userPhone);
    if (userImage != null) await prefs.setString("image", userImage);
    if (userCityId != null) await prefs.setString("cityId", userCityId);
    if (userCityName != null) await prefs.setString("cityName", userCityName);
    if (userCountryId != null) await prefs.setString("countryId", userCountryId);
    if (userCountryName != null) await prefs.setString("countryName", userCountryName);
    if (userDistrictId != null) await prefs.setString("districtId", userDistrictId);
    if (userDistrictName != null) await prefs.setString("districtName", userDistrictName);
    if (userGender != null) await prefs.setString("gender", userGender);
    await prefs.setString("pageStart", "Home");
  }

  // --- Logout / Clear ---
  Future<void> clearUserSession() async {
    await prefs.remove("token");
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
    await prefs.setString("pageStart", "Login");
  }
}
