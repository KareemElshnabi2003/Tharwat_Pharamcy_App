class DistrictModel {
  int? id;
  String? name;
  int? cityId;
  String? cityName;

  DistrictModel({this.id, this.name, this.cityId, this.cityName});

  DistrictModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cityId = json['country_id'];
    cityName = json['country_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['country_id'] = cityId;
    data['country_name'] = cityName;
    return data;
  }
}
