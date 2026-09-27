import 'dart:io';

import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_api.dart';
import 'package:tharwat_pharmacy/main.dart';

class ProfileRemoteData {
  Api api;
  ProfileRemoteData(this.api);

  getDataProfile({token}) async {
    var response = await api.getData(
      AppApi.profileInfoUrl,
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }

  updateDataProfile({
    token,
    phone,
    File? image,
    name,
    cityId,
    countryId,
    districtId,
  }) async {
    var response = await api.postRequestwithfile(
        AppApi.updateProfileInfoUrl,
        {
          "phone": phone,
          "name": name,
          "city_id": cityId,
          "country_id": countryId,
          "district_id": districtId,
          "email": sharedPreferences!.getString("email"),
        },
        image,
        token);
    return response.fold((l) => l, (r) => r);
  }

  logOut({String? token}) async {
    var response = await api.getData(
      AppApi.logoutUrl,
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }

  deleteAcc({String? token, password}) async {
    var response = await api.deleteData(
      "${AppApi.deleteAccUrl}?password=$password",
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }

  changeOldPass({String? oldPass, newPass, newConfirmPass, token}) async {
    var response = await api.postData(
      AppApi.changeOldPassUrl,
      Api.authHeaders(token),
      {
        "email": sharedPreferences!.getString("email"),
        "old_password": oldPass,
        "password": newPass,
        "password_confirmation": newConfirmPass
      },
    );
    return response.fold((l) => l, (r) => r);
  }

  contactUs({email, userName, message, token}) async {
    var response = await api.postData(
      AppApi.contactUsUrl,
      Api.authHeaders(token),
      {
        "user_name": userName,
        "email": email,
        "message": message,
      },
    );
    return response.fold((l) => l, (r) => r);
  }
}
