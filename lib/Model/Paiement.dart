// ignore_for_file: file_names

class Paiement {
  List<dynamic>? commandes;
  dynamic benefice;
  dynamic dateDebut;
  dynamic dateFin;
  bool? payer;
  Paiement(
      {this.benefice,
      this.commandes,
      this.dateDebut,
      this.dateFin,
      this.payer});
  Paiement.fromJson(Map<String, dynamic> json) {
    commandes = json['commandes'];
    benefice = json['Benifice'];
    dateDebut = json['DateDebut'];
    dateFin = json['DateFin'];
    payer = json['payer'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['payer'] = payer;
    data['commandes'] = commandes;
    data['Benifice'] = benefice;
    data['DateDebut'] = dateDebut;
    data['DateFin'] = DateTime.now().millisecondsSinceEpoch;
    data['payer'] = true;

    return data;
  }
}
