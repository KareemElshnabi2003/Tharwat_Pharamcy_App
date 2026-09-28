import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_api.dart';

class AuthRemoteData {
  Api api;
  AuthRemoteData(this.api);

  Future<dynamic> login({String? email, String? password}) async {
    var response = await api.postData(AppApi.loginUrl, null, {
      "email": email,
      "password": password,
    });
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> register({
    String? email,
    String? password,
    String? name,
    String? gender,
    String? passwordConfirmation,
    String? phone,
    String? cityId,
    String? districtId,
    String? countryId,
  }) async {
    var response = await api.postData(AppApi.registerUrl, null, {
      "name": name,
      "gender": gender?.toLowerCase(),
      "password": password,
      "password_confirmation": passwordConfirmation,
      "email": email,
      "phone": phone,
      "city_id": cityId,
      "country_id": countryId,
      "district_id": districtId,
    });
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> sendOTP({
    String? email,
  }) async {
    var response = await api.postData(AppApi.sendOTPUrl, null, {
      "email": email,
    });
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> resetPAss(
      {String? email, String? password, String? passwordConfirmation}) async {
    var response = await api.postData(AppApi.resetPassUrl, null, {
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation,
    });
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> verifyOTP({String? email, String? otp}) async {
    var response = await api.postData(AppApi.verifyCodeUrl, null, {
      "email": email,
      "token": otp,
    });
    return response.fold((l) => l, (r) => r);
  }
}
