// ignore_for_file: file_names
class Filter {
  String value;
  String text;
  String sortOrder;
  Filter(this.value, this.text, this.sortOrder);
}

final sortByOptions = [
  Filter("all", "Tout", "asc"),
  Filter("En attente", "En attente", "asc"),
  Filter("en livraison", "En livraison", "asc"),
  Filter("livré", "Livré", "asc"),
  Filter("annuler", "Annuler", "asc"),
];
