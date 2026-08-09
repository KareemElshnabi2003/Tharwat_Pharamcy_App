import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_api.dart';
import 'package:tharwat_pharmacy/main.dart';

class LocationRemoteData {
  Api api;
  LocationRemoteData(this.api);
  getCountries() async {
    var response = await api.getData("${AppApi.getCountryUrl}?per_page=27", {
      "Accept": "application/json",
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    });
    return response.fold((l) => l, (r) => r);
  }

  getCities({countryId}) async {
    var response = await api
        .getData("${AppApi.getCityUrl}?per_page=20&country_id=$countryId", {
      "Accept": "application/json",
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    });
    return response.fold((l) => l, (r) => r);
  }

  getDistrict({cityId}) async {
    var response = await api
        .getData("${AppApi.getDistrictUrl}?per_page=20&city_id=$cityId", {
      "Accept": "application/json",
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    });
    return response.fold((l) => l, (r) => r);
  }
}
