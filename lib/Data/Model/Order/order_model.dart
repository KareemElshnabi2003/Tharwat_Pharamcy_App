class OrderModel {
  int? id;
  String? user;
  String? status;
  String? address;
  int? cityId;
  String? additionalInfo;
  String? buildingNum;
  String? street;
  int? countryId;
  int? districtId;
  String? phone;
  String? paymentMethod;
  String? paymentStatus;
  int? totalCost;
  double? total;
  String? createdAt;
  String? deliveryCost;
  String? date;
  String? paymentUrl;
  String? paymobOrderId;
  List<ProductsDetail>? productsDetail;

  OrderModel(
      {this.id,
      this.user,
      this.status,
      this.address,
      this.cityId,
      this.additionalInfo,
      this.buildingNum,
      this.street,
      this.countryId,
      this.districtId,
      this.phone,
      this.paymentMethod,
      this.paymentStatus,
      this.totalCost,
      this.total,
      this.deliveryCost,
      this.date,
      this.createdAt,
      this.paymobOrderId,
      this.paymentUrl,
      this.productsDetail});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    status = json['status'];
    address = json['address'];
    createdAt = json['created_at'];
    cityId = json['city_id'];
    additionalInfo = json['additional_info'];
    buildingNum = json['building_num'];
    street = json['street'];
    countryId = json['country_id'];
    districtId = json['district_id'];
    phone = json['phone'];
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
    totalCost = json['total_cost'];
    total = json['total'];
    deliveryCost = json['delivery_cost'];
    date = json['date'];
    paymentUrl = json['payment_url'];
    paymobOrderId = json['paymob_order_id'];
    if (json['products_detail'] != null) {
      productsDetail = <ProductsDetail>[];
      json['products_detail'].forEach((v) {
        productsDetail!.add(ProductsDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user'] = user;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['address'] = address;
    data['city_id'] = cityId;
    data['additional_info'] = additionalInfo;
    data['building_num'] = buildingNum;
    data['street'] = street;
    data['country_id'] = countryId;
    data['district_id'] = districtId;
    data['phone'] = phone;
    data['payment_method'] = paymentMethod;
    data['payment_status'] = paymentStatus;
    data['total_cost'] = totalCost;
    data['total'] = total;
    data['delivery_cost'] = deliveryCost;
    data['date'] = date;
    data['payment_url'] = paymentUrl;
    data['paymob_order_id'] = paymobOrderId;
    if (productsDetail != null) {
      data['products_detail'] = productsDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductsDetail {
  int? id;
  String? itmNameAr;
  String? itmNameEn;
  String? itmSellPrice;
  String? image;
  String? qty;

  ProductsDetail(
      {this.id,
      this.itmNameAr,
      this.itmNameEn,
      this.itmSellPrice,
      this.image,
      this.qty});

  ProductsDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itmNameAr = json['itm_name_ar'];
    itmNameEn = json['itm_name_en'];
    itmSellPrice = json['itm_sell_price'];
    image = json['image'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['itm_name_ar'] = itmNameAr;
    data['itm_name_en'] = itmNameEn;
    data['itm_sell_price'] = itmSellPrice;
    data['image'] = image;
    data['qty'] = qty;
    return data;
  }
}
