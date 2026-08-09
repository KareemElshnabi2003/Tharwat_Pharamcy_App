import 'package:tharwat_pharmacy/Data/Model/Home/offers_model.dart';

class OfferProductsModel {
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
  OffersModel? offer;

  OfferProductsModel(
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
      this.offer});

  OfferProductsModel.fromJson(Map<String, dynamic> json) {
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
    data['primary_image'] = primaryImage;
    if (offer != null) {
      data['offer'] = offer!.toJson();
    }
    return data;
  }
}

