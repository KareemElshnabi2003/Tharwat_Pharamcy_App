import 'package:get/get.dart';
import 'package:tharwat_pharmacy/View/DeliveryView/completed_orders_delivery.dart';
import 'package:tharwat_pharmacy/View/DeliveryView/map_delivery.dart';
import 'package:tharwat_pharmacy/View/DeliveryView/my_orders_delivery.dart';
import 'package:tharwat_pharmacy/View/DeliveryView/orders_delivery.dart';

class HomeDeliveryController extends GetxController {
  int currentIndex = 0;

  bool choose_1 = false;
  bool choose_2 = false;
  bool choose_3 = false;

  change_1() {
    if (choose_1 == true) {
      choose_1 = true;
    } else {
      choose_1 = true;
      choose_2 = false;
      choose_3 = false;
    }
    update();
  }

  change_2() {
    if (choose_2 == true) {
      choose_2 = true;
    } else {
      choose_2 = true;
      choose_1 = false;
      choose_3 = false;
    }
    update();
  }

  change_3() {
    if (choose_3 == true) {
      choose_3 = true;
    } else {
      choose_3 = true;
      choose_1 = false;
      choose_2 = false;
    }
    update();
  }

  List pages = [
    const OrdersDelivery(),
    const MyOrdersDelivery(),
    const CompletedOrdersDelivery(),
  ];
  changePage(int pageIndex, {name = "", id = ""}) {
    currentIndex = pageIndex;
    update();
  }

  @override
  void onInit() {
    choose_1 = currentIndex == 0 ? true : false;
    super.onInit();
  }
}
