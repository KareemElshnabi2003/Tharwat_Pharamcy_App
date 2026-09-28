import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_api.dart';

class FavouriteRemoteData {
  Api api;
  FavouriteRemoteData(this.api);

  Future<dynamic> getFavProducts({String? token, int? page}) async {
    var response = await api.getData(
      Api.buildUrl(AppApi.favProductsUrl, {
        "per_page": "15",
        if (page != null) "page": page.toString(),
      }),
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> addToFav({String? token, required int id}) async {
    var response = await api.postData(
      "${AppApi.addToFavProductsUrl}/${Uri.encodeComponent(id.toString())}",
      Api.authHeaders(token),
      <String, dynamic>{},
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> removeFromFav({String? token, required int id}) async {
    var response = await api.postData(
      "${AppApi.addToFavProductsUrl}/${Uri.encodeComponent(id.toString())}",
      Api.authHeaders(token),
      <String, dynamic>{},
    );
    return response.fold((l) => l, (r) => r);
  }
}
