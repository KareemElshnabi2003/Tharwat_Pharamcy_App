import 'dart:io';

import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_api.dart';
import 'package:tharwat_pharmacy/main.dart';

class ProfileRemoteData {
  Api api;
  ProfileRemoteData(this.api);

  Future<dynamic> getDataProfile({String? token}) async {
    var response = await api.getData(
      AppApi.profileInfoUrl,
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> updateDataProfile({
    String? token,
    String? phone,
    File? image,
    String? name,
    dynamic cityId,
    dynamic countryId,
    dynamic districtId,
  }) async {
    var response = await api.postRequestwithfile(
        AppApi.updateProfileInfoUrl,
        {
          "phone": phone ?? "",
          "name": name ?? "",
          "city_id": cityId?.toString() ?? "",
          "country_id": countryId?.toString() ?? "",
          "district_id": districtId?.toString() ?? "",
          "email": sharedPreferences?.getString("email") ?? "",
        },
        image,
        token ?? "");
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> logOut({String? token}) async {
    var response = await api.getData(
      AppApi.logoutUrl,
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> deleteAcc({String? token, String? password}) async {
    final url = Api.buildUrl(AppApi.deleteAccUrl, {
      if (password != null) 'password': password,
    });
    var response = await api.deleteData(
      url,
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> changeOldPass({
    String? oldPass,
    String? newPass,
    String? newConfirmPass,
    String? token,
  }) async {
    var response = await api.postData(
      AppApi.changeOldPassUrl,
      Api.authHeaders(token),
      {
        "email": sharedPreferences?.getString("email") ?? "",
        "old_password": oldPass ?? "",
        "password": newPass ?? "",
        "password_confirmation": newConfirmPass ?? ""
      },
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> contactUs({
    String? email,
    String? userName,
    String? message,
    String? token,
  }) async {
    var response = await api.postData(
      AppApi.contactUsUrl,
      Api.authHeaders(token),
      {
        "user_name": userName ?? "",
        "email": email ?? "",
        "message": message ?? "",
      },
    );
    return response.fold((l) => l, (r) => r);
  }
}
