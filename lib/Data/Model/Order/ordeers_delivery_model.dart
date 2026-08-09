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
    userId =
        json['user_id'] != null ? new UserId.fromJson(json['user_id']) : null;
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
        items!.add(new Items.fromJson(v));
      });
    }
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.userId != null) {
      data['user_id'] = this.userId!.toJson();
    }
    data['status'] = this.status;
    data['address'] = this.address;
    data['street'] = this.street;
    data['additional_info'] = this.additionalInfo;
    data['building_num'] = this.buildingNum;
    data['phone'] = this.phone;
    data['payment_method'] = this.paymentMethod;
    data['subtotal'] = this.subtotal;
    data['delivery_cost'] = this.deliveryCost;
    data['total'] = this.total;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['gender'] = this.gender;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['status'] = this.status;
    data['role_id'] = this.roleId;
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
        ? new ProductId.fromJson(json['product_id'])
        : null;
    quantity = json['quantity'];
    originalPrice = json['original_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    if (this.productId != null) {
      data['product_id'] = this.productId!.toJson();
    }
    data['quantity'] = this.quantity;
    data['original_price'] = this.originalPrice;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['itm_code'] = this.itmCode;
    data['itnl_code'] = this.itnlCode;
    data['itm_name_ar'] = this.itmNameAr;
    data['itm_name_en'] = this.itmNameEn;
    data['itm_scientific_n1'] = this.itmScientificN1;
    data['itm_scientific_n2'] = this.itmScientificN2;
    data['sto_name'] = this.stoName;
    data['u_name_big'] = this.uNameBig;
    data['u_name_medium'] = this.uNameMedium;
    data['u_name_small'] = this.uNameSmall;
    data['sto_qty_big'] = this.stoQtyBig;
    data['sto_qty_medium'] = this.stoQtyMedium;
    data['sto_qty_small'] = this.stoQtySmall;
    data['itm_sell_price'] = this.itmSellPrice;
    data['itm_ismedicine'] = this.itmIsmedicine;
    data['itm_active'] = this.itmActive;
    data['Company_Name_Ar'] = this.companyNameAr;
    data['Company_Name_En'] = this.companyNameEn;
    data['Description'] = this.description;
    data['insert_date'] = this.insertDate;
    data['update_date'] = this.updateDate;
    data['primary_image'] = this.primaryImage;
    data['is_favourite'] = this.isFavourite;
    return data;
  }
}
