// To parse this JSON data, do
//
//     final datapackModel = datapackModelFromJson(jsonString);

class DataPackPackage {
  String code;
  String name;
  String description;
  String validity;
  double amount;
  String category;
  dynamic subscriberType;
  String imagePath;

  DataPackPackage({
    required this.code,
    required this.name,
    required this.description,
    required this.validity,
    required this.amount,
    required this.category,
    this.subscriberType,
    required this.imagePath,
  });

  factory DataPackPackage.fromJson(Map<String, dynamic> json) =>
      DataPackPackage(
        code: json["code"],
        name: json["name"],
        description: json["description"],
        validity: json["validity"] ?? '',
        amount: json["amount"]?.toDouble(),
        category: json["category"] ?? '',
        subscriberType: json["subscriberType"] ?? '',
        imagePath: json["imagePath"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "description": description,
        "validity": validity,
        "amount": amount,
        "category": category,
        "subscriberType": subscriberType,
        "imagePath": imagePath,
      };
}
