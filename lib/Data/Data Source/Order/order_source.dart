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
    var response = await api.postData(
      AppApi.createOrderUrl,
      {
        "Authorization": "Bearer $token",
      },
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

  checkPaymentStatus({token, orderId}) async {
    var response = await api.getData("${AppApi.checkPaymentUrl}/$orderId", {
      "Authorization": "Bearer $token",
    });
    return response.fold((l) => l, (r) => r);
  }

  getActiveOrder({token, page}) async {
    var response = await api
        .getData("${AppApi.getActivedOrderUrl}?page=$page&per_page=10", {
      "Authorization": "Bearer $token",
    });
    return response.fold((l) => l, (r) => r);
  }

  getPendingOrder({token, page}) async {
    var response = await api
        .getData("${AppApi.getPendingOrderUrl}?page=$page&per_page=10", {
      "Authorization": "Bearer $token",
    });
    return response.fold((l) => l, (r) => r);
  }

  getCompleteOrder({token, page}) async {
    var response = await api
        .getData("${AppApi.getCompleteOrderUrl}?page=$page&per_page=10", {
      "Authorization": "Bearer $token",
    });
    return response.fold((l) => l, (r) => r);
  }

  getCanceledOrder({token, page}) async {
    var response = await api
        .getData("${AppApi.getCanceledOrderUrl}?page=$page&per_page=10", {
      "Authorization": "Bearer $token",
    });
    return response.fold((l) => l, (r) => r);
  }

  cancelOrder({token, id}) async {
    var response = await api.updatePatchData(
      "${AppApi.cancelOrderUrl}/$id",
      {
        "Authorization": "Bearer $token",
      },
      {
        "status": "cancelled",
      },
    );
    return response.fold((l) => l, (r) => r);
  }

  //deliveryData

  acceptOrder({required id}) async {
    var response = await api.getData("${AppApi.acceptOrderDeliveryUrl}/$id", {
      "Authorization":
          "Bearer ${sharedPreferences!.getString("tokenDelivery")}",
    });
    return response.fold((l) => l, (r) => r);
  }

  updateOrder({required id}) async {
    var response =
        await api.updatePatchData("${AppApi.updateOrderDeliveryUrl}/$id", {
      "Authorization":
          "Bearer ${sharedPreferences!.getString("tokenDelivery")}",
    }, {
      "status": 2
    });
    return response.fold((l) => l, (r) => r);
  }

  getMyOrderDelivery({page}) async {
    var response = await api
        .getData("${AppApi.getMyOrderDeliveryUrl}?page=$page&per_page=10", {
      "Authorization":
          "Bearer ${sharedPreferences!.getString("tokenDelivery")}",
    });
    return response.fold((l) => l, (r) => r);
  }

  getPendingDeliveryOrders({page}) async {
    var response = await api.getData(
        "${AppApi.getPendingOrderDeliveryUrl}?page=$page&per_page=10", {
      "Authorization":
          "Bearer ${sharedPreferences!.getString("tokenDelivery")}",
    });
    return response.fold((l) => l, (r) => r);
  }

  getCompletedDeliveryOrders({page}) async {
    var response = await api.getData(
        "${AppApi.getCompleteOrderDeliveryUrl}?page=$page&per_page=10", {
      "Authorization":
          "Bearer ${sharedPreferences!.getString("tokenDelivery")}",
    });
    return response.fold((l) => l, (r) => r);
  }
}
