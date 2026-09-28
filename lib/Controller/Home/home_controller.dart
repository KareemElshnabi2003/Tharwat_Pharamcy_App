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

  void _syncChoose(int index) {
    choose_1 = index == 0;
    choose_2 = index == 1;
    choose_3 = index == 2;
    choose_4 = index == 3;
  }

  void change_1() {
    currentIndex = 0;
    _syncChoose(0);
    update();
  }

  void change_2() {
    currentIndex = 1;
    _syncChoose(1);
    update();
  }

  void change_3() {
    currentIndex = 2;
    _syncChoose(2);
    update();
  }

  void change_4() {
    currentIndex = 3;
    _syncChoose(3);
    update();
  }

  final List<Widget> pages = [
    const HomePage(),
    const Favourite(),
    const MedicineScannerScreen(),
    const Profile(),
  ];

  void changePage(int pageIndex) {
    currentIndex = pageIndex;
    _syncChoose(pageIndex);
    update();
  }

  void goToHomeWithIndex(int index) {
    currentIndex = index;
    _syncChoose(index);
    Get.offAll(() => const Home());
    update();
  }

  void goToHome(int index, [Object? arguments]) {
    currentIndex = index;
    _syncChoose(index);
    Get.offAll(() => const Home(), arguments: arguments);
    update();
  }

  @override
  void onInit() {
    super.onInit();
    _syncChoose(currentIndex);
  }
}
