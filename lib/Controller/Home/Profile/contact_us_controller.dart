import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Core/function/handling_data.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Profile/profile_source.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/message_error.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/snack_bar_widgte.dart';
import 'package:tharwat_pharmacy/main.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsController extends GetxController {
  GlobalKey<FormState> changePassKey = GlobalKey();
  StatuesRequest statuesRequest = StatuesRequest.none;
  ProfileRemoteData profileRemoteData = ProfileRemoteData(Get.put(Api()));
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  String? status;
  userNameValidtor(String val) {
    if (val.isEmpty) {
      return "Please, Enter your name ";
    } else if (val.length > 25) {
      return "Your name is too long ";
    } else {
      return null;
    }
  }

  emailValidtor(String val) {
    if (val.isEmpty) {
      return "Please, Enter your email ";
    } else {
      return null;
    }
  }

  messageValidtor(String val) {
    if (val.isEmpty) {
      return "Please, Enter your message ";
    } else if (val.length < 10) {
      return "Your message is short ";
    } else {
      return null;
    }
  }

  Future<void> urlLuncher(
    String name,
  ) async {
    if (name == "sms") {
      final Uri url = Uri.parse('sms:+201281265373');
      if (!await launchUrl(url)) {
        throw "can't launch $url";
      }
    } else if (name == "phone") {
      final Uri url = Uri.parse('tel:+201281265373');
      if (!await launchUrl(url)) {
        throw "can't launch $url";
      }
    } else if (name == "watsapp") {
      final Uri url = Uri.parse('whatsapp://send?phone=+201281265373');
      if (!await launchUrl(url)) {
        throw "can't launch $url";
      }
    } else if (name == "facebook") {
      final Uri url =
          Uri.parse('https://www.facebook.com/profile.php?id=100009638558266');
      if (!await launchUrl(url)) {
        throw "can't launch $url";
      }
    } else if (name == "instagram") {
      final Uri url = Uri.parse(
          'https://www.instagram.com/kareem_elshnabi/profilecard/?igsh=ZHJia3dtdDdycnlx');

      if (!await launchUrl(url)) {
        throw "can't launch $url";
      }
    } else if (name == "twitter") {
      final Uri url = Uri.parse('https://www.threads.net/@FCBarcelona');

      if (!await launchUrl(url)) {
        throw "can't launch $url";
      }
    } else if (name == "linkedin") {
      final Uri url = Uri.parse(
          'https://www.linkedin.com/company/white-eagle-event-company/');

      if (!await launchUrl(url)) {
        throw "can't launch $url";
      }
    } else if (name == "tiktok") {
      final Uri url = Uri.parse(
          'https://www.tiktok.com/@whiteeagleevent?_t=8lDZLVLCod8&_r=1');

      if (!await launchUrl(url)) {
        throw "can't launch $url";
      }
    } else if (name == "gmail") {
      final Uri url = Uri.parse(
          'mailto:kareemelshnabi@gmail.com?subject=News&body=New plugin');

      if (!await launchUrl(url)) {
        throw "can't launch $url";
      }
    }
  }

  sendMesssage() async {
    if (changePassKey.currentState!.validate()) {
      Get.back();
      statuesRequest = StatuesRequest.loading;
      update();
      var response = await profileRemoteData.contactUs(
        email: emailController.text,
        message: messageController.text,
        userName: userNameController.text,
        token: sharedPreferences!.getString("token"),
      );
      print(" response ??? $response");

      statuesRequest = handlingData(response);

      if (statuesRequest == StatuesRequest.success) {
        Map<String, dynamic> responseBody = response;
        print("response :: $responseBody");
        status = responseBody['status'];
        Get.back();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
            snackBarWidget(message: "Your message sent successfully !"));
        update();
      } else if (statuesRequest == StatuesRequest.socketException) {
        messageError("Error", "please, check your internet");
      } else {
        messageError("Error", "There is a problem. Please,  try again later");
      }
    }
    update();
  }

  @override
  void onClose() {
    userNameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
