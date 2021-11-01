// ignore_for_file: file_names

class Stat {
  int? enLivraison;
  int? annuler;
  int? livrer;
  int? time;
  double? total;
  double? coutLivraison;
  dynamic coutAnnuler;
  Stat(
      {this.enLivraison,
      this.annuler,
      this.livrer,
      this.time,
      this.total,
      this.coutAnnuler,
      this.coutLivraison});

  Stat.fromJson(Map<String, dynamic> json) {
    if (json['en livraison'] != null) {
      enLivraison = json['en livraison'];
    }

    if (json['annuler'] != null) {
      annuler = json['annuler'];
    }

    time = json['time'];

    if (json['livrer'] != null) {
      livrer = json['livrer'];
    }

    if (json["total"] != null) {
      total = json["total"];
    }
    if (json["coutAnnuler"] != null) {
      coutAnnuler = json["coutAnnuler"];
    }
    if (json["coutLivraison"] != null) {
      coutLivraison = json["coutLivraison"];
    }
  }
}
