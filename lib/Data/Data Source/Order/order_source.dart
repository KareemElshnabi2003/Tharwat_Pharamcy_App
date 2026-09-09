import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_api.dart';
import 'package:tharwat_pharmacy/main.dart';

class OrderRemoteData {
  Api api;
  OrderRemoteData(this.api);

  createOrder(
      {token,
      int? cityId,
      int? countryId,
      int? districtId,
      address,
      phone,
      payment,
      additionalInfo,
      street,
      total,
      buildingNum}) async {
    var response = await api.postData(AppApi.createOrderUrl, {
      "Accept": "application/json",
      'authorization': 'Bearer $token',
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    }, {
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
    });
    return response.fold((l) => l, (r) => r);
  }

  checkPaymentStatus({token, orderId}) async {
    var response = await api.getData("${AppApi.checkPaymentUrl}/$orderId", {
      "Accept": "application/json",
      'authorization': 'Bearer $token',
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    });
    return response.fold((l) => l, (r) => r);
  }

  getActiveOrder({token, page}) async {
    var response = await api
        .getData("${AppApi.getActivedOrderUrl}?page=$page&per_page=10", {
      "Accept": "application/json",
      'authorization': 'Bearer $token',
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    });
    return response.fold((l) => l, (r) => r);
  }

  getPendingOrder({token, page}) async {
    var response = await api
        .getData("${AppApi.getPendingOrderUrl}?page=$page&per_page=10", {
      "Accept": "application/json",
      'authorization': 'Bearer $token',
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    });
    return response.fold((l) => l, (r) => r);
  }

  getCompleteOrder({token, page}) async {
    var response = await api
        .getData("${AppApi.getCompleteOrderUrl}?page=$page&per_page=10", {
      "Accept": "application/json",
      'authorization': 'Bearer $token',
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    });
    return response.fold((l) => l, (r) => r);
  }

  getCanceledOrder({token, page}) async {
    var response = await api
        .getData("${AppApi.getCanceledOrderUrl}?page=$page&per_page=10", {
      "Accept": "application/json",
      'authorization': 'Bearer $token',
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    });
    return response.fold((l) => l, (r) => r);
  }

  cancelOrder({token, id}) async {
    var response = await api.updatePatchData("${AppApi.cancelOrderUrl}/$id", {
      "Accept": "application/json",
      'authorization': 'Bearer $token',
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    }, {
      "status": "cancelled"
    });
    return response.fold((l) => l, (r) => r);
  }

  //deliveryDAta

  acceptOrder({required id}) async {
    var response = await api.getData("${AppApi.acceptOrderDeliveryUrl}/$id", {
      "Accept": "application/json",
      'authorization':
          'Bearer ${sharedPreferences!.getString("tokenDelivery")}',
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    });
    return response.fold((l) => l, (r) => r);
  }

  updateOrder({required id}) async {
    var response =
        await api.updatePatchData("${AppApi.updateOrderDeliveryUrl}/$id", {
      "Accept": "application/json",
      'authorization':
          'Bearer ${sharedPreferences!.getString("tokenDelivery")}',
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    }, {
      "status": 2
    });
    return response.fold((l) => l, (r) => r);
  }

  getMyOrderDelivery({page}) async {
    var response = await api
        .getData("${AppApi.getMyOrderDeliveryUrl}?page=$page&per_page=10", {
      "Accept": "application/json",
      'authorization':
          'Bearer ${sharedPreferences!.getString("tokenDelivery")}',
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    });
    return response.fold((l) => l, (r) => r);
  }

  getPendingDeliveryOrders({page}) async {
    var response = await api.getData(
        "${AppApi.getPendingOrderDeliveryUrl}?page=$page&per_page=10", {
      "Accept": "application/json",
      'authorization':
          'Bearer ${sharedPreferences!.getString("tokenDelivery")}',
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    });
    return response.fold((l) => l, (r) => r);
  }

  getCompletedDeliveryOrders({page}) async {
    var response = await api.getData(
        "${AppApi.getCompleteOrderDeliveryUrl}?page=$page&per_page=10", {
      "Accept": "application/json",
      'authorization':
          'Bearer ${sharedPreferences!.getString("tokenDelivery")}',
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    });
    return response.fold((l) => l, (r) => r);
  }
}
