class AppApi {
  static const String baseUrl = "https://pharmacy.atonads.me/api/v1";
  static const String imgUrl = "https://pharmacy.atonads.me/public/storage";

  //auth
  static const String loginUrl = "$baseUrl/auth/login";
  static const String registerUrl = "$baseUrl/auth/register";
  static const String sendOTPUrl = "$baseUrl/auth/send-otp";
  static const String resetPassUrl = "$baseUrl/auth/reset-password";
  static const String verifyCodeUrl = "$baseUrl/auth/check-otp";
  static const String profileInfoUrl = "$baseUrl/auth/get-profile";
  static const String updateProfileInfoUrl = "$baseUrl/auth/update-profile";
  static const String logoutUrl = "$baseUrl/auth/logout";
  static const String deleteAccUrl = "$baseUrl/auth/delete-account";
  static const String changeOldPassUrl = "$baseUrl/auth/update-password";

  //data location

  static const String getCountryUrl = "$baseUrl/countries";
  static const String getCityUrl = "$baseUrl/cities";
  static const String getDistrictUrl = "$baseUrl/districts";

  //categories
  static const String categoriestUrl = "$baseUrl/categories";
  static const String subCategoriestUrl = "$baseUrl/get-sub-category";
//fav
  static const String favProductsUrl = "$baseUrl/get-fav-product";
  static const String addToFavProductsUrl = "$baseUrl/product-to-fav";

  //products

  static const String allProductstUrl = "$baseUrl/products";

  //home

  static const String homeDataUrl = "$baseUrl/get-main-page";
  static const String offersUrl = "$baseUrl/offers";
  static const String offersProductUrl = "$baseUrl/products-with-offer";
  static const String trendingProductUrl = "$baseUrl/products-trending";
  static const String mostOrderedProductUrl = "$baseUrl/products-most-ordered";

  //cart

  static const String cartUrl = "$baseUrl/get-user-cart";
  static const String addToCartUrl = "$baseUrl/add-to-cart";

  static const String updateCartUrl = "$baseUrl/update-cart";
  static const String deleteFromCartUrl = "$baseUrl/remove-item-cart";

  //order
  static const String createOrderUrl = "$baseUrl/orders";
  static const String getCompleteOrderUrl = "$baseUrl/get-user-orders?type=2";
  static const String getCanceledOrderUrl = "$baseUrl/get-user-orders?type=3";
  static const String getActivedOrderUrl = "$baseUrl/get-user-orders?type=1";
  static const String getPendingOrderUrl = "$baseUrl/get-user-orders?type=4";
  static const String cancelOrderUrl = "$baseUrl/cancel-order";

//orders delivery
  static const String getCompleteOrderDeliveryUrl =
      "$baseUrl/get-delivery-orders";
  static const String acceptOrderDeliveryUrl = "$baseUrl/accept-order";
  static const String getMyOrderDeliveryUrl = "$baseUrl/get-delivery-orders";
  static const String getPendingOrderDeliveryUrl =
      "$baseUrl/get-orders-for-delivery";
  static const String updateOrderDeliveryUrl = "$baseUrl/orders";
//payment
  static const String checkPaymentUrl = "$baseUrl/check-payment-status";
//contact us
  static const String contactUsUrl = "$baseUrl/contact-us";

  //products has edited in model dont forget for product info
}
