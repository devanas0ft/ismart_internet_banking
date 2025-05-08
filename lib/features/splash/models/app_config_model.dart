class AppConfigDetails {
  final int id;

  final int version;
  final String contactNumber;
  final String facebookUrl;
  final String registerUrl;
  final String email;
  final String web;
  final String address;
  final String androidMinimumVersion;
  final String iosMinimumVersion;
  final bool maintenanceMode;
  final int bankId;
  final String bankName;
  final String ibankHost;
  final String ibankingPrimaryColor;
  final String ibankingSecondaryColor;
  final String ibankingTertiaryColor;
  final bool appConfigDetailsNew;

  AppConfigDetails({
    required this.id,
    required this.version,
    required this.contactNumber,
    required this.facebookUrl,
    required this.registerUrl,
    required this.email,
    required this.web,
    required this.address,
    required this.androidMinimumVersion,
    required this.iosMinimumVersion,
    required this.maintenanceMode,
    required this.bankId,
    required this.bankName,
    required this.ibankHost,
    required this.ibankingPrimaryColor,
    required this.ibankingSecondaryColor,
    required this.ibankingTertiaryColor,
    required this.appConfigDetailsNew,
  });

  factory AppConfigDetails.fromJson(Map<String, dynamic> json) =>
      AppConfigDetails(
        id: json["id"] ?? 0,
        version: json["version"] ?? 0,
        contactNumber: json["contactNumber"] ?? "",
        facebookUrl: json["facebookUrl"] ?? "",
        registerUrl: json["registerUrl"] ?? "",
        email: json["email"] ?? "",
        web: json["web"] ?? "",
        address: json["address"] ?? "",
        androidMinimumVersion: json["androidMinimumVersion"] ?? "",
        iosMinimumVersion: json["iosMinimumVersion"] ?? "",
        maintenanceMode: json["maintenanceMode"] ?? false,
        bankId: json["bankId"] ?? 0,
        bankName: json["bankName"] ?? "",
        ibankHost: json["ibankHost"] ?? "",
        ibankingPrimaryColor: json["ibankingPrimaryColor"] ?? "",
        ibankingSecondaryColor: json["ibankingSecondaryColor"] ?? "",
        ibankingTertiaryColor: json["ibankingTertiaryColor"] ?? "",
        appConfigDetailsNew: json["new"] ?? true,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "version": version,
        "contactNumber": contactNumber,
        "facebookUrl": facebookUrl,
        "registerUrl": registerUrl,
        "email": email,
        "web": web,
        "address": address,
        "androidMinimumVersion": androidMinimumVersion,
        "iosMinimumVersion": iosMinimumVersion,
        "maintenanceMode": maintenanceMode,
        "bankId": bankId,
        "bankName": bankName,
        "ibankHost": ibankHost,
        "ibankingPrimaryColor": ibankingPrimaryColor,
        "ibankingSecondaryColor": ibankingSecondaryColor,
        "ibankingTertiaryColor": ibankingTertiaryColor,
        "new": appConfigDetailsNew,
      };
}
