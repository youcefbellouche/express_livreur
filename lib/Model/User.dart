// ignore_for_file: file_names

class User {
  String? firstName;
  String? address;
  String? city;
  String? state;
  String? phone;
  User({
    this.firstName,
    this.address,
    this.city,
    this.state,
    this.phone,
  });
  User.fromJson(Map<String, dynamic> json) {
    firstName = json["first_name"];
    address = json["address_1"];
    city = json["city"];
    state = json["state"];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['first_name'] = firstName;
    data['address_1'] = address;
    data['city'] = city;
    data['state'] = state;
    data['phone'] = phone;
    return data;
  }
}
