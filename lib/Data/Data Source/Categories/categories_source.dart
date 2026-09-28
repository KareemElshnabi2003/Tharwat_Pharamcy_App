import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_api.dart';
import 'package:tharwat_pharmacy/main.dart';

class CategoriesRemoteData {
  Api api;
  CategoriesRemoteData(this.api);

  Future<dynamic> getCategories({String? token}) async {
    var response = await api.getData(
      AppApi.categoriestUrl,
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> getSubCategories({
    String? token,
    required dynamic catId,
    int? page,
  }) async {
    var response = await api.getData(
      Api.buildUrl(AppApi.subCategoriestUrl, {
        "category": catId.toString(),
        if (page != null) "page": page.toString(),
      }),
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> getProductsCategories({
    String? token,
    required dynamic catId,
    int? page,
  }) async {
    var response = await api.getData(
      Api.buildUrl(AppApi.allProductstUrl, {
        "category_id": catId.toString(),
        "per_page": "20",
        if (page != null) "page": page.toString(),
      }),
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> search({
    String? token,
    dynamic catId,
    String? query,
    int? page,
    String? inStock,
    String? minPrice,
    String? maxPrice,
  }) async {
    final effectiveStock =
        inStock ?? sharedPreferences?.getString("stock") ?? "";
    final effectiveMin =
        minPrice ?? sharedPreferences?.getString("minPrice") ?? "";
    final effectiveMax =
        maxPrice ?? sharedPreferences?.getString("maxPrice") ?? "";

    var response = await api.getData(
      Api.buildUrl(AppApi.allProductstUrl, {
        if (catId != null) "category_id": catId.toString(),
        "per_page": "20",
        if (page != null) "page": page.toString(),
        if (query != null && query.isNotEmpty) "query": query,
        if (effectiveStock.isNotEmpty) "in_stock": effectiveStock,
        if (effectiveMin.isNotEmpty) "min_price": effectiveMin,
        if (effectiveMax.isNotEmpty) "max_price": effectiveMax,
      }),
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }
}
