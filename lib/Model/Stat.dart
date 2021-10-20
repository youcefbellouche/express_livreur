// ignore_for_file: file_names

class Stat {
  int? enLivraison;
  int? annuler;
  int? livrer;
  int? time;
  int? total;
  Stat({this.enLivraison, this.annuler, this.livrer, this.time, this.total});

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
  }
}
