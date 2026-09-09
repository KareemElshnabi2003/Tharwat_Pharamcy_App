import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Core/function/handling_data.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Auth/auth_source.dart';
import 'package:tharwat_pharmacy/View/Screeens/Auth/succsess_reset_pass.dart';
import 'package:tharwat_pharmacy/View/Screeens/Auth/verify_forget_pass.dart';
import 'package:tharwat_pharmacy/main.dart';

class ForgetPassController extends GetxController {
  StatuesRequest statuesRequest = StatuesRequest.none;
  AuthRemoteData authRemoteData = AuthRemoteData(Get.put(Api()));
  GlobalKey<FormState> forgetPassKey = GlobalKey();
  GlobalKey<FormState> resetPassKey = GlobalKey();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  bool show_1 = true;
  bool show_2 = true;

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

  sendOTP() async {
    log(emailController.text);
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
        sharedPreferences!.setString("pageStart", "VerifyForget");
        Get.to(() => const VerifyForgetPass(),
            arguments: {"email": emailController.text});
      },
    );
    update();
  }

  forgetPass() async {
    if (forgetPassKey.currentState!.validate()) {
      await sendOTP();
    }
  }

  resetPass() async {
    if (resetPassKey.currentState!.validate()) {
      statuesRequest = StatuesRequest.loading;
      update();
      var response = await authRemoteData.resetPAss(
          email: emailController.text,
          password: passwordController.text,
          passwordConfirmation: passwordConfirmController.text);

      statuesRequest = handlingData(response);

      handleApiResponse(
        status: statuesRequest,
        response: response,
        onSuccess: (data) {
          sharedPreferences!.setString("pageStart", "Home");
          Get.offAll(() => const SuccsessResetPass());
        },
      );
      update();
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.onClose();
  }
}
