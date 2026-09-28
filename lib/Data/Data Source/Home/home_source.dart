import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_api.dart';
import 'package:tharwat_pharmacy/main.dart';

class HomeRemoteData {
  Api api;
  HomeRemoteData(this.api);

  Map<String, dynamic> _buildFilterParams({
    dynamic page,
    String? query,
    String? inStock,
    String? maxPrice,
    String? minPrice,
  }) {
    final effectiveStock =
        inStock ?? sharedPreferences?.getString("stock") ?? "";
    final effectiveMaxPrice =
        maxPrice ?? sharedPreferences?.getString("maxPrice") ?? "";
    final effectiveMinPrice =
        minPrice ?? sharedPreferences?.getString("minPrice") ?? "";

    return {
      'per_page': '20',
      if (page != null) 'page': page.toString(),
      if (query != null && query.isNotEmpty) 'query': query,
      if (effectiveStock.isNotEmpty && effectiveStock.toLowerCase() != "all")
        'in_stock': effectiveStock,
      if (effectiveMaxPrice.isNotEmpty) 'max_price': effectiveMaxPrice,
      if (effectiveMinPrice.isNotEmpty) 'min_price': effectiveMinPrice,
    };
  }

  Future<dynamic> getHomeData({String? token}) async {
    var response = await api.getData(
      AppApi.homeDataUrl,
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> getOffersData({String? token, dynamic page}) async {
    final url = Api.buildUrl(AppApi.offersUrl, {
      'per_page': '20',
      'page': page?.toString(),
    });
    var response = await api.getData(
      url,
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> getOfferProductsData(
      {String? token, dynamic offerId, dynamic page}) async {
    final url = Api.buildUrl(AppApi.offersProductUrl, {
      'per_page': '20',
      'page': page?.toString(),
      if (offerId != null) 'offer_id': Uri.encodeComponent(offerId.toString()),
    });
    var response = await api.getData(
      url,
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> getTrendProduct({String? token, dynamic page}) async {
    final url = Api.buildUrl(AppApi.trendingProductUrl, {
      'per_page': '20',
      'page': page?.toString(),
    });
    var response = await api.getData(
      url,
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> getMostOrderdProduct({String? token, dynamic page}) async {
    final url = Api.buildUrl(AppApi.mostOrderedProductUrl, {
      'per_page': '20',
      'page': page?.toString(),
    });
    var response = await api.getData(
      url,
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> searchHome({
    String? token,
    String? query,
    dynamic page,
    String? inStock,
    String? maxPrice,
    String? minPrice,
  }) async {
    final url = Api.buildUrl(
      AppApi.allProductstUrl,
      _buildFilterParams(
        page: page,
        query: query,
        inStock: inStock,
        maxPrice: maxPrice,
        minPrice: minPrice,
      ),
    );
    var response = await api.getData(
      url,
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> scanCode({dynamic itemCode}) async {
    final cleanCode = itemCode?.toString() ?? '';
    final url = Api.buildUrl(AppApi.allProductstUrl, {
      'itnl_code': cleanCode,
    });
    var response = await api.getData(
      url,
      Api.authHeaders(sharedPreferences?.getString('token')),
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> searchSpecial({
    String? token,
    String? query,
    dynamic page,
    String? inStock,
    String? maxPrice,
    String? minPrice,
  }) async {
    final url = Api.buildUrl(
      AppApi.offersProductUrl,
      _buildFilterParams(
        page: page,
        query: query,
        inStock: inStock,
        maxPrice: maxPrice,
        minPrice: minPrice,
      ),
    );
    var response = await api.getData(
      url,
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> searchMost({
    String? token,
    String? query,
    dynamic page,
    String? inStock,
    String? maxPrice,
    String? minPrice,
  }) async {
    final url = Api.buildUrl(
      AppApi.mostOrderedProductUrl,
      _buildFilterParams(
        page: page,
        query: query,
        inStock: inStock,
        maxPrice: maxPrice,
        minPrice: minPrice,
      ),
    );
    var response = await api.getData(
      url,
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> searchFeatures({
    String? token,
    String? query,
    dynamic page,
    String? inStock,
    String? maxPrice,
    String? minPrice,
  }) async {
    final url = Api.buildUrl(
      AppApi.trendingProductUrl,
      _buildFilterParams(
        page: page,
        query: query,
        inStock: inStock,
        maxPrice: maxPrice,
        minPrice: minPrice,
      ),
    );
    var response = await api.getData(
      url,
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }
}
