import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_api.dart';
import 'package:tharwat_pharmacy/main.dart';

class CartRemoteData {
  Api api;
  CartRemoteData(this.api);

  getCartItem({token}) async {
    var response = await api.getData(AppApi.cartUrl, {
      "Accept": "application/json",
      'authorization': 'Bearer $token',
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    });
    return response.fold((l) => l, (r) => r);
  }

  addToCart({token, qti, id}) async {
    var response = await api.postData(AppApi.addToCartUrl, {
      "Accept": "application/json",
      'authorization': 'Bearer $token',
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    }, {
      "product_id": id,
      "quantity": qti
    });
    return response.fold((l) => l, (r) => r);
  }

  removeFromCart({token, id}) async {
    var response = await api.deleteData("${AppApi.deleteFromCartUrl}/$id", {
      "Accept": "application/json",
      'authorization': 'Bearer $token',
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    });
    return response.fold((l) => l, (r) => r);
  }

  increaseCart({token, id, qtv}) async {
    var response = await api.updatePatchData("${AppApi.updateCartUrl}/$id", {
      "Accept": "application/json",
      'authorization': 'Bearer $token',
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    }, {
      "quantity": qtv
    });
    return response.fold((l) => l, (r) => r);
  }

  decreaseCart({token, id, qtv}) async {
    var response = await api.updatePatchData("${AppApi.updateCartUrl}/$id", {
      "Accept": "application/json",
      'authorization': 'Bearer $token',
      "Lang": sharedPreferences!.getString("local") == "en" ? "en" : "ar",
      'Content-Type': 'application/json; charset=UTF-8'
    }, {
      "quantity": qtv
    });
    return response.fold((l) => l, (r) => r);
  }
}
