import 'package:get/get.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Core/function/handle_exception.dart';
import 'package:tharwat_pharmacy/Core/function/handling_data.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Auth/auth_source.dart';
import 'package:tharwat_pharmacy/Data/Model/User/user_auth_model.dart';
import 'package:tharwat_pharmacy/View/Screeens/Auth/reset_pass.dart';
import 'package:tharwat_pharmacy/View/Screeens/Auth/succsess_sign.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/message_error.dart';
import 'package:tharwat_pharmacy/main.dart';

class VerifyCodeController extends GetxController {
  String verifyCodeSign = '';
  String verifyCodeForget = '';
  StatuesRequest statuesRequest = StatuesRequest.none;
  AuthRemoteData authRemoteData = AuthRemoteData(Get.find<Api>());
  UserAuthModel? userAuthModel;
  String email = '';
  bool click = false;

  void change() {
    if (click == false) {
      click = true;
      sendOTP();
    } else {
      click = false;
    }
    update();
  }

  Future<void> sendOTP() async {
    verifyCodeSign = '';
    verifyCodeForget = '';
    try {
      statuesRequest = StatuesRequest.loading;
      update();
      var response = await authRemoteData.sendOTP(email: email);
      statuesRequest = handlingData(response);

      handleApiResponse(
        status: statuesRequest,
        response: response,
        onSuccess: (data) {
          click = false;
        },
      );
    } catch (e) {
      statuesRequest = handleException(e);
      click = false;
    } finally {
      if (statuesRequest == StatuesRequest.loading) {
        statuesRequest = StatuesRequest.none;
      }
      update();
    }
  }

  Future<void> setValSign(String val) async {
    verifyCodeSign = val;
    await verifySign();
    update();
  }

  Future<void> setValForgetPass(String val) async {
    verifyCodeForget = val;
    await verifyForgetPass();
    update();
  }

  Future<void> verifySign() async {
    if (verifyCodeSign.isEmpty) return;
    try {
      statuesRequest = StatuesRequest.loading;
      update();
      var response =
          await authRemoteData.verifyOTP(email: email, otp: verifyCodeSign);
      statuesRequest = handlingData(response);

      handleApiResponse(
        status: statuesRequest,
        response: response,
        onSuccess: (data) {
          if (data['status'] == "error") {
            messageError("Error", "Code is invalid");
          } else {
            userAuthModel = UserAuthModel.fromJson(data['data']);
            sharedPreferences?.setString("phone", "${userAuthModel!.phone}");
            sharedPreferences?.setString("email", "${userAuthModel!.email}");
            sharedPreferences?.setString("image", "${userAuthModel!.image}");
            sharedPreferences?.setString("token", "${userAuthModel!.token}");
            sharedPreferences?.setString("name", "${userAuthModel!.name}");
            sharedPreferences?.setString("role", "${userAuthModel!.role}");
            sharedPreferences?.setString(
                "cityName", userAuthModel!.district?.city?.name ?? "");
            sharedPreferences?.setString("countryName",
                userAuthModel!.district?.city?.country?.name ?? '');
            sharedPreferences?.setString(
                "districtName", userAuthModel!.district?.name ?? '');
            sharedPreferences?.setString(
                "cityId", "${userAuthModel!.district?.city?.id ?? ''}");
            sharedPreferences?.setString("countryId",
                "${userAuthModel!.district?.city?.country?.id ?? ''}");
            sharedPreferences?.setString(
                "districtId", "${userAuthModel!.district?.id ?? ''}");
            sharedPreferences?.setString("pageStart", "Home");
            Get.offAll(() => const SuccsessSign());
          }
        },
      );
    } catch (e) {
      statuesRequest = handleException(e);
      messageError("Error", "Code is invalid or an error occurred");
    } finally {
      if (statuesRequest == StatuesRequest.loading) {
        statuesRequest = StatuesRequest.none;
      }
      update();
    }
  }

  Future<void> verifyForgetPass() async {
    if (verifyCodeForget.isEmpty) return;
    try {
      statuesRequest = StatuesRequest.loading;
      update();
      var response =
          await authRemoteData.verifyOTP(email: email, otp: verifyCodeForget);
      statuesRequest = handlingData(response);

      handleApiResponse(
        status: statuesRequest,
        response: response,
        onSuccess: (data) {
          if (data['status'] == "error") {
            messageError("Error", "Code is invalid");
          } else {
            sharedPreferences?.setString("pageStart", "Login");
            Get.off(() => const ResetPass());
          }
        },
      );
    } catch (e) {
      statuesRequest = handleException(e);
      messageError("Error", "Code is invalid or an error occurred");
    } finally {
      if (statuesRequest == StatuesRequest.loading) {
        statuesRequest = StatuesRequest.none;
      }
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      email = args['email']?.toString() ?? "";
    } else if (args is String) {
      email = args;
    }
  }
}
