import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_api.dart';
import 'package:tharwat_pharmacy/main.dart';

class OrderRemoteData {
  Api api;
  OrderRemoteData(this.api);

  Future<dynamic> createOrder({
    String? token,
    int? cityId,
    int? countryId,
    int? districtId,
    String? address,
    String? phone,
    String? payment,
    String? additionalInfo,
    String? street,
    double? total,
    String? buildingNum,
  }) async {
    var response = await api.postData(
      AppApi.createOrderUrl,
      Api.authHeaders(token),
      {
        "address": address,
        "city_id": cityId,
        "country_id": countryId,
        "district_id": districtId,
        "phone": phone,
        "payment_method": payment,
        "building_num": buildingNum,
        "street": street,
        "additional_info": additionalInfo,
        "total": total
      },
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> checkPaymentStatus(
      {String? token, required dynamic orderId}) async {
    var response = await api.getData(
      "${AppApi.checkPaymentUrl}/${Uri.encodeComponent(orderId.toString())}",
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> getActiveOrder({String? token, int? page}) async {
    var response = await api.getData(
      Api.buildUrl(AppApi.getActivedOrderUrl, {
        if (page != null) "page": page.toString(),
        "per_page": "10",
      }),
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> getPendingOrder({String? token, int? page}) async {
    var response = await api.getData(
      Api.buildUrl(AppApi.getPendingOrderUrl, {
        if (page != null) "page": page.toString(),
        "per_page": "10",
      }),
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> getCompleteOrder({String? token, int? page}) async {
    var response = await api.getData(
      Api.buildUrl(AppApi.getCompleteOrderUrl, {
        if (page != null) "page": page.toString(),
        "per_page": "10",
      }),
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> getCanceledOrder({String? token, int? page}) async {
    var response = await api.getData(
      Api.buildUrl(AppApi.getCanceledOrderUrl, {
        if (page != null) "page": page.toString(),
        "per_page": "10",
      }),
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> cancelOrder({String? token, required dynamic id}) async {
    var response = await api.updatePatchData(
      "${AppApi.cancelOrderUrl}/${Uri.encodeComponent(id.toString())}",
      Api.authHeaders(token),
      {
        "status": "cancelled",
      },
    );
    return response.fold((l) => l, (r) => r);
  }

  //deliveryData

  Future<dynamic> acceptOrder({required dynamic id}) async {
    var response = await api.getData(
      "${AppApi.acceptOrderDeliveryUrl}/${Uri.encodeComponent(id.toString())}",
      Api.authHeaders(sharedPreferences?.getString("tokenDelivery")),
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> updateOrder({required dynamic id}) async {
    var response = await api.updatePatchData(
      "${AppApi.updateOrderDeliveryUrl}/${Uri.encodeComponent(id.toString())}",
      Api.authHeaders(sharedPreferences?.getString("tokenDelivery")),
      {
        "status": 2,
      },
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> getMyOrderDelivery({int? page}) async {
    var response = await api.getData(
      Api.buildUrl(AppApi.getMyOrderDeliveryUrl, {
        if (page != null) "page": page.toString(),
        "per_page": "10",
      }),
      Api.authHeaders(sharedPreferences?.getString("tokenDelivery")),
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> getPendingDeliveryOrders({int? page}) async {
    var response = await api.getData(
      Api.buildUrl(AppApi.getPendingOrderDeliveryUrl, {
        if (page != null) "page": page.toString(),
        "per_page": "10",
      }),
      Api.authHeaders(sharedPreferences?.getString("tokenDelivery")),
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> getCompletedDeliveryOrders({int? page}) async {
    var response = await api.getData(
      Api.buildUrl(AppApi.getCompleteOrderDeliveryUrl, {
        if (page != null) "page": page.toString(),
        "per_page": "10",
      }),
      Api.authHeaders(sharedPreferences?.getString("tokenDelivery")),
    );
    return response.fold((l) => l, (r) => r);
  }
}
