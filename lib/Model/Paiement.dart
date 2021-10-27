// ignore_for_file: file_names

class Paiement {
  List<dynamic>? commandes;
  int? benefice;
  int? dateDebut;
  int? dateFin;
  bool? payer;
  Paiement(
      {this.benefice,
      this.commandes,
      this.dateDebut,
      this.dateFin,
      this.payer});
  Paiement.fromJson(Map<String, dynamic> json) {
    commandes = json['commandes'];
    benefice = json['Benefice'];
    dateDebut = json['DateDebut'];
    dateFin = json['DateFin'];
    payer = json['payer'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['payer'] = payer;
    data['commandes'] = commandes;
    data['Benefice'] = benefice;
    data['DateDebut'] = dateDebut;
    data['DateFin'] = DateTime.now().millisecondsSinceEpoch;
    data['payer'] = true;

    return data;
  }
}
