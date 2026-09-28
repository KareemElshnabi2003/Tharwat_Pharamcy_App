import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Core/function/handle_exception.dart';
import 'package:tharwat_pharmacy/Core/function/handling_data.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Data%20Location/data_location_source.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Profile/profile_source.dart';
import 'package:tharwat_pharmacy/Data/Model/User/city_model.dart';
import 'package:tharwat_pharmacy/Data/Model/User/country_model.dart';
import 'package:tharwat_pharmacy/Data/Model/User/district_model.dart';
import 'package:tharwat_pharmacy/Data/Model/User/user_auth_model.dart';
import 'package:tharwat_pharmacy/View/Screeens/Auth/login_page.dart';
import 'package:tharwat_pharmacy/View/Screeens/Home/home.dart';
import 'package:tharwat_pharmacy/View/Screeens/Profile/edit_profile.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/message_error.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/snack_bar_widgte.dart';
import 'package:tharwat_pharmacy/main.dart';

class ProfileController extends GetxController {
  final GlobalKey<FormState> editKey = GlobalKey<FormState>();
  final GlobalKey<FormState> deleteKey = GlobalKey<FormState>();
  final GlobalKey<FormState> changePassKey = GlobalKey<FormState>();

  String? cityController;
  String? governorateController;
  String? districtController;

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passOldController = TextEditingController();
  final TextEditingController passNewController = TextEditingController();
  final TextEditingController passNewConfirmController =
      TextEditingController();

  StatuesRequest statuesRequest = StatuesRequest.none;
  final ProfileRemoteData profileRemoteData =
      ProfileRemoteData(Get.find<Api>());
  final LocationRemoteData locationRemoteData =
      LocationRemoteData(Get.find<Api>());

  UserAuthModel? userInfoModel;

  String? cityId;
  String? countryId;
  String? districtId;

  List<CityModel> cityList = [];
  List<CountryModel> governorateList = [];
  List<DistrictModel> districtList = [];

  final List<String> genderList = ["Male", "Female"];
  String? gender;

  bool show_1 = true;
  bool show = true;
  bool show_2 = true;

  File? fileImg;
  bool darkMood = false;
  bool isLoadingProfile = false;
  bool isLoadingCountry = false;

  void changeGender(dynamic val) {
    gender = val?.toString();
    update();
  }

  void changeCity(dynamic val) {
    districtController = null;
    cityController = val?.toString();
    getDistrict();
    update();
  }

  Future<void> changeGover(dynamic val) async {
    cityController = null;
    districtController = null;
    governorateController = val?.toString();
    await getCity();
    update();
  }

  void changeDistric(dynamic val) {
    districtController = val?.toString();
    update();
  }

  void changeShow_1() {
    show_1 = !show_1;
    update();
  }

  void changeShow() {
    show = !show;
    update();
  }

  void changeShow_2() {
    show_2 = !show_2;
    update();
  }

  String? userNameValidtor(String val) {
    if (val.trim().isEmpty) {
      return "Please, Enter your name ";
    } else if (val.length > 25) {
      return "Your name is too long ";
    }
    return null;
  }

  String? passwordNewValidtor(String val) {
    if (val.isEmpty) {
      return "Please, Enter your password";
    }
    if (val.length < 8) {
      return "Password too short";
    }
    return null;
  }

  String? passwordOldValidtor(String val) {
    if (val.isEmpty) {
      return "Please, Enter your password";
    }
    if (val.length < 8) {
      return "Password too short";
    }
    return null;
  }

  String? passwordConfirmValidtor(String val) {
    if (val.isEmpty) {
      return "Please, Enter your password";
    }
    if (val != passNewController.text) {
      return "Password not match";
    }
    return null;
  }

  String? addressValidtor(String val) {
    if (val.trim().isEmpty) {
      return "Please, Enter your address ";
    }
    return null;
  }

  String? phoneValidtor(String val) {
    if (!val.isPhoneNumber) {
      return "Please, Enter your phone ";
    }
    return null;
  }

  void changeDark() {
    if (sharedPreferences!.getString("Mood") != "Dark") {
      sharedPreferences!.setString("Mood", "Dark");
      darkMood = true;
    } else {
      sharedPreferences!.setString("Mood", "Light");
      darkMood = false;
    }
    update();
    Get.offAll(() => const Home());
  }

  void changLang() {
    final current = sharedPreferences?.getString("locale") ??
        sharedPreferences?.getString("local") ??
        sharedPreferences?.getString("Lang") ??
        "ar";
    final isAr = current.toLowerCase().startsWith("ar");
    final newLocaleStr = isAr ? "en" : "ar";

    sharedPreferences?.setString("locale", newLocaleStr);
    sharedPreferences?.setString("local", newLocaleStr);
    sharedPreferences?.setString("Lang", isAr ? "En" : "Ar");

    Get.updateLocale(Locale(newLocaleStr));
    update();
    Get.offAll(() => const Home());
  }

  Future<File?> _compressImage(String path) async {
    try {
      final tempDir = Directory.systemTemp;
      final targetPath =
          "${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg";
      final compressed = await FlutterImageCompress.compressAndGetFile(
        path,
        targetPath,
        quality: 60,
      );
      return compressed != null ? File(compressed.path) : null;
    } catch (_) {
      return File(path);
    }
  }

  Future<void> pickImageFromGellary() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        fileImg = File(image.path);
        final compressed = await _compressImage(fileImg!.path);
        if (compressed != null) {
          fileImg = compressed;
        }
      }
    } catch (_) {
      Get.snackbar("Error", "Failed to load image ");
    }
    update();
  }

  Future<void> pickImageFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        fileImg = File(image.path);
        final compressed = await _compressImage(fileImg!.path);
        if (compressed != null) {
          fileImg = compressed;
        }
      }
    } catch (_) {
      Get.snackbar("Error", "Failed to load image ");
    }
    update();
  }

  Future<void> getCountry() async {
    if (isLoadingCountry) return;
    isLoadingCountry = true;
    governorateList.clear();

    try {
      var response = await locationRemoteData.getCountries();
      statuesRequest = handlingData(response);

      if (statuesRequest == StatuesRequest.success) {
        Map<String, dynamic> responseBody = response;
        governorateList = (responseBody['data'] as List)
            .map((item) => CountryModel.fromJson(item))
            .toList();
      } else if (statuesRequest == StatuesRequest.unprocessableException) {
        messageError("Error", parseErrorMessage(response));
      } else if (statuesRequest == StatuesRequest.socketException) {
        messageError("Error", "please, check your internet");
      } else {
        messageError("Error", "There is a problem. Please,  try again later");
      }
    } catch (e) {
      statuesRequest = handleException(e);
      messageError("Error", "There is a problem. Please,  try again later");
    } finally {
      isLoadingCountry = false;
      update();
    }
  }

  Future<void> setData() async {
    cityId = sharedPreferences?.getString("cityId");
    countryId = sharedPreferences?.getString("countryId");
    districtId = sharedPreferences?.getString("districtId");
    userNameController.text = sharedPreferences?.getString("name") ?? "";
    phoneController.text = sharedPreferences?.getString("phone") ?? "";
    governorateController = sharedPreferences?.getString("countryName");
    cityController = sharedPreferences?.getString("cityName");
    districtController = sharedPreferences?.getString("districtName");
    gender = sharedPreferences?.getString("gender");

    Get.to(() => const EditProfile());

    if (cityList.isEmpty && countryId != null) {
      await getCity();
    }
    if (districtList.isEmpty && cityId != null) {
      await getDistrict();
    }
  }

  Future<void> getCity() async {
    countryId ??= sharedPreferences?.getString("countryId");
    if (countryId == null) return;

    cityList.clear();
    try {
      var response = await locationRemoteData.getCities(countryId: countryId);
      statuesRequest = handlingData(response);

      if (statuesRequest == StatuesRequest.success) {
        Map<String, dynamic> responseBody = response;
        cityList = (responseBody['data'] as List)
            .map((item) => CityModel.fromJson(item))
            .toList();
      } else if (statuesRequest == StatuesRequest.unprocessableException) {
        messageError("Error", parseErrorMessage(response));
      } else if (statuesRequest == StatuesRequest.socketException) {
        messageError("Error", "please, check your internet");
      } else {
        messageError("Error", "There is a problem. Please,  try again later");
      }
    } catch (e) {
      statuesRequest = handleException(e);
      messageError("Error", "There is a problem. Please,  try again later");
    } finally {
      update();
    }
  }

  Future<void> getDistrict() async {
    cityId ??= sharedPreferences?.getString("cityId");
    if (cityId == null) return;

    districtList.clear();
    try {
      var response = await locationRemoteData.getDistrict(cityId: cityId);
      statuesRequest = handlingData(response);

      if (statuesRequest == StatuesRequest.success) {
        Map<String, dynamic> responseBody = response;
        districtList = (responseBody['data'] as List)
            .map((item) => DistrictModel.fromJson(item))
            .toList();
      } else if (statuesRequest == StatuesRequest.unprocessableException) {
        messageError("Error", parseErrorMessage(response));
      } else if (statuesRequest == StatuesRequest.socketException) {
        messageError("Error", "please, check your internet");
      } else {
        messageError("Error", "There is a problem. Please,  try again later");
      }
    } catch (e) {
      statuesRequest = handleException(e);
      messageError("Error", "There is a problem. Please,  try again later");
    } finally {
      update();
    }
  }

  Future<void> updateProfile() async {
    if (editKey.currentState?.validate() ?? false) {
      Get.back();

      try {
        statuesRequest = StatuesRequest.loading;
        update();
        var response = await profileRemoteData.updateDataProfile(
          image: fileImg,
          token: sharedPreferences?.getString("token"),
          cityId: cityId ?? sharedPreferences?.getString("cityId"),
          countryId: countryId ?? sharedPreferences?.getString("countryId"),
          districtId: districtId ?? sharedPreferences?.getString("districtId"),
          name: userNameController.text.trim().isEmpty
              ? (sharedPreferences?.getString("name") ?? "")
              : userNameController.text,
          phone: phoneController.text.trim().isEmpty
              ? (sharedPreferences?.getString("phone") ?? "")
              : phoneController.text,
        );

        statuesRequest = handlingData(response);

        if (statuesRequest == StatuesRequest.success) {
          await getProfile();
          if (Get.context != null) {
            ScaffoldMessenger.of(Get.context!).showSnackBar(
              snackBarWidget(message: "Your new data save successfully !"),
            );
          }
        } else if (statuesRequest == StatuesRequest.unprocessableException) {
          messageError("Error", parseErrorMessage(response));
        } else if (statuesRequest == StatuesRequest.socketException) {
          messageError("Error", "please, check your internet");
        } else {
          messageError("Error", "There is a problem. Please,  try again later");
        }
      } catch (e) {
        statuesRequest = handleException(e);
        messageError("Error", "There is a problem. Please,  try again later");
      } finally {
        if (statuesRequest == StatuesRequest.loading) {
          statuesRequest = StatuesRequest.none;
        }
        update();
      }
    }
  }

  Future<void> getProfile() async {
    if (isLoadingProfile) return;
    isLoadingProfile = true;
    statuesRequest = StatuesRequest.loading;
    update();

    try {
      var response = await profileRemoteData.getDataProfile(
        token: sharedPreferences?.getString("token"),
      );

      statuesRequest = handlingData(response);

      if (statuesRequest == StatuesRequest.success) {
        Map<String, dynamic> responseBody = response['data'];
        userInfoModel = UserAuthModel.fromJson(responseBody);

        sharedPreferences?.setString("phone", "${userInfoModel!.phone}");
        sharedPreferences?.setString(
            "cityName", userInfoModel!.district?.city?.name ?? "");
        sharedPreferences?.setString(
            "cityId", "${userInfoModel!.district?.city?.id ?? ''}");
        sharedPreferences?.setString(
            "countryId", "${userInfoModel!.district?.city?.country?.id ?? ''}");
        sharedPreferences?.setString(
            "districtId", "${userInfoModel!.district?.id ?? ''}");
        sharedPreferences?.setString(
            "countryName", userInfoModel!.district?.city?.country?.name ?? "");
        sharedPreferences?.setString(
            "districtName", userInfoModel!.district?.name ?? "");
        sharedPreferences?.setString("name", userInfoModel!.name ?? '');
        sharedPreferences?.setString("image", userInfoModel!.image ?? '');
      } else if (statuesRequest == StatuesRequest.unprocessableException) {
        messageError("Error", parseErrorMessage(response));
      } else if (statuesRequest == StatuesRequest.unauthorizedException) {
        messageErrorWithButton("Error", "You need to login ", () {
          Get.offAll(() => const LoginPage());
        }, "LogIn");
      } else if (statuesRequest == StatuesRequest.socketException) {
        messageError("Error", "please, check your internet");
      } else {
        messageError("Error", "There is a problem. Please,  try again later");
      }
    } catch (e) {
      statuesRequest = handleException(e);
      messageError("Error", "There is a problem. Please,  try again later");
    } finally {
      isLoadingProfile = false;
      update();
    }
  }

  Future<void> logOut() async {
    try {
      statuesRequest = StatuesRequest.loading;
      update();
      var response = await profileRemoteData.logOut(
        token: sharedPreferences?.getString("token"),
      );

      statuesRequest = handlingData(response);

      if (statuesRequest == StatuesRequest.success) {
        sharedPreferences?.setString("pageStart", "Login");
        Get.offAll(() => const LoginPage());
      } else if (statuesRequest == StatuesRequest.unprocessableException) {
        messageError("Error", parseErrorMessage(response));
      } else if (statuesRequest == StatuesRequest.socketException) {
        messageError("Error", "please, check your internet");
      } else {
        messageError("Error", "There is a problem. Please,  try again later");
      }
    } catch (e) {
      statuesRequest = handleException(e);
      messageError("Error", "There is a problem. Please,  try again later");
    } finally {
      if (statuesRequest == StatuesRequest.loading) {
        statuesRequest = StatuesRequest.none;
      }
      update();
    }
  }

  Future<void> deleteAcc() async {
    try {
      statuesRequest = StatuesRequest.loading;
      update();
      var response = await profileRemoteData.deleteAcc(
        token: sharedPreferences?.getString("token"),
        password: passOldController.text,
      );

      statuesRequest = handlingData(response);

      if (statuesRequest == StatuesRequest.success) {
        if (response['status'] == 'error') {
          messageError("Error", "${response["message"]}");
        } else {
          final isDark = sharedPreferences?.getString("Mood") == "Dark";
          sharedPreferences?.clear();
          sharedPreferences?.setString("pageStart", "Login");
          if (isDark) {
            sharedPreferences?.setString("Mood", "Dark");
          }
          Get.offAll(() => const LoginPage());
        }
      } else if (statuesRequest == StatuesRequest.socketException) {
        messageError("Error", "please, check your internet");
      } else {
        messageError("Error", "There is a problem. Please,  try again later");
      }
    } catch (e) {
      statuesRequest = handleException(e);
      messageError("Error", "There is a problem. Please,  try again later");
    } finally {
      if (statuesRequest == StatuesRequest.loading) {
        statuesRequest = StatuesRequest.none;
      }
      update();
    }
  }

  Future<void> changePassword() async {
    if (changePassKey.currentState?.validate() ?? false) {
      try {
        statuesRequest = StatuesRequest.loading;
        update();
        var response = await profileRemoteData.changeOldPass(
          token: sharedPreferences?.getString("token"),
          newPass: passNewController.text,
          newConfirmPass: passNewConfirmController.text,
          oldPass: passOldController.text,
        );

        statuesRequest = handlingData(response);

        if (statuesRequest == StatuesRequest.success) {
          final responseBody = response;
          if (responseBody['status'] == "error") {
            Get.back();
            messageError("Error", "The old password is wrong");
          } else {
            Get.back();
            if (Get.context != null) {
              ScaffoldMessenger.of(Get.context!).showSnackBar(
                snackBarWidget(
                    message: "Your new password save successfully !"),
              );
            }
            Get.back();
          }
        } else if (statuesRequest == StatuesRequest.unprocessableException) {
          messageError("Error", parseErrorMessage(response));
        } else if (statuesRequest == StatuesRequest.socketException) {
          messageError("Error", "please, check your internet");
        } else {
          messageError("Error", "There is a problem. Please,  try again later");
        }
      } catch (e) {
        statuesRequest = handleException(e);
        messageError("Error", "There is a problem. Please,  try again later");
      } finally {
        if (statuesRequest == StatuesRequest.loading) {
          statuesRequest = StatuesRequest.none;
        }
        update();
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    getProfile();
    getCountry();
  }

  @override
  void onClose() {
    userNameController.dispose();
    phoneController.dispose();
    passOldController.dispose();
    passNewController.dispose();
    passNewConfirmController.dispose();
    super.onClose();
  }
}
