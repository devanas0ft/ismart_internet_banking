class KhanePaniModel {
  String name;
  String value;

  KhanePaniModel({
    required this.name,
    required this.value,
  });

  factory KhanePaniModel.fromJson(Map<String, dynamic> json) => KhanePaniModel(
        name: json["name"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
      };
}
