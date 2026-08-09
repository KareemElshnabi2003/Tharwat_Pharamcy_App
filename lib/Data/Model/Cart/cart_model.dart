import 'package:tharwat_pharmacy/Data/Model/Categories/product_model.dart';

class CartModel {
  int? id;
  double? cost;
  double? totalCost;
  double? deliveryCost;
  User? user;
  List<CartItems>? cartItems;

  CartModel(
      {this.id,
      this.cost,
      this.totalCost,
      this.deliveryCost,
      this.user,
      this.cartItems});

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cost = double.tryParse(json['subtotal']);
    totalCost = double.tryParse(json['total']);
    deliveryCost = double.tryParse(json['delivery_cost']);
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['cart_items'] != null) {
      cartItems = <CartItems>[];
      json['cart_items'].forEach((v) {
        cartItems!.add(CartItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['subtotal'] = cost;
    data['total'] = totalCost;
    data['delivery_cost'] = deliveryCost;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (cartItems != null) {
      data['cart_items'] = cartItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? image;
  String? gender;
  String? longitude;
  String? latitude;
  String? status;
  String? roleId;

  User(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.image,
      this.gender,
      this.longitude,
      this.latitude,
      this.status,
      this.roleId});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    gender = json['gender'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    status = json['status'];
    roleId = json['role_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['image'] = image;
    data['gender'] = gender;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['status'] = status;
    data['role_id'] = roleId;
    return data;
  }
}

class CartItems {
  int? id;
  int? quantity;
  ProductModel? product;

  CartItems({this.id, this.quantity, this.product});

  CartItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    product =
        json['product'] != null ? ProductModel.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quantity'] = quantity;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}
