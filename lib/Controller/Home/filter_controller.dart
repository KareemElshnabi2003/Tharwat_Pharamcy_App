import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tharwat_pharmacy/main.dart';

class FilterController extends GetxController {
  RangeValues currentRangeValues = const RangeValues(20, 70);
  List ranges = [
    "\$0",
    "\$10",
    "\$20",
    "\$30",
    "\$40",
    "\$50",
    "\$60",
    "\$70",
    "\$80",
    "\$90",
    "\$100"
  ];
  String categoryName = "";
  String maxPriceRang = "";
  String minPriceRang = "";
  String review = "";
  String available = "";
  String specialOfferes = "no";

  bool chooseAllCat = true;
  bool chooseAllAvailable = true;

  setPrice(RangeValues value) {
    currentRangeValues = value;
    maxPriceRang = value.end.toString();
    minPriceRang = value.start.toString();
    update();
  }

  chooseAllCategory() {
    chooseAllCat = true;
    chooseCat.clear();
    categoryName = "";
    update();
  }

  List chooseCat = [];
  List chooseAvailabel = [];
  changeSpecialOfferes(value) {
    specialOfferes = value;
    update();
  }

  saveData() {
    sharedPreferences!.setString('maxPrice', maxPriceRang);
    sharedPreferences!.setString('minPrice', minPriceRang);
    sharedPreferences!.setString('stock', available == "In-stack" ? "1" : "0");
  }

  clearData() {
    currentRangeValues = const RangeValues(20, 70);
    review = '';
    available = '';
    categoryName = '';

    maxPriceRang = '';
    minPriceRang = '';
    chooseAllCat = true;
    chooseAllAvailable = true;
    specialOfferes = "no";
    chooseCat.clear();
    chooseAvailabel.clear();
      sharedPreferences!.setString('maxPrice', '');
    sharedPreferences!.setString('minPrice', '');
    sharedPreferences!.setString('stock', '');
    update();
  }

  changeReview(value) {
    review = value;
    update();
  }

  List cateegory = [
    {"name": "Sun Care", "id": "1"},
    {"name": "Hair Care", "id": "2"},
    {"name": "Make Up", "id": "3"},
    {"name": "Skin Care", "id": "4"},
  ];
  List availablety = [
    {"name": "In-stack", "id": "1"},
    {"name": "Out-of-stack", "id": "2"},
  ];

  addToMap(index) {
    chooseCat.clear();
    chooseCat.add(cateegory[index]['id'].toString());
    categoryName = cateegory[index]['name'];

    chooseAllCat = false;
    update();
  }

  chooseAllAvailabel() {
    chooseAllAvailable = true;
    chooseAvailabel.clear();
    available = "";
    update();
  }

  addToMapAvailabel(index) {
    chooseAllAvailable = false;
    chooseAvailabel.clear();
    chooseAvailabel.add(availablety[index]['id']);
    available = availablety[index]['name'];
    update();
  }
}
