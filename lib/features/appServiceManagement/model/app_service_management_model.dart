class AppServiceManagementModel {
  String name;
  String uniqueIdentifier;
  String type;
  String status;
  String? imageUrl;
  int appOrder;
  bool detailNew;

  AppServiceManagementModel({
    required this.name,
    required this.uniqueIdentifier,
    required this.type,
    required this.status,
    this.imageUrl,
    required this.appOrder,
    required this.detailNew,
  });

  factory AppServiceManagementModel.fromJson(Map<String, dynamic> json) =>
      AppServiceManagementModel(
        name: json["name"],
        uniqueIdentifier: json["uniqueIdentifier"],
        type: json["type"] ?? "",
        status: json["status"] ?? "",
        imageUrl: json["imageUrl"],
        appOrder: json["appOrder"],
        detailNew: json["new"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "uniqueIdentifier": uniqueIdentifier,
        "type": type,
        "status": status,
        "imageUrl": imageUrl,
        "appOrder": appOrder,
        "new": detailNew,
      };
}
