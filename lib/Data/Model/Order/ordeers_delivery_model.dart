class OrdersDeliveryModel {
  int? id;
  UserId? userId;
  String? status;
  String? address;
  String? street;
  String? additionalInfo;
  String? buildingNum;
  String? phone;
  String? paymentMethod;
  String? subtotal;
  String? deliveryCost;
  String? total;
  List<Items>? items;
  String? createdAt;

  OrdersDeliveryModel(
      {this.id,
      this.userId,
      this.status,
      this.address,
      this.street,
      this.additionalInfo,
      this.buildingNum,
      this.phone,
      this.paymentMethod,
      this.subtotal,
      this.deliveryCost,
      this.total,
      this.items,
      this.createdAt});

  OrdersDeliveryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'] != null ? UserId.fromJson(json['user_id']) : null;
    status = json['status'];
    address = json['address'];
    street = json['street'];
    additionalInfo = json['additional_info'];
    buildingNum = json['building_num'];
    phone = json['phone'];
    paymentMethod = json['payment_method'];
    subtotal = json['subtotal'];
    deliveryCost = json['delivery_cost'];
    total = json['total'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (userId != null) {
      data['user_id'] = userId!.toJson();
    }
    data['status'] = status;
    data['address'] = address;
    data['street'] = street;
    data['additional_info'] = additionalInfo;
    data['building_num'] = buildingNum;
    data['phone'] = phone;
    data['payment_method'] = paymentMethod;
    data['subtotal'] = subtotal;
    data['delivery_cost'] = deliveryCost;
    data['total'] = total;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    return data;
  }
}

class UserId {
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

  UserId(
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

  UserId.fromJson(Map<String, dynamic> json) {
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

class Items {
  int? id;
  int? orderId;
  ProductId? productId;
  String? quantity;
  String? originalPrice;

  Items(
      {this.id,
      this.orderId,
      this.productId,
      this.quantity,
      this.originalPrice});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'] != null
        ? ProductId.fromJson(json['product_id'])
        : null;
    quantity = json['quantity'];
    originalPrice = json['original_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    if (productId != null) {
      data['product_id'] = productId!.toJson();
    }
    data['quantity'] = quantity;
    data['original_price'] = originalPrice;
    return data;
  }
}

class ProductId {
  int? id;
  String? itmCode;
  String? itnlCode;
  String? itmNameAr;
  String? itmNameEn;
  String? itmScientificN1;
  String? itmScientificN2;
  String? stoName;
  String? uNameBig;
  String? uNameMedium;
  String? uNameSmall;
  String? stoQtyBig;
  String? stoQtyMedium;
  String? stoQtySmall;
  String? itmSellPrice;
  int? itmIsmedicine;
  int? itmActive;
  String? companyNameAr;
  String? companyNameEn;
  String? description;
  String? insertDate;
  String? updateDate;
  String? primaryImage;
  bool? isFavourite;

  ProductId(
      {this.id,
      this.itmCode,
      this.itnlCode,
      this.itmNameAr,
      this.itmNameEn,
      this.itmScientificN1,
      this.itmScientificN2,
      this.stoName,
      this.uNameBig,
      this.uNameMedium,
      this.uNameSmall,
      this.stoQtyBig,
      this.stoQtyMedium,
      this.stoQtySmall,
      this.itmSellPrice,
      this.itmIsmedicine,
      this.itmActive,
      this.companyNameAr,
      this.companyNameEn,
      this.description,
      this.insertDate,
      this.updateDate,
      this.primaryImage,
      this.isFavourite});

  ProductId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itmCode = json['itm_code'];
    itnlCode = json['itnl_code'];
    itmNameAr = json['itm_name_ar'];
    itmNameEn = json['itm_name_en'];
    itmScientificN1 = json['itm_scientific_n1'];
    itmScientificN2 = json['itm_scientific_n2'];
    stoName = json['sto_name'];
    uNameBig = json['u_name_big'];
    uNameMedium = json['u_name_medium'];
    uNameSmall = json['u_name_small'];
    stoQtyBig = json['sto_qty_big'];
    stoQtyMedium = json['sto_qty_medium'];
    stoQtySmall = json['sto_qty_small'];
    itmSellPrice = json['itm_sell_price'];
    itmIsmedicine = json['itm_ismedicine'];
    itmActive = json['itm_active'];
    companyNameAr = json['Company_Name_Ar'];
    companyNameEn = json['Company_Name_En'];
    description = json['Description'];
    insertDate = json['insert_date'];
    updateDate = json['update_date'];
    primaryImage = json['primary_image'];
    isFavourite = json['is_favourite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['itm_code'] = itmCode;
    data['itnl_code'] = itnlCode;
    data['itm_name_ar'] = itmNameAr;
    data['itm_name_en'] = itmNameEn;
    data['itm_scientific_n1'] = itmScientificN1;
    data['itm_scientific_n2'] = itmScientificN2;
    data['sto_name'] = stoName;
    data['u_name_big'] = uNameBig;
    data['u_name_medium'] = uNameMedium;
    data['u_name_small'] = uNameSmall;
    data['sto_qty_big'] = stoQtyBig;
    data['sto_qty_medium'] = stoQtyMedium;
    data['sto_qty_small'] = stoQtySmall;
    data['itm_sell_price'] = itmSellPrice;
    data['itm_ismedicine'] = itmIsmedicine;
    data['itm_active'] = itmActive;
    data['Company_Name_Ar'] = companyNameAr;
    data['Company_Name_En'] = companyNameEn;
    data['Description'] = description;
    data['insert_date'] = insertDate;
    data['update_date'] = updateDate;
    data['primary_image'] = primaryImage;
    data['is_favourite'] = isFavourite;
    return data;
  }
}
