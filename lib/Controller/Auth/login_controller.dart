import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Core/function/handling_data.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Auth/auth_source.dart';
import 'package:tharwat_pharmacy/Data/Model/User/user_auth_model.dart';
import 'package:tharwat_pharmacy/View/Screeens/Auth/succsess_login.dart';
import 'package:tharwat_pharmacy/View/Screeens/Auth/verify_sign.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/message_error.dart';
import 'package:tharwat_pharmacy/main.dart';

class LoginController extends GetxController {
  GlobalKey<FormState> loginKey = GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  StatuesRequest statuesRequest = StatuesRequest.none;
  AuthRemoteData authRemoteData = AuthRemoteData(Get.find<Api>());
  UserAuthModel? userAuthModel;
  bool show = true;

  changeShow() {
    show = !show;
    update();
  }

  emailValidtor(String val) {
    if (val.isEmpty) {
      return "Please, Enter your email";
    } else if (!val.isEmail) {
      return "Email not valid";
    } else {
      return null;
    }
  }

  passwordValidtor(String val) {
    if (val.isEmpty) {
      return "Please, Enter your password";
    } else if (val.length < 8) {
      return "Password too short";
    } else {
      return null;
    }
  }

  bool isLoading = false;

  sendOTP() async {
    if (isLoading) return;
    isLoading = true;
    try {
      statuesRequest = StatuesRequest.loading;
      update();
      var response = await authRemoteData.sendOTP(
        email: emailController.text,
      );

      statuesRequest = handlingData(response);

      handleApiResponse(
        status: statuesRequest,
        response: response,
        onSuccess: (data) {
          sharedPreferences?.setString("pageStart", "VerifySign");
          Get.to(() => const VerifySign());
        },
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  login() async {
    if (isLoading) return;
    if (loginKey.currentState!.validate()) {
      isLoading = true;
      try {
        statuesRequest = StatuesRequest.loading;
        update();
        var response = await authRemoteData.login(
          email: emailController.text,
          password: passwordController.text,
        );

        statuesRequest = handlingData(response);

        handleApiResponse(
          status: statuesRequest,
          response: response,
          onSuccess: (data) {
            if (data['status'] == "error") {
              data["message"] == "messages.login.email_not_verify"
                  ? messageErrorVerify("Error", "The Email not verified",
                      () async {
                      Get.back();
                      await sendOTP();
                    })
                  : data["message"] == "messages.login.invalid_credentials"
                      ? messageError("Error", "Email or pass is invalid")
                      : messageError("Error", "${data['message']}");
            } else {
              Map<String, dynamic> responseBody = data['data'];
              userAuthModel = UserAuthModel.fromJson(responseBody);

              if (userAuthModel!.role == "User") {
                sharedPreferences?.setString(
                    "email", "${userAuthModel!.email}");
                sharedPreferences?.setString("id", "${userAuthModel!.id}");
                sharedPreferences?.setString(
                    "token", "${userAuthModel!.token}");
                sharedPreferences?.setString("name", "${userAuthModel!.name}");
                sharedPreferences?.setString("role", "${userAuthModel!.role}");
                sharedPreferences?.setString(
                    "cityId", "${userAuthModel!.district!.city!.id}");
                sharedPreferences?.setString("countryId",
                    "${userAuthModel!.district!.city!.country!.id}");
                sharedPreferences?.setString(
                    "districtId", "${userAuthModel!.district!.id}");
                sharedPreferences?.setString(
                    "cityName", "${userAuthModel!.district!.city!.name}");
                sharedPreferences?.setString("countryName",
                    "${userAuthModel!.district!.city!.country!.name}");
                sharedPreferences?.setString(
                    "districtName", "${userAuthModel!.district!.name}");
                sharedPreferences?.setString("pageStart", "Home");

                Get.offAll(() => const SuccsessLogin());
              } else {
                sharedPreferences?.setString(
                    "roleDelivery", "${userAuthModel!.role}");
                sharedPreferences?.setString("pageStart", "HomeDelivery");
                sharedPreferences?.setString(
                    "tokenDelivery", "${userAuthModel!.token}");
                sharedPreferences?.setString(
                    "emailDelivery", "${userAuthModel!.email}");
                sharedPreferences?.setString(
                    "nameDelivery", "${userAuthModel!.name}");
                sharedPreferences?.setString(
                    "idDelivery", "${userAuthModel!.id}");

                Get.offAll(() => const SuccsessLogin());
              }
            }
          },
        );
      } finally {
        isLoading = false;
        update();
      }
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
