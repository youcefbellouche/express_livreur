// ignore_for_file: file_names

// ignore: camel_case_types
class Meta_data {
  String? key;
  String? value;
  int? qte;
  Meta_data({
    required this.key,
    required this.value,
  });
  Meta_data.fromJson(Map<String, dynamic> json) {
    key = json["key"];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = key;
    data['value'] = value;
    data['qte'] = qte;

    return data;
  }
}
