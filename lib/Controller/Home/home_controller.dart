import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tharwat_pharmacy/View/Screeens/Home/favourite.dart';
import 'package:tharwat_pharmacy/View/Screeens/Home/home.dart';
import 'package:tharwat_pharmacy/View/Screeens/Home/home_page.dart';
import 'package:tharwat_pharmacy/View/Screeens/Home/profile.dart';
import 'package:tharwat_pharmacy/View/Screeens/Home/scan.dart';

class HomeController extends GetxController {
  int currentIndex = 0;

  bool choose_1 = false;
  bool choose_2 = false;
  bool choose_3 = false;
  bool choose_4 = false;

  change_1() {
    choose_1 = true;
    choose_2 = false;
    choose_3 = false;
    choose_4 = false;
    update();
  }

  change_2() {
    choose_2 = true;
    choose_1 = false;
    choose_3 = false;
    choose_4 = false;
    update();
  }

  change_3() {
    choose_3 = true;
    choose_2 = false;
    choose_1 = false;
    choose_4 = false;
    update();
  }

  change_4() {
    choose_4 = true;
    choose_2 = false;
    choose_3 = false;
    choose_1 = false;
    update();
  }

  // 🔥 التعديل هنا: إزالة الشاشات الفرعية والاكتفاء بـ 4 شاشات للبار السفلي فقط
  final List<Widget> pages = [
    const HomePage(),
    const Favourite(),
    const MedicineScannerScreen(),
    const Profile(),
  ];

  changePage(int pageIndex) {
    currentIndex = pageIndex;
    update();
  }

  goToHomeWithIndex(index) {
    currentIndex = index;
    Get.offAll(() => const Home());

    choose_1 = currentIndex == 0;
    choose_2 = currentIndex == 1;
    choose_3 = currentIndex == 2;
    choose_4 = currentIndex == 3;
    update();
  }

  goToHome(index, arguments) {
    currentIndex = index;
    choose_1 = currentIndex == 0;
    choose_2 = currentIndex == 1;
    choose_3 = currentIndex == 2;
    choose_4 = currentIndex == 3;
    Get.offAll(() => const Home());
    update();
  }

  @override
  void onInit() {
    choose_1 = currentIndex == 0;
    super.onInit();
  }
}
