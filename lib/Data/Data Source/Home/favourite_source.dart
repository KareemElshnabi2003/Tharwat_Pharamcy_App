import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_api.dart';
import 'package:tharwat_pharmacy/main.dart';

class FavouriteRemoteData {
  Api api;
  FavouriteRemoteData(this.api);
  getFavProducts({token, page}) async {
    var response =
        await api.getData("${AppApi.favProductsUrl}?per_page=15&page=$page", {
      "Accept": "application/json",
      'authorization': 'Bearer $token',
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    });
    return response.fold((l) => l, (r) => r);
  }

  addToFav({token, id}) async {
    var response = await api.postData("${AppApi.addToFavProductsUrl}/$id", {
      "Accept": "application/json",
      'authorization': 'Bearer $token',
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    }, {});
    return response.fold((l) => l, (r) => r);
  }

  removeFromFav({token, id}) async {
    var response = await api.postData("${AppApi.addToFavProductsUrl}/$id", {
      "Accept": "application/json",
      'authorization': 'Bearer $token',
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    }, {});
    return response.fold((l) => l, (r) => r);
  }
}
