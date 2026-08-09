import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_api.dart';
import 'package:tharwat_pharmacy/main.dart';

class HomeRemoteData {
  Api api;
  HomeRemoteData(this.api);
  getHomeData({token}) async {
    var response = await api.getData(AppApi.homeDataUrl, {
      "Accept": "application/json",
      'authorization': 'Bearer $token',
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    });
    return response.fold((l) => l, (r) => r);
  }

  getOffersData({token, page}) async {
    var response =
        await api.getData("${AppApi.offersUrl}?per_page=20&page=$page", {
      "Accept": "application/json",
      'authorization': 'Bearer $token',
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    });
    return response.fold((l) => l, (r) => r);
  }

  getOfferProductsData({token, offerId, page}) async {
    var response = await api.getData(
        "${AppApi.offersProductUrl}?per_page=20&page=$page&offer_id=$offerId", {
      "Accept": "application/json",
      'authorization': 'Bearer $token',
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    });
    return response.fold((l) => l, (r) => r);
  }

  getTrendProduct({token, page}) async {
    var response = await api
        .getData("${AppApi.trendingProductUrl}?per_page=20&page=$page", {
      "Accept": "application/json",
      'authorization': 'Bearer $token',
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    });
    return response.fold((l) => l, (r) => r);
  }

  getMostOrderdProduct({token, page}) async {
    var response = await api
        .getData("${AppApi.mostOrderedProductUrl}?per_page=20&page=$page", {
      "Accept": "application/json",
      'authorization': 'Bearer $token',
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    });
    return response.fold((l) => l, (r) => r);
  }

  searchHome(
      {token,
      maxPrice,
      minPrice,
      catId,
      availability,
      special,
      query,
      page}) async {
    var response = await api.getData(
        "${AppApi.allProductstUrl}?per_page=20&page=$page&query=$query&in_stock=${sharedPreferences!.getString("stock") ?? ""}&max_price=${sharedPreferences!.getString("maxPrice") ?? ""}&min_price=${sharedPreferences!.getString("minPrice") ?? ""}",
        {
          "Accept": "application/json",
          'authorization': 'Bearer $token',
          "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
          'Content-Type': 'application/json; charset=UTF-8'
        });
    return response.fold((l) => l, (r) => r);
  }

  scanCode({itemCode}) async {
    var response =
        await api.getData("${AppApi.allProductstUrl}?itnl_code=${int.parse(itemCode)}", {
      "Accept": "application/json",
      'authorization': 'Bearer ${sharedPreferences!.getString('token')}',
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    });
    return response.fold((l) => l, (r) => r);
  }

  searchSpecial(
      {token,
      maxPrice,
      minPrice,
      catId,
      availability,
      special,
      query,
      page}) async {
    var response = await api.getData(
        "${AppApi.offersProductUrl}?per_page=20&page=$page&query=$query&in_stock=${sharedPreferences!.getString("stock") ?? ""}&max_price=${sharedPreferences!.getString("maxPrice") ?? ""}&min_price=${sharedPreferences!.getString("minPrice") ?? ""}",
        {
          "Accept": "application/json",
          'authorization': 'Bearer $token',
          "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
          'Content-Type': 'application/json; charset=UTF-8'
        });
    return response.fold((l) => l, (r) => r);
  }

  searchMost(
      {token,
      maxPrice,
      minPrice,
      catId,
      availability,
      special,
      query,
      page}) async {
    var response = await api.getData(
        "${AppApi.mostOrderedProductUrl}?per_page=20&page=$page&query=$query&in_stock=${sharedPreferences!.getString("stock") ?? ""}&max_price=${sharedPreferences!.getString("maxPrice") ?? ""}&min_price=${sharedPreferences!.getString("minPrice") ?? ""}",
        {
          "Accept": "application/json",
          'authorization': 'Bearer $token',
          "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
          'Content-Type': 'application/json; charset=UTF-8'
        });
    return response.fold((l) => l, (r) => r);
  }

  searchFeatures(
      {token,
      maxPrice,
      minPrice,
      catId,
      availability,
      special,
      query,
      page}) async {
    var response = await api.getData(
        "${AppApi.trendingProductUrl}?per_page=20&page=$page&query=$query&in_stock=${sharedPreferences!.getString("stock") ?? ""}&max_price=${sharedPreferences!.getString("maxPrice") ?? ""}&min_price=${sharedPreferences!.getString("minPrice") ?? ""}",
        {
          "Accept": "application/json",
          'authorization': 'Bearer $token',
          "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
          'Content-Type': 'application/json; charset=UTF-8'
        });
    return response.fold((l) => l, (r) => r);
  }
}
