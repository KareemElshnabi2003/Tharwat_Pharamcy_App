import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_api.dart';
import 'package:tharwat_pharmacy/main.dart';

class CategoriesRemoteData {
  Api api;
  CategoriesRemoteData(this.api);

  getCategories({token}) async {
    var response = await api.getData(
      AppApi.categoriestUrl,
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }

  getSubCategories({token, catId, page}) async {
    var response = await api.getData(
      "${AppApi.subCategoriestUrl}?category=$catId&page=$page",
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }

  getProductsCategories({token, catId, page}) async {
    var response = await api.getData(
      "${AppApi.allProductstUrl}?category_id=$catId&per_page=20&page=$page",
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }

  search(
      {token,
      maxPrice,
      minPrice,
      catId,
      availability,
      special,
      query,
      page}) async {
    var response = await api.getData(
      "${AppApi.allProductstUrl}?category_id=$catId&per_page=20&page=$page&query=$query&in_stock=${sharedPreferences!.getString("stock") ?? ""}&max_price=${sharedPreferences!.getString("maxPrice") ?? ""}&min_price=${sharedPreferences!.getString("minPrice") ?? ""}",
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }
}
