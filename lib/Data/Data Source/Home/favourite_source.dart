import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_api.dart';

class FavouriteRemoteData {
  Api api;
  FavouriteRemoteData(this.api);

  getFavProducts({token, page}) async {
    var response = await api.getData(
      "${AppApi.favProductsUrl}?per_page=15&page=$page",
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }

  addToFav({token, id}) async {
    var response = await api.postData(
      "${AppApi.addToFavProductsUrl}/$id",
      Api.authHeaders(token),
      {},
    );
    return response.fold((l) => l, (r) => r);
  }

  removeFromFav({token, id}) async {
    var response = await api.postData(
      "${AppApi.addToFavProductsUrl}/$id",
      Api.authHeaders(token),
      {},
    );
    return response.fold((l) => l, (r) => r);
  }
}
