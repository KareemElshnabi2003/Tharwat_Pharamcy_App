import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/Constant/contact_config.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Core/function/handling_data.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Profile/profile_source.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/message_error.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/snack_bar_widgte.dart';
import 'package:tharwat_pharmacy/main.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsController extends GetxController {
  GlobalKey<FormState> changePassKey = GlobalKey<FormState>();
  StatuesRequest statuesRequest = StatuesRequest.none;
  ProfileRemoteData profileRemoteData = ProfileRemoteData(Get.find<Api>());
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  String? status;

  String? userNameValidtor(String val) => userNameValidator(val);
  String? userNameValidator(String val) {
    if (val.isEmpty) {
      return "Please, Enter your name ";
    } else if (val.length > 25) {
      return "Your name is too long ";
    } else {
      return null;
    }
  }

  String? emailValidtor(String val) => emailValidator(val);
  String? emailValidator(String val) {
    if (val.isEmpty) {
      return "Please, Enter your email ";
    } else {
      return null;
    }
  }

  String? messageValidtor(String val) => messageValidator(val);
  String? messageValidator(String val) {
    if (val.isEmpty) {
      return "Please, Enter your message ";
    } else if (val.length < 10) {
      return "Your message is short ";
    } else {
      return null;
    }
  }

  Future<void> urlLauncher(String name) => urlLuncher(name);
  Future<void> urlLuncher(String name) async {
    String? urlString;
    if (name == "sms") {
      urlString = ContactConfig.smsUrl;
    } else if (name == "phone") {
      urlString = ContactConfig.phoneUrl;
    } else if (name == "watsapp") {
      urlString = ContactConfig.whatsappUrl;
    } else if (name == "facebook") {
      urlString = ContactConfig.facebookUrl;
    } else if (name == "instagram") {
      urlString = ContactConfig.instagramUrl;
    } else if (name == "twitter") {
      urlString = ContactConfig.twitterUrl;
    } else if (name == "linkedin") {
      urlString = ContactConfig.linkedinUrl;
    } else if (name == "tiktok") {
      urlString = ContactConfig.tiktokUrl;
    } else if (name == "gmail") {
      urlString = ContactConfig.mailtoUrl;
    }

    if (urlString == null) return;

    try {
      final Uri uri = Uri.parse(urlString);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        Get.snackbar("Notice", "Could not open $name application");
      }
    } catch (_) {
      Get.snackbar("Notice", "Could not open $name application");
    }
  }

  Future<void> sendMessage() => sendMesssage();
  Future<void> sendMesssage() async {
    if (changePassKey.currentState?.validate() ?? false) {
      Get.back();
      try {
        statuesRequest = StatuesRequest.loading;
        update();
        var response = await profileRemoteData.contactUs(
          email: emailController.text,
          message: messageController.text,
          userName: userNameController.text,
          token: sharedPreferences?.getString("token"),
        );

        statuesRequest = handlingData(response);

        if (statuesRequest == StatuesRequest.success) {
          Map<String, dynamic> responseBody = response;
          status = responseBody['status'];
          Get.back();
          if (Get.context != null) {
            ScaffoldMessenger.of(Get.context!).showSnackBar(
                snackBarWidget(message: "Your message sent successfully !"));
          }
        } else if (statuesRequest == StatuesRequest.socketException) {
          messageError("Error", "please, check your internet");
        } else {
          messageError("Error", parseErrorMessage(response));
        }
      } catch (e) {
        statuesRequest = StatuesRequest.serverError;
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
  void onClose() {
    userNameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
