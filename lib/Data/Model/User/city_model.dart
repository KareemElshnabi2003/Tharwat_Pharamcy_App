class CityModel {
 
  int? id;
  String? name;
  int? countryId;
  String? countryName;

  CityModel({this.id, this.name, this.countryId, this.countryName});

  CityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    countryId = json['country_id'];
    countryName = json['country_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['country_id'] = countryId;
    data['country_name'] = countryName;
    return data;
  }
}


