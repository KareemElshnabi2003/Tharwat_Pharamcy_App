import 'package:get/get.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Core/function/handling_data.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Cart/cart_source.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Home/favourite_source.dart';
import 'package:tharwat_pharmacy/Data/Model/Cart/cart_model.dart';
import 'package:tharwat_pharmacy/Data/Model/Categories/product_model.dart';
import 'package:tharwat_pharmacy/View/Screeens/Home%20Page/my_cart_page.dart';
import 'package:tharwat_pharmacy/main.dart';

class ProductInfoController extends GetxController {
  StatuesRequest statuesRequest = StatuesRequest.none;
  CartRemoteData cartRemoteData = CartRemoteData(Get.put(Api()));
  CartModel? cartModel;
  String? productId;
  ProductModel? productModel;

  bool readMore_1 = false;
  bool readMore_2 = false;
  bool readMore_3 = false;
  bool readMore_4 = false;
  bool readMore_5 = false;
  int count = 0;

  FavouriteRemoteData favouriteRemoteData = FavouriteRemoteData(Get.put(Api()));
  List<ProductModel> favItems = [];
  List favProductsId = [];

  increseCount() {
    count++;
    update();
  }
  decreseCount() {
    if (count > 0) count--;
    update();
  }

  addItemToFav(itemId) async {
    var response = await favouriteRemoteData.addToFav(
        id: itemId, token: sharedPreferences!.getString("token"));
    statuesRequest = handlingData(response);

    handleApiResponse(
      status: statuesRequest,
      response: response,
      onSuccess: (data) {},
    );

    // إذا فشل الإرسال نعكس الحالة محلياً
    if (statuesRequest != StatuesRequest.success) {
      favProductsId.remove(itemId);
    }
    update();
  }

  favProducts(id) {
    favProductsId.add(id);
    addItemToFav(id);
    update();
  }

  notFavProducts(id) {
    favProductsId.remove(id);
    removeItemFromFav(id);
    update();
  }

  removeItemFromFav(itemId) async {
    var response = await favouriteRemoteData.removeFromFav(
        id: itemId, token: sharedPreferences!.getString("token"));
    statuesRequest = handlingData(response);

    handleApiResponse(
      status: statuesRequest,
      response: response,
      onSuccess: (data) {
        favItems.removeWhere((item) => item.id.toString() == itemId);
      },
    );

    if (statuesRequest != StatuesRequest.success) {
      favProductsId.add(itemId);
    }
    update();
  }

  addToCart() async {
    statuesRequest = StatuesRequest.loading;
    update();
    var response = await cartRemoteData.addToCart(
        token: sharedPreferences!.getString("token"), id: productId, qti: "1");
    statuesRequest = handlingData(response);

    handleApiResponse(
      status: statuesRequest,
      response: response,
      onSuccess: (data) {
        Get.to(() => const MyCartPage());
      },
    );
    update();
  }

  change_1() { readMore_1 = !readMore_1; update(); }
  change_2() { readMore_2 = !readMore_2; update(); }
  change_3() { readMore_3 = !readMore_3; update(); }
  change_4() { readMore_4 = !readMore_4; update(); }
  change_5() { readMore_5 = !readMore_5; update(); }

  @override
  void onInit() {
    productId = Get.arguments['id'];
    productModel = Get.arguments['product'];
    if (productModel!.isFavourite == true) {
      favProductsId.add(productModel!.id);
    }
    super.onInit();
  }
}