// ignore_for_file: file_names

import 'Product.dart';
import 'User.dart';

class Order {
  int? id;
  String? dateCreated;
  List<dynamic>? variable;
  String? price;
  User? user;
  Product? product;

  String? totalRammaser;
  String? note;
  String? status;
  String? total;
  double? coutLivraison;
  double? coutAnnuler;
  int? dateEnlivraison;
  int? dateLivrer;
  String? raisonAnnuler;

  Order(
      {this.price,
      this.id,
      this.raisonAnnuler,
      this.dateCreated,
      this.user,
      this.product,
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

    variable = json['color'];
    status = json['status'];
    note = json['note'];
    total = json['total'];
    coutLivraison = json['coutLivraison'];
    coutAnnuler = json['coutAnnuler'];
    raisonAnnuler = json['raisonAnnuler'];
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
