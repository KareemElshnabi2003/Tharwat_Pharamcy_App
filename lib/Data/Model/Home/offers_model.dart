class OffersModel {
  int? id;
  String? name;
  String? value;
  String? anotherValue;
  String? type;
  String? startDate;
  String? endDate;
  String? description;
  String? image;

  OffersModel(
      {this.id,
      this.name,
      this.value,
      this.anotherValue,
      this.type,
      this.startDate,
      this.endDate,
      this.description,
      this.image});

  OffersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    anotherValue = json['another_value'];
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
    data['another_value'] = anotherValue;
    data['type'] = type;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['description'] = description;
    data['image'] = image;
    return data;
  }
}
