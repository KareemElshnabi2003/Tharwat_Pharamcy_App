import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tharwat_pharmacy/Controller/Home/Favourite/favourite_controller.dart';
import 'package:tharwat_pharmacy/Controller/Home/filter_controller.dart';
import 'package:tharwat_pharmacy/Controller/Home/home_page_controller.dart';
import 'package:tharwat_pharmacy/Controller/Home/special_offers_controller.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Home/favourite_source.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Home/home_source.dart';
import 'package:tharwat_pharmacy/Data/Model/Categories/product_model.dart';
import 'package:tharwat_pharmacy/Data/Model/Order/order_model.dart';
import 'package:tharwat_pharmacy/main.dart';

class MockFavouriteRemoteData extends FavouriteRemoteData {
  MockFavouriteRemoteData() : super(Api());
  int addCalls = 0;
  int removeCalls = 0;
  bool shouldFail = false;
  Completer<dynamic>? addCompleter;

  @override
  Future<dynamic> addToFav({String? token, required dynamic id}) async {
    addCalls++;
    if (addCompleter != null) {
      await addCompleter!.future;
    }
    if (shouldFail) {
      return StatuesRequest.serverError;
    }
    return <String, dynamic>{'status': 'success'};
  }

  @override
  Future<dynamic> removeFromFav({String? token, required dynamic id}) async {
    removeCalls++;
    if (shouldFail) {
      return StatuesRequest.serverError;
    }
    return <String, dynamic>{'status': 'success'};
  }
}

class FakeHomeRemoteData extends HomeRemoteData {
  FakeHomeRemoteData() : super(Api());
  Completer<dynamic>? firstSearchCompleter;
  Completer<dynamic>? secondSearchCompleter;

  @override
  Future<dynamic> searchHome({
    String? token,
    String? query,
    dynamic page,
    String? inStock,
    String? minPrice,
    String? maxPrice,
  }) async {
    if (query == 'first') {
      return await firstSearchCompleter!.future;
    } else if (query == 'second') {
      return await secondSearchCompleter!.future;
    }
    return {
      'data': [
        {'id': 100, 'itm_name_en': 'Fallback'}
      ]
    };
  }
}

class FakeSpecialOffersRemoteData extends HomeRemoteData {
  FakeSpecialOffersRemoteData() : super(Api());
  bool shouldFailMore = false;

  @override
  Future<dynamic> getOfferProductsData(
      {String? token, dynamic offerId, dynamic page}) async {
    if (shouldFailMore && page != null && page > 1) {
      return StatuesRequest.serverError;
    }
    return {
      'data': [
        {'id': page ?? 1, 'itm_name_en': 'Product $page'}
      ]
    };
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    Get.reset();
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({'local': 'ar'});
    sharedPreferences = await SharedPreferences.getInstance();
    Get.put<Api>(Api(), permanent: true);
  });

  tearDown(() {
    Get.reset();
  });

  group('Api & Networking Tests', () {
    test('Api defaultHeaders and authHeaders return expected headers', () {
      final defaultH = Api.defaultHeaders();
      expect(defaultH['Accept'], 'application/json');
      expect(defaultH['Lang'], 'ar');
      expect(defaultH.containsKey('Authorization'), isFalse);

      final authH = Api.authHeaders('sample_token_xyz');
      expect(authH['Authorization'], 'Bearer sample_token_xyz');
      expect(authH['Accept'], 'application/json');
      expect(authH['Lang'], 'ar');
    });

    test('Api handleResponse handles 204 No Content and empty 2xx responses',
        () {
      final api = Api();
      final res204 = http.Response('', 204);
      final result204 = api.handleResponse(res204);
      expect(result204.isRight(), isTrue);
      result204.fold(
        (l) => fail('Should be right'),
        (r) => expect(r, equals(<String, dynamic>{})),
      );

      final res200Empty = http.Response('', 200);
      final result200Empty = api.handleResponse(res200Empty);
      expect(result200Empty.isRight(), isTrue);
      result200Empty.fold(
        (l) => fail('Should be right'),
        (r) => expect(r, equals(<String, dynamic>{})),
      );
    });

    test('Api.buildUrl encodes query parameters properly', () {
      final url = Api.buildUrl('https://example.com/api/search', {
        'query': 'بانادول اكسترا',
        'in_stock': '1',
      });
      expect(
          url,
          contains(
              'query=%D8%A8%D8%A7%D9%86%D8%A7%D8%AF%D9%88%D9%84+%D8%A7%D9%83%D8%B3%D8%AA%D8%B1%D8%A7'));
      expect(url, contains('in_stock=1'));
    });
  });

  group('OrderModel Serialization Tests', () {
    test('OrderModel.toJson correctly includes payment_url', () {
      final order = OrderModel.fromJson({
        'id': 123,
        'payment_url': 'https://accept.paymob.com/api/acceptance/iframes/12345',
      });

      final json = order.toJson();
      expect(json['payment_url'],
          'https://accept.paymob.com/api/acceptance/iframes/12345');
      expect(json.containsKey('dapayment_urlte'), isFalse);
    });
  });

  group('FilterController Stock Mapping Tests', () {
    test('FilterController maps In-stack, Out-of-stack, and All correctly', () {
      final controller = FilterController();

      controller.available = "In-stack";
      expect(controller.stockParam, "1");

      controller.available = "Out-of-stack";
      expect(controller.stockParam, "0");

      controller.available = "";
      expect(controller.stockParam, "");

      controller.saveData();
      expect(sharedPreferences?.getString('stock'), "");

      controller.available = "In-stack";
      controller.saveData();
      expect(sharedPreferences?.getString('stock'), "1");
    });
  });

  group('FavouriteController Tests', () {
    test('Favorite rollback restores both ID and ProductModel upon API failure',
        () async {
      final mockData = MockFavouriteRemoteData();
      mockData.shouldFail = true;

      final controller = FavouriteController();
      controller.favouriteRemoteData = mockData;

      final testProduct = ProductModel(id: 42, itmNameEn: "Panadol");
      controller.favItems.add(testProduct);
      controller.favProductsId.add(42);

      // Perform removal which fails on the backend
      await controller.notFavProducts(42);

      // Verify rollback restored both the ID and the model into favItems
      expect(controller.favProductsId.contains(42), isTrue);
      expect(controller.favItems.length, 1);
      expect(controller.favItems.first.id, 42);
    });

    test(
        'Favorite duplicate tap prevention ensures only single request in-flight',
        () async {
      final mockData = MockFavouriteRemoteData();
      mockData.addCompleter = Completer<dynamic>();

      final controller = FavouriteController();
      controller.favouriteRemoteData = mockData;

      // First tap starts request
      final f1 = controller.favProducts(99);
      // Concurrent taps for same product
      final f2 = controller.favProducts(99);
      final f3 = controller.favProducts(99);

      expect(mockData.addCalls, 1);

      // Finish first request
      mockData.addCompleter!.complete();
      await f1;
      await f2;
      await f3;

      expect(mockData.addCalls, 1);
    });
  });

  group('Race Condition Search & Pagination Tests', () {
    test('HomePageController searchRequestId discards stale responses',
        () async {
      final fakeRemote = FakeHomeRemoteData();
      fakeRemote.firstSearchCompleter = Completer<dynamic>();
      fakeRemote.secondSearchCompleter = Completer<dynamic>();

      final controller = HomePageController();
      controller.homeRemoteData = fakeRemote;

      // Start search 'first' (Request ID 1)
      final f1 = controller.search(query: 'first');

      // Start search 'second' (Request ID 2)
      final f2 = controller.search(query: 'second');

      // Resolve 'second' first
      fakeRemote.secondSearchCompleter!.complete({
        'data': [
          {'id': 2, 'itm_name_en': 'Second Product'}
        ]
      });
      await f2;

      expect(controller.searchList.length, 1);
      expect(controller.searchList.first.itmNameEn, 'Second Product');

      // Resolve 'first' later (stale response)
      fakeRemote.firstSearchCompleter!.complete({
        'data': [
          {'id': 1, 'itm_name_en': 'First Product'}
        ]
      });
      await f1;

      // Must NOT be overwritten by the old request
      expect(controller.searchList.length, 1);
      expect(controller.searchList.first.itmNameEn, 'Second Product');
    });

    test(
        'SpecialOffersController pagination retry safety preserves index on failure',
        () async {
      final fakeRemote = FakeSpecialOffersRemoteData();
      final controller = SpecialOffersController();
      controller.homeRemoteData = fakeRemote;

      controller.index = 1;
      controller.more = true;

      fakeRemote.shouldFailMore = true;
      await controller.getMoreProducts();

      // Page index should not advance on failure!
      expect(controller.index, 1);
      expect(controller.isLoadingMore, isFalse);
    });
  });
}
