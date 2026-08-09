import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_api.dart';
import 'package:tharwat_pharmacy/main.dart';

class AuthRemoteData {
  Api api;
  AuthRemoteData(this.api);
  login({String? email, String? password}) async {
    var response = await api.postData(AppApi.loginUrl, {
      "Accept": "application/json",
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json'
    }, {
      "email": email,
      "password": password
    });
    return response.fold((l) => l, (r) => r);
  }

  register(
      {String? email,
      String? password,
      String? name,
      String? gender,
      String? passwordConfirmation,
      String? phone,
      String? cityId,
      String? districtId,
      String? countryId}) async {
    var response = await api.postData(AppApi.registerUrl, {
      "Accept": "application/json",
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    }, {
      "name": name,
      "gender": gender!.toLowerCase(),
      "password": password,
      "password_confirmation": passwordConfirmation,
      "email": email,
      "phone": phone,
      "city_id": cityId,
      "country_id": countryId,
      "district_id": districtId
    });
    return response.fold((l) => l, (r) => r);
  }

  sendOTP({
    String? email,
  }) async {
    var response = await api.postData(AppApi.sendOTPUrl, {
      "Accept": "application/json",
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    }, {
      "email": email,
    });
    return response.fold((l) => l, (r) => r);
  }

  resetPAss({String? email, password, passwordConfirmation}) async {
    var response = await api.postData(AppApi.resetPassUrl, {
      "Accept": "application/json",
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    }, {
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation
    });
    return response.fold((l) => l, (r) => r);
  }

  verifyOTP({String? email, String? otp}) async {
    var response = await api.postData(AppApi.verifyCodeUrl, {
      "Accept": "application/json",
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    }, {
      "email": email,
      "token": otp
    });
    return response.fold((l) => l, (r) => r);
  }
}
