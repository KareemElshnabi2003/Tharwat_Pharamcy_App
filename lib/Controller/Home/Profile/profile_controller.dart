import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
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
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ProfileController extends GetxController {
  GlobalKey<FormState> editKey = GlobalKey();
  GlobalKey<FormState> deleteKey = GlobalKey();
  GlobalKey<FormState> changePassKey = GlobalKey();
  String? cityController;
  String? governorateController;
  String? districtController;

  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passOldController = TextEditingController();
  TextEditingController passNewController = TextEditingController();
  TextEditingController passNewConfirmController = TextEditingController();

  StatuesRequest statuesRequest = StatuesRequest.none;
  ProfileRemoteData profileRemoteData = ProfileRemoteData(Get.put(Api()));
  LocationRemoteData locationRemoteData = LocationRemoteData(Get.put(Api()));

  UserAuthModel? userInfoModel;

  String? cityId;
  String? countryId;
  String? districtId;

  List<CityModel> cityList = [];

  List<CountryModel> governorateList = [];

  List<DistrictModel> districtList = [];
  List genderList = ["Male", "Female"];
  String? gender;
  changeGender(val) {
    gender = val;
    update();
  }

  changeCity(val) {
    districtController = null;
    cityController = val;
    getDistrict();
    // cityId = valId;
    update();
  }

  changeGover(val) async {
    cityController = null;
    districtController = null;
    governorateController = val;

    getCity();
    update();
  }

  changeDistric(val) {
    districtController = val;
    // districtId = valId;
    update();
  }

  bool show_1 = true;
  bool show = true;

  bool show_2 = true;

  changeShow_1() {
    if (show_1 == false) {
      show_1 = true;
      update();
    } else {
      show_1 = false;
      update();
    }
  }

  changeShow() {
    if (show == false) {
      show = true;
      update();
    } else {
      show = false;
      update();
    }
  }

  changeShow_2() {
    if (show_2 == false) {
      show_2 = true;
      update();
    } else {
      show_2 = false;
      update();
    }
  }

  userNameValidtor(String val) {
    if (val.isEmpty) {
      return "Please, Enter your name ";
    } else if (val.length > 25) {
      return "Your name is too long ";
    } else {
      return null;
    }
  }

  passwordNewValidtor(String val) {
    if (val.isEmpty) {
      return "Please, Enter your password";
    }
    if (val.length < 8) {
      return "Password too short";
    } else {
      return null;
    }
  }

  passwordOldValidtor(String val) {
    if (val.isEmpty) {
      return "Please, Enter your password";
    }
    if (val.length < 8) {
      return "Password too short";
    } else {
      return null;
    }
  }

  passwordConfirmValidtor(String val) {
    if (val.isEmpty) {
      return "Please, Enter your password";
    }
    if (val != passNewController.text) {
      return "Password not match";
    } else {
      return null;
    }
  }

  addressValidtor(String val) {
    if (val.isEmpty) {
      return "Please, Enter your address ";
    } else {
      return null;
    }
  }

  phoneValidtor(String val) {
    if (!val.isPhoneNumber) {
      return "Please, Enter your phone ";
    } else {
      return null;
    }
  }

  bool darkMood = false;
  changeDark() {
    if (sharedPreferences!.getString("Mood") != "Dark") {
      sharedPreferences!.setString("Mood", "Dark");
      darkMood = true;
      update();
    } else {
      sharedPreferences!.setString("Mood", "Light");
      darkMood = false;
      update();
    }
    Get.offAll(() => const Home());
  }

  changLang() {
    if (sharedPreferences!.getString("Lang") != "Ar") {
      sharedPreferences!.setString("Lang", "Ar");
      update();
    } else {
      sharedPreferences!.setString("Lang", "En");
      update();
    }
    Get.offAll(() => const Home());
  }

  File? fileImg;

  Future<void> pickImageFromGellary() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        fileImg = File(image.path);
        final compressedFile = await FlutterImageCompress.compressAndGetFile(
          fileImg!.path,
          "${fileImg!.path}_compressed.jpg",
          quality: 60,
        );
        if (compressedFile != null) {
          fileImg = File(compressedFile.path);
        }
      }
    } catch (_) {
      Get.snackbar(
        "Error",
        "Failed to load image ",
      );
    }
    update();
  }

  Future<void> pickImageFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        fileImg = File(image.path);
        final compressedFile = await FlutterImageCompress.compressAndGetFile(
          fileImg!.path,
          "${fileImg!.path}_compressed.jpg",
          quality: 60,
        );
        if (compressedFile != null) {
          fileImg = File(compressedFile.path);
        }
      }
    } catch (_) {
      Get.snackbar(
        "Error",
        "Failed to load image ",
      );
    }
    update();
  }

  // File? image;
  // String imagerequest = "";
  // Future getImageFromCamera() async {
  //   final returnImage =
  //       await ImagePicker().pickImage(source: ImageSource.camera);
  //   if (returnImage == null) {
  //     return null;
  //   } else {
  //     image = File(returnImage.path);
  //     imagerequest = image!.path;

  //     update();
  //     Get.back();
  //   }
  //   update();
  // }

  // Future getImageFromGallery() async {
  //   final returnImage =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (returnImage == null) {
  //     return null;
  //   } else {
  //     image = File(returnImage.path);
  //     imagerequest = image!.path;
  //     print(imagerequest);

  //     update();
  //     Get.back();
  //   }
  //   update();
  // }

  getCountry() async {
    governorateList.clear();

    var response = await locationRemoteData.getCountries();

    statuesRequest = handlingData(response);

    if (statuesRequest == StatuesRequest.success) {
      Map<String, dynamic> responseBody = response;
      governorateList = (responseBody['data'] as List)
          .map((item) => CountryModel.fromJson(item))
          .toList();
    } else if (statuesRequest == StatuesRequest.unprocessableException) {
      messageError("Error", "${response["error"]["message"]}");
    } else if (statuesRequest == StatuesRequest.socketException) {
      messageError("Error", "please, check your internet");
    } else {
      messageError("Error", "There is a problem. Please,  try again later");
    }

    update();
  }

  setData() async {
    if (cityList.isNotEmpty &&
        governorateList.isNotEmpty &&
        districtList.isNotEmpty) {
      Get.to(() => const EditProfile());
    } else {
      Get.to(() => const EditProfile());
      cityId = sharedPreferences!.getString("cityId");
      countryId = sharedPreferences!.getString("countrydId");
      districtId = sharedPreferences!.getString("districtId");
      userNameController.text = sharedPreferences!.getString("name")!;
      phoneController.text = sharedPreferences!.getString("phone")!;
      governorateController = sharedPreferences!.getString("countryName")!;
      cityController = sharedPreferences!.getString("cityName")!;
      districtController = sharedPreferences!.getString("districtName")!;
      gender = sharedPreferences!.getString("gender");

      await getCity();

      await getDistrict();
    }
  }

  getCity() async {
    if (countryId == null) {
      countryId = sharedPreferences!.getString("countryId");
      await getCity();
    } else {
      cityList.clear();

      var response = await locationRemoteData.getCities(countryId: countryId);

      statuesRequest = handlingData(response);

      if (statuesRequest == StatuesRequest.success) {
        Map<String, dynamic> responseBody = response;
        cityList = (responseBody['data'] as List)
            .map((item) => CityModel.fromJson(item))
            .toList();
      } else if (statuesRequest == StatuesRequest.unprocessableException) {
        messageError("Error", "${response["error"]["message"]}");
      } else if (statuesRequest == StatuesRequest.socketException) {
        messageError("Error", "please, check your internet");
      } else {
        messageError("Error", "There is a problem. Please,  try again later");
      }

      update();
    }
  }

  getDistrict() async {
    if (cityId != null) {
      districtList.clear();

      var response = await locationRemoteData.getDistrict(cityId: cityId);

      statuesRequest = handlingData(response);

      if (statuesRequest == StatuesRequest.success) {
        Map<String, dynamic> responseBody = response;
        districtList = (responseBody['data'] as List)
            .map((item) => DistrictModel.fromJson(item))
            .toList();
      } else if (statuesRequest == StatuesRequest.unprocessableException) {
        messageError("Error", "${response["error"]["message"]}");
      } else if (statuesRequest == StatuesRequest.socketException) {
        messageError("Error", "please, check your internet");
      } else {
        messageError("Error", "There is a problem. Please,  try again later");
      }

      update();
    }
  }

  updateProfile() async {
    if (editKey.currentState!.validate()) {
      Get.back();

      statuesRequest = StatuesRequest.loading;
      update();
      var response = await profileRemoteData.updateDataProfile(
          image: fileImg,
          token: sharedPreferences!.getString("token"),
          cityId: cityId ?? sharedPreferences!.getString("cityId"),
          countryId: countryId ?? sharedPreferences!.getString("countryId"),
          districtId: districtId ?? sharedPreferences!.getString("districtId"),
          name: userNameController.text == ""
              ? sharedPreferences!.getString("name")
              : userNameController.text,
          phone: phoneController.text == ""
              ? sharedPreferences!.getString("phone")
              : phoneController.text);

      statuesRequest = handlingData(response);

      if (statuesRequest == StatuesRequest.success) {
        getProfile();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
            snackBarWidget(message: "Your new data save successfully !"));
        update();
      } else if (statuesRequest == StatuesRequest.unprocessableException) {
        messageError("Error", "${response["error"]["message"]}");
      } else if (statuesRequest == StatuesRequest.socketException) {
        messageError("Error", "please, check your internet");
      } else {
        messageError("Error", "There is a problem. Please,  try again later");
      }
    }
    update();
  }

  getProfile() async {
    statuesRequest = StatuesRequest.loading;
    update();
    var response = await profileRemoteData.getDataProfile(
      token: sharedPreferences!.getString("token"),
    );

    statuesRequest = handlingData(response);

    if (statuesRequest == StatuesRequest.success) {
      Map<String, dynamic> responseBody = response['data'];
      userInfoModel = UserAuthModel.fromJson(responseBody);

      sharedPreferences!.setString("phone", "${userInfoModel!.phone}");

      sharedPreferences!
          .setString("cityName", userInfoModel!.district!.city!.name ?? "");
      sharedPreferences!
          .setString("cityId", "${userInfoModel!.district!.city!.id}");
      sharedPreferences!.setString(
          "countryId", "${userInfoModel!.district!.city!.country!.id}");

      sharedPreferences!
          .setString("districtId", "${userInfoModel!.district!.id}");

      sharedPreferences!.setString(
          "countryName", userInfoModel!.district!.city!.country!.name ?? "");
      sharedPreferences!
          .setString("districtName", userInfoModel!.district!.name ?? "}");
      sharedPreferences!.setString("name", "${userInfoModel!.name}");
      sharedPreferences!.setString("image", "${userInfoModel!.image}");
    } else if (statuesRequest == StatuesRequest.unprocessableException) {
      messageError("Error", "${response["error"]["message"]}");
    } else if (statuesRequest == StatuesRequest.unauthorizedException) {
      messageErrorWithButton("Error", "You need to login ", () {
        Get.offAll(() => const LoginPage());
      }, "LogIn");
    } else if (statuesRequest == StatuesRequest.socketException) {
      messageError("Error", "please, check your internet");
    } else {
      messageError("Error", "There is a problem. Please,  try again later");
    }
    update();
  }

  logOut() async {
    statuesRequest = StatuesRequest.loading;
    update();
    var response = await profileRemoteData.logOut(
      token: sharedPreferences!.getString("token"),
    );

    statuesRequest = handlingData(response);

    if (statuesRequest == StatuesRequest.success) {
      sharedPreferences!.setString("pageStart", "Login");
      Get.offAll(() => const LoginPage());
    } else if (statuesRequest == StatuesRequest.unprocessableException) {
      messageError("Error", "${response["error"]["message"]}");
    } else if (statuesRequest == StatuesRequest.socketException) {
      messageError("Error", "please, check your internet");
    } else {
      messageError("Error", "There is a problem. Please,  try again later");
    }

    update();
  }

  deleteAcc() async {
    statuesRequest = StatuesRequest.loading;
    update();
    var response = await profileRemoteData.deleteAcc(
        token: sharedPreferences!.getString("token"),
        password: passOldController.text);

    statuesRequest = handlingData(response);

    if (statuesRequest == StatuesRequest.success) {
      if (response['status'] == 'error') {
        messageError("Error", "${response["message"]}");
      } else {
        if (sharedPreferences!.getString("Mood") == "Dark") {
          sharedPreferences!.clear();
          sharedPreferences!.setString("pageStart", "Login");
          sharedPreferences!.setString("Mood", "Dark");
        } else {
          sharedPreferences!.clear();
          sharedPreferences!.setString("pageStart", "Login");
        }

        Get.offAll(() => const LoginPage());
      }
    } else if (statuesRequest == StatuesRequest.socketException) {
      messageError("Error", "please, check your internet");
    } else {
      messageError("Error", "There is a problem. Please,  try again later");
    }

    update();
  }

  changePassword() async {
    if (changePassKey.currentState!.validate()) {
      statuesRequest = StatuesRequest.loading;
      update();
      var response = await profileRemoteData.changeOldPass(
          token: sharedPreferences!.getString("token"),
          newPass: passNewController.text,
          newConfirmPass: passNewConfirmController.text,
          oldPass: passOldController.text);

      statuesRequest = handlingData(response);

      if (statuesRequest == StatuesRequest.success) {
        final responseBody = response;
        if (responseBody['status'] == "error") {
          Get.back();
          messageError("Error", "The old password is wrong");
        } else {
          Get.back();
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              snackBarWidget(message: "Your new password save successfully !"));
          Get.back();
        }
      } else if (statuesRequest == StatuesRequest.unprocessableException) {
        messageError("Error", "${response["error"]["message"]}");
      } else if (statuesRequest == StatuesRequest.socketException) {
        messageError("Error", "please, check your internet");
      } else {
        messageError("Error", "There is a problem. Please,  try again later");
      }
    }
    update();
  }

  @override
  void onInit() {
    getProfile();
    getCountry();
    super.onInit();
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
