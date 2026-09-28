import 'package:tharwat_pharmacy/Data/Model/Home/offers_model.dart';

class ProductModel {
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
  bool? isFavourite;
  String? primaryImage;
  Category? category;
  OffersModel? offer;

  ProductModel(
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
      this.isFavourite,
      this.primaryImage,
      this.category,
      this.offer});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int
        ? json['id'] as int
        : int.tryParse(json['id']?.toString() ?? '');
    itmCode = json['itm_code']?.toString();
    itnlCode = json['itnl_code']?.toString();
    itmNameAr = json['itm_name_ar']?.toString();
    itmNameEn = json['itm_name_en']?.toString();
    itmScientificN1 = json['itm_scientific_n1']?.toString();
    itmScientificN2 = json['itm_scientific_n2']?.toString();
    stoName = json['sto_name']?.toString();
    uNameBig = json['u_name_big']?.toString();
    uNameMedium = json['u_name_medium']?.toString();
    uNameSmall = json['u_name_small']?.toString();
    stoQtyBig = json['sto_qty_big']?.toString();
    stoQtyMedium = json['sto_qty_medium']?.toString();
    stoQtySmall = json['sto_qty_small']?.toString();
    itmSellPrice = json['itm_sell_price']?.toString();
    itmIsmedicine = json['itm_ismedicine'] is int
        ? json['itm_ismedicine'] as int
        : int.tryParse(json['itm_ismedicine']?.toString() ?? '');
    itmActive = json['itm_active'] is int
        ? json['itm_active'] as int
        : int.tryParse(json['itm_active']?.toString() ?? '');
    companyNameAr = json['Company_Name_Ar']?.toString();
    companyNameEn = json['Company_Name_En']?.toString();
    description = json['Description']?.toString();
    insertDate = json['insert_date']?.toString();
    updateDate = json['update_date']?.toString();
    final favVal = json['is_favourite'];
    if (favVal is bool) {
      isFavourite = favVal;
    } else if (favVal is num) {
      isFavourite = favVal == 1;
    } else if (favVal is String) {
      isFavourite = favVal == '1' || favVal.toLowerCase() == 'true';
    } else {
      isFavourite = false;
    }
    primaryImage = json['primary_image']?.toString();
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    offer = json['offer'] != null ? OffersModel.fromJson(json['offer']) : null;
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
    data['is_favourite'] = isFavourite;
    data['primary_image'] = primaryImage;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (offer != null) {
      data['offer'] = offer!.toJson();
    }
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? icon;

  Category({this.id, this.name, this.icon});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int
        ? json['id'] as int
        : int.tryParse(json['id']?.toString() ?? '');
    name = json['name']?.toString();
    icon = json['icon']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['icon'] = icon;
    return data;
  }
}
