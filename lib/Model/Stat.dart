// ignore_for_file: file_names

class Stat {
  int? enLivraison;
  Stat({this.enLivraison});

  Stat.fromJson(Map<String, dynamic> json) {
    enLivraison = json['en livraison'];
  }
}
