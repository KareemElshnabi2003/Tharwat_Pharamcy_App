import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_api.dart';

class CartRemoteData {
  Api api;
  CartRemoteData(this.api);

  getCartItem({token}) async {
    var response = await api.getData(AppApi.cartUrl, {
      "Authorization": "Bearer $token",
    });
    return response.fold((l) => l, (r) => r);
  }

  addToCart({token, qti, id}) async {
    var response = await api.postData(
      AppApi.addToCartUrl,
      {
        "Authorization": "Bearer $token",
      },
      {
        "product_id": id,
        "quantity": qti,
      },
    );
    return response.fold((l) => l, (r) => r);
  }

  removeFromCart({token, id}) async {
    var response = await api.deleteData("${AppApi.deleteFromCartUrl}/$id", {
      "Authorization": "Bearer $token",
    });
    return response.fold((l) => l, (r) => r);
  }

  increaseCart({token, id, qtv}) async {
    var response = await api.updatePatchData(
      "${AppApi.updateCartUrl}/$id",
      {
        "Authorization": "Bearer $token",
      },
      {
        "quantity": qtv,
      },
    );
    return response.fold((l) => l, (r) => r);
  }

  decreaseCart({token, id, qtv}) async {
    var response = await api.updatePatchData(
      "${AppApi.updateCartUrl}/$id",
      {
        "Authorization": "Bearer $token",
      },
      {
        "quantity": qtv,
      },
    );
    return response.fold((l) => l, (r) => r);
  }
}
