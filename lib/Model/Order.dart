// ignore_for_file: file_names

import 'Meta.dart';
import 'Product.dart';
import 'User.dart';

class Order {
  int? id;
  String? dateCreated;
  List<dynamic>? variable;
  String? price;
  User? user;
  Product? product;
  Meta_data? meta;
  String? totalRammaser;
  String? note;
  String? status;
  String? total;
  double? coutLivraison;
  double? coutAnnuler;
  int? dateEnlivraison;
  int? dateLivrer;

  Order(
      {this.price,
      this.id,
      this.dateCreated,
      this.user,
      this.product,
      this.meta,
      this.totalRammaser,
      this.note,
      this.variable,
      this.total,
      this.coutLivraison,
      this.coutAnnuler,
      this.status});

  Order.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    dateCreated = json["date_created"];
    price = json['total'];
    totalRammaser = json['totalRammaser'];
    user = User.fromJson(json["user"]);
    product = Product.fromJson(json["products"]);
    meta = Meta_data.fromJson(json["meta"]);
    variable = json['color'];
    status = json['status'];
    note = json['note'];
    total = json['total'];
    coutLivraison = json['coutLivraison'];
    coutAnnuler = json['coutAnnuler'];
    dateEnlivraison = json['dateEnlivraison'];
    dateLivrer = json['dateLivrer'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;

    data['date_created'] = dateCreated;

    data['total'] = price;

    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    if (product != null) {
      data['products'] = product!.toJson();
    }
    data['color'] = variable;

    data['totalRammaser'] = totalRammaser;
    data['note'] = note;
    data['status'] = status;

    return data;
  }
}
