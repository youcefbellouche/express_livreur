// ignore_for_file: file_names

class Product {
  int? id;
  String? name;
  int? quantity;
  int? priceU;
  Product({
    this.name,
    this.quantity,
    this.priceU,
  });
  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json["name"];
    quantity = json["quantity"];
    priceU = json["price"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['quantity'] = quantity;
    data['price'] = priceU;

    return data;
  }
}
