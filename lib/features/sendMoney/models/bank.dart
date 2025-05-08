class Bank {
  final String bankId;
  final String refBankId;
  final String bankName;
  final String enabled;
  final String lastModifiedOn;
  final String swiftCode;
  final String iconUrl;
  Bank({
    required this.bankId,
    required this.refBankId,
    required this.bankName,
    required this.enabled,
    required this.lastModifiedOn,
    required this.swiftCode,
    required this.iconUrl,
  });

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        bankId: json["bankId"] ?? json["bankCode"] ?? "",
        refBankId: json["refBankId"] ?? "",
        bankName: json["bankName"] ?? "",
        enabled: json["enabled"] ?? "",
        lastModifiedOn: json["lastModifiedOn"] ?? "",
        swiftCode: json["swiftCode"] ?? "",
        iconUrl: json["iconUrl"] ?? json["bankLogo"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "bankId": bankId,
        "refBankId": refBankId,
        "bankName": bankName,
        "enabled": enabled,
        "lastModifiedOn": lastModifiedOn,
        "swiftCode": swiftCode,
        "iconUrl": iconUrl,
      };
}
