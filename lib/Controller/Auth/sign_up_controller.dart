import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Core/function/handling_data.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Auth/auth_source.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Data%20Location/data_location_source.dart';
import 'package:tharwat_pharmacy/Data/Model/User/city_model.dart';
import 'package:tharwat_pharmacy/Data/Model/User/country_model.dart';
import 'package:tharwat_pharmacy/Data/Model/User/district_model.dart';
import 'package:tharwat_pharmacy/Data/Model/User/user_auth_model.dart';
import 'package:tharwat_pharmacy/View/Screeens/Auth/verify_sign.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/message_error.dart';

class SignUpController extends GetxController {
  StatuesRequest statuesRequest = StatuesRequest.none;
  AuthRemoteData authRemoteData = AuthRemoteData(Get.put(Api()));
  LocationRemoteData locationRemoteData = LocationRemoteData(Get.put(Api()));

  UserAuthModel? userAuthModel;
  GlobalKey<FormState> signUpKey = GlobalKey();

  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  String? cityController;
  String? governorateController;
  String? districtController;
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  bool check = false;
  bool show_1 = true;
  bool show_2 = true;

  String? cityId;
  String? countryId;
  String? districtId;
  List genderList = ["Male", "Female"];
  String? gender;

  List<CountryModel> governorateList = [];
  List<CityModel> cityList = [];
  List<DistrictModel> districtList = [];

  changeGender(val) {
    gender = val;
    update();
  }

  changeCity(val) {
    districtController = null;
    cityController = val;
    getDistrict();
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
    update();
  }

  confirmCheck() {
    check = !check;
    update();
  }

  changeShow_1() {
    show_1 = !show_1;
    update();
  }

  changeShow_2() {
    show_2 = !show_2;
    update();
  }

  emailValidtor(String val) {
    if (val.isEmpty) return "Please, Enter your email";
    if (!val.isEmail) return "Email not valid";
    return null;
  }

  userNameValidtor(String val) {
    if (val.isEmpty) return "Please, Enter your name ";
    if (val.length > 25) return "Your name is too long ";
    if (val.length < 10) return "Your name is short ";
    return null;
  }

  addressValidtor(String val) {
    if (val.isEmpty) return "Please, Enter your address ";
    return null;
  }

  phoneValidtor(String val) {
    if (!val.isPhoneNumber) return "Please, Enter your phone ";
    return null;
  }

  ageValidtor(String val) {
    if (!val.isNum) return "Please, Enter your age ";
    return null;
  }

  passwordValidtor(String val) {
    if (val.isEmpty) return "Please, Enter your password";
    if (val.length < 8) return "Password too short";
    return null;
  }

  passwordConfirmValidtor(String val) {
    if (val.isEmpty) return "Please, Enter your password";
    if (val != passwordController.text) return "Password not match";
    return null;
  }

  bool isLoading = false;
  bool isLoadingCountry = false;
  bool isLoadingCity = false;
  bool isLoadingDistrict = false;

  getCountry() async {
    if (isLoadingCountry) return;
    isLoadingCountry = true;
    try {
      governorateList.clear();
      var response = await locationRemoteData.getCountries();
      statuesRequest = handlingData(response);

      handleApiResponse(
        status: statuesRequest,
        response: response,
        onSuccess: (data) {
          governorateList = ((data['data'] as List?) ?? [])
              .map((item) => CountryModel.fromJson(item))
              .toList();
        },
      );
      update();
    } finally {
      isLoadingCountry = false;
    }
  }

  getCity() async {
    if (governorateController != null && !isLoadingCity) {
      isLoadingCity = true;
      try {
        cityList.clear();
        var response = await locationRemoteData.getCities(countryId: countryId);
        statuesRequest = handlingData(response);

        handleApiResponse(
          status: statuesRequest,
          response: response,
          onSuccess: (data) {
            cityList = ((data['data'] as List?) ?? [])
                .map((item) => CityModel.fromJson(item))
                .toList();
          },
        );
        update();
      } finally {
        isLoadingCity = false;
      }
    }
  }

  getDistrict() async {
    if (cityController != null && !isLoadingDistrict) {
      isLoadingDistrict = true;
      try {
        districtList.clear();
        var response = await locationRemoteData.getDistrict(cityId: cityId);
        statuesRequest = handlingData(response);

        handleApiResponse(
          status: statuesRequest,
          response: response,
          onSuccess: (data) {
            districtList = ((data['data'] as List?) ?? [])
                .map((item) => DistrictModel.fromJson(item))
                .toList();
          },
        );
        update();
      } finally {
        isLoadingDistrict = false;
      }
    }
  }

  signUp() async {
    if (isLoading) return;
    if (signUpKey.currentState!.validate() &&
        check == true &&
        districtId != null &&
        countryId != null &&
        cityId != null &&
        gender != null) {
      isLoading = true;
      try {
        statuesRequest = StatuesRequest.loading;
        update();
        var response = await authRemoteData.register(
            cityId: cityId,
            countryId: countryId,
            districtId: districtId,
            email: emailController.text,
            gender: gender,
            name: userNameController.text,
            password: passwordController.text,
            passwordConfirmation: passwordConfirmController.text,
            phone: phoneController.text);

        statuesRequest = handlingData(response);

        handleApiResponse(
          status: statuesRequest,
          response: response,
          onSuccess: (data) {
            Get.to(() => const VerifySign(),
                arguments: {"email": emailController.text});
          },
        );
      } finally {
        isLoading = false;
        update();
      }
    } else if (!check) {
      messageError("Warning", "Please confirm our policy and privacy");
    } else {
      gender == null
          ? messageError("Warning", "Please choose your gender")
          : messageError("Warning", "Please choose your address");
    }
    update();
  }

  @override
  void onInit() {
    getCountry();
    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    userNameController.dispose();
    ageController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.onClose();
  }
}
