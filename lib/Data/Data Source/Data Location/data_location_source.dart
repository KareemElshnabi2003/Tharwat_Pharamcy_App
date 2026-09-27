import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_api.dart';

class LocationRemoteData {
  Api api;
  LocationRemoteData(this.api);

  getCountries() async {
    var response =
        await api.getData("${AppApi.getCountryUrl}?per_page=27", null);
    return response.fold((l) => l, (r) => r);
  }

  getCities({countryId}) async {
    var response = await api
        .getData("${AppApi.getCityUrl}?per_page=20&country_id=$countryId", null);
    return response.fold((l) => l, (r) => r);
  }

  getDistrict({cityId}) async {
    var response = await api
        .getData("${AppApi.getDistrictUrl}?per_page=20&city_id=$cityId", null);
    return response.fold((l) => l, (r) => r);
  }
}
