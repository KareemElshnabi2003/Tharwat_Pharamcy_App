import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_api.dart';

class CartRemoteData {
  Api api;
  CartRemoteData(this.api);

  Future<dynamic> getCartItem({String? token}) async {
    var response = await api.getData(
      AppApi.cartUrl,
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> addToCart({
    String? token,
    required dynamic qti,
    required dynamic id,
  }) async {
    var response = await api.postData(
      AppApi.addToCartUrl,
      Api.authHeaders(token),
      {
        "product_id": id,
        "quantity": qti,
      },
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> removeFromCart({
    String? token,
    required dynamic id,
  }) async {
    var response = await api.deleteData(
      "${AppApi.deleteFromCartUrl}/${Uri.encodeComponent(id.toString())}",
      Api.authHeaders(token),
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> increaseCart({
    String? token,
    required dynamic id,
    required int qtv,
  }) async {
    var response = await api.updatePatchData(
      "${AppApi.updateCartUrl}/${Uri.encodeComponent(id.toString())}",
      Api.authHeaders(token),
      {
        "quantity": qtv,
      },
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> decreaseCart({
    String? token,
    required dynamic id,
    required int qtv,
  }) async {
    var response = await api.updatePatchData(
      "${AppApi.updateCartUrl}/${Uri.encodeComponent(id.toString())}",
      Api.authHeaders(token),
      {
        "quantity": qtv,
      },
    );
    return response.fold((l) => l, (r) => r);
  }
}
