class UserAuthModel {
  int? id;
  String? name;
  String? image;
  String? email;
  String? token;
  String? phone;
  String? longitude;
  String? latitude;
  String? status;
  String? roleId;
  String? role;
  District? district;

  UserAuthModel(
      {this.id,
      this.name,
      this.image,
      this.phone,
      this.email,
      this.token,
      this.longitude,
      this.latitude,
      this.status,
      this.roleId,
      this.role,
      this.district});

  UserAuthModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    image = json['image'];
    email = json['email'];
    token = json['token'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    status = json['status'];
    roleId = json['role_id'].toString();
    role = json['role'];
    district =
        json['district'] != null ? District.fromJson(json['district']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['phone'] = phone;
    data['name'] = name;
    data['image'] = image;
    data['email'] = email;
    data['token'] = token;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['status'] = status;
    data['role_id'] = roleId;
    data['role'] = role;
    if (district != null) {
      data['district'] = district!.toJson();
    }
    return data;
  }
}

class District {
  int? id;
  String? name;
  City? city;

  District({this.id, this.name, this.city});

  District.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    city = json['city'] != null ? City.fromJson(json['city']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (city != null) {
      data['city'] = city!.toJson();
    }
    return data;
  }
}

class City {
  int? id;
  String? name;
  Country? country;

  City({this.id, this.name, this.country});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    country =
        json['country'] != null ? Country.fromJson(json['country']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (country != null) {
      data['country'] = country!.toJson();
    }
    return data;
  }
}

class Country {
  int? id;
  String? name;

  Country({this.id, this.name});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
