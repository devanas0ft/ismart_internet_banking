class WalletModel {
  final int id;
  final String name;
  final String descOneFieldName;
  final String descOneFieldType;
  final bool descOneFixedLength;
  final int descOneLength;
  final dynamic descOneMinLength;
  final dynamic descOneMaxLength;
  final String descTwoFieldName;
  final String descTwoFieldType;
  final bool descTwoFixedLength;
  final int descTwoLength;
  final dynamic descTwoMinLength;
  final dynamic descTwoMaxLength;
  final String icon;
  final dynamic accountHead;
  final dynamic accountNumber;
  final dynamic minAmount;
  final dynamic maxAmount;
  final String status;

  WalletModel({
    required this.id,
    required this.name,
    required this.descOneFieldName,
    required this.descOneFieldType,
    required this.descOneFixedLength,
    required this.descOneLength,
    required this.descOneMinLength,
    required this.descOneMaxLength,
    required this.descTwoFieldName,
    required this.descTwoFieldType,
    required this.descTwoFixedLength,
    required this.descTwoLength,
    required this.descTwoMinLength,
    required this.descTwoMaxLength,
    required this.icon,
    required this.accountHead,
    required this.accountNumber,
    required this.minAmount,
    required this.maxAmount,
    required this.status,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
        id: json["id"],
        name: json["name"] ?? "",
        descOneFieldName: json["descOneFieldName"] ?? "",
        descOneFieldType: json["descOneFieldType"] ?? "",
        descOneFixedLength: json["descOneFixedLength"] ?? "",
        descOneLength: json["descOneLength"] ?? 0,
        descOneMinLength: json["descOneMinLength"] ?? 0,
        descOneMaxLength: json["descOneMaxLength"] ?? 0,
        descTwoFieldName: json["descTwoFieldName"] ?? "",
        descTwoFieldType: json["descTwoFieldType"] ?? "",
        descTwoFixedLength: json["descTwoFixedLength"] ?? 0,
        descTwoLength: json["descTwoLength"] ?? 0,
        descTwoMinLength: json["descTwoMinLength"] ?? 0,
        descTwoMaxLength: json["descTwoMaxLength"] ?? 0,
        icon: json["icon"] ?? "",
        accountHead: json["accountHead"] ?? "",
        accountNumber: json["accountNumber"] ?? "",
        minAmount: json["minAmount"] ?? 0.0,
        maxAmount: json["maxAmount"] ?? 0.0,
        status: json["status"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "descOneFieldName": descOneFieldName,
        "descOneFieldType": descOneFieldType,
        "descOneFixedLength": descOneFixedLength,
        "descOneLength": descOneLength,
        "descOneMinLength": descOneMinLength,
        "descOneMaxLength": descOneMaxLength,
        "descTwoFieldName": descTwoFieldName,
        "descTwoFieldType": descTwoFieldType,
        "descTwoFixedLength": descTwoFixedLength,
        "descTwoLength": descTwoLength,
        "descTwoMinLength": descTwoMinLength,
        "descTwoMaxLength": descTwoMaxLength,
        "icon": icon,
        "accountHead": accountHead,
        "accountNumber": accountNumber,
        "minAmount": minAmount,
        "maxAmount": maxAmount,
        "status": status,
      };
}
