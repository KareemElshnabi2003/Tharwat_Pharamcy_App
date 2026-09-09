import 'package:tharwat_pharmacy/Data/Model/Categories/product_model.dart';

class HomeModel {
  String? status;
  int? code;
  String? message;
  Data? data;

  HomeModel({this.status, this.code, this.message, this.data});

  HomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Offers>? offers;
  List<Categories>? categories;
  TrendingProducts? trendingProducts;
  TrendingProducts? mostOrderedProducts;

  Data(
      {this.offers,
      this.categories,
      this.trendingProducts,
      this.mostOrderedProducts});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['offers'] != null) {
      offers = <Offers>[];
      json['offers'].forEach((v) {
        offers!.add(Offers.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
    trendingProducts = json['trending_products'] != null
        ? TrendingProducts.fromJson(json['trending_products'])
        : null;
    mostOrderedProducts = json['most_ordered_products'] != null
        ? TrendingProducts.fromJson(json['most_ordered_products'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (offers != null) {
      data['offers'] = offers!.map((v) => v.toJson()).toList();
    }
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (trendingProducts != null) {
      data['trending_products'] = trendingProducts!.toJson();
    }
    if (mostOrderedProducts != null) {
      data['most_ordered_products'] = mostOrderedProducts!.toJson();
    }
    return data;
  }
}

class Offers {
  int? id;
  String? name;
  String? value;
  String? type;
  String? startDate;
  String? endDate;
  String? description;
  String? image;

  Offers(
      {this.id,
      this.name,
      this.value,
      this.type,
      this.startDate,
      this.endDate,
      this.description,
      this.image});

  Offers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    type = json['type'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    description = json['description'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['value'] = value;
    data['type'] = type;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['description'] = description;
    data['image'] = image;
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  String? icon;

  Categories({this.id, this.name, this.icon});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['icon'] = icon;
    return data;
  }
}

class TrendingProducts {
  List<ProductModel>? data;

  TrendingProducts({this.data});

  TrendingProducts.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ProductModel>[];
      json['data'].forEach((v) {
        data!.add(ProductModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MostOrderedProducts {
  List<ProductModel>? data;

  MostOrderedProducts({this.data});

  MostOrderedProducts.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ProductModel>[];
      json['data'].forEach((v) {
        data!.add(ProductModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
