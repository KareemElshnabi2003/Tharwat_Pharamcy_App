import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_api.dart';

class LocationRemoteData {
  Api api;
  LocationRemoteData(this.api);

  Future<dynamic> getCountries() async {
    var response = await api.getData(
      Api.buildUrl(AppApi.getCountryUrl, {"per_page": "27"}),
      null,
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> getCities({String? countryId}) async {
    var response = await api.getData(
      Api.buildUrl(AppApi.getCityUrl, {
        "per_page": "20",
        if (countryId != null) "country_id": countryId,
      }),
      null,
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> getDistrict({String? cityId}) async {
    var response = await api.getData(
      Api.buildUrl(AppApi.getDistrictUrl, {
        "per_page": "20",
        if (cityId != null) "city_id": cityId,
      }),
      null,
    );
    return response.fold((l) => l, (r) => r);
  }
}
