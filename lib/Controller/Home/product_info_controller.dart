import 'package:get/get.dart';
import 'package:tharwat_pharmacy/Controller/Home/Favourite/favourite_controller.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Core/function/handling_data.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Cart/cart_source.dart';
import 'package:tharwat_pharmacy/Data/Model/Cart/cart_model.dart';
import 'package:tharwat_pharmacy/Data/Model/Categories/product_model.dart';
import 'package:tharwat_pharmacy/View/Screeens/Home%20Page/my_cart_page.dart';
import 'package:tharwat_pharmacy/main.dart';

class ProductInfoController extends GetxController {
  StatuesRequest statuesRequest = StatuesRequest.none;
  CartRemoteData cartRemoteData = CartRemoteData(
      Get.isRegistered<Api>() ? Get.find<Api>() : Get.put(Api()));
  CartModel? cartModel;
  String? productId;
  ProductModel? productModel;

  bool readMore_1 = false;
  bool readMore_2 = false;
  bool readMore_3 = false;
  bool readMore_4 = false;
  bool readMore_5 = false;
  int count = 0;

  FavouriteController get _favController {
    if (!Get.isRegistered<FavouriteController>()) {
      return Get.put(FavouriteController());
    }
    return Get.find<FavouriteController>();
  }

  Set<int> get favProductsId => _favController.favProductsId;
  List<ProductModel> get favItems => _favController.favItems;

  bool isTogglingFav = false;
  bool isAddingToCart = false;

  void increseCount() {
    count++;
    update();
  }

  void decreseCount() {
    if (count > 0) count--;
    update();
  }

  Future<void> favProducts(dynamic id) async {
    if (isTogglingFav) return;
    isTogglingFav = true;
    try {
      await _favController.favProducts(id);
    } finally {
      isTogglingFav = false;
      update();
    }
  }

  Future<void> notFavProducts(dynamic id) async {
    if (isTogglingFav) return;
    isTogglingFav = true;
    try {
      await _favController.notFavProducts(id);
    } finally {
      isTogglingFav = false;
      update();
    }
  }

  Future<void> addToCart() async {
    if (isAddingToCart) return;
    isAddingToCart = true;
    try {
      statuesRequest = StatuesRequest.loading;
      update();
      var response = await cartRemoteData.addToCart(
          token: sharedPreferences?.getString("token"),
          id: productId,
          qti: "1");
      statuesRequest = handlingData(response);

      handleApiResponse(
        status: statuesRequest,
        response: response,
        onSuccess: (data) {
          Get.to(() => const MyCartPage());
        },
      );
    } finally {
      isAddingToCart = false;
      update();
    }
  }

  void change_1() {
    readMore_1 = !readMore_1;
    update();
  }

  void change_2() {
    readMore_2 = !readMore_2;
    update();
  }

  void change_3() {
    readMore_3 = !readMore_3;
    update();
  }

  void change_4() {
    readMore_4 = !readMore_4;
    update();
  }

  void change_5() {
    readMore_5 = !readMore_5;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      productId = args['id']?.toString();
      if (args['product'] is ProductModel) {
        productModel = args['product'] as ProductModel;
        if (productModel?.isFavourite == true && productModel?.id != null) {
          _favController.favProductsId.add(productModel!.id!);
        }
      }
    }
  }
}
