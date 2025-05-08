class WalletValidationModel {
  final String message;
  final String status;
  final String customerName;
  final String customerProfileImageUrl;
  String? validationIdentifier;

  WalletValidationModel({
    required this.message,
    required this.status,
    required this.customerName,
    required this.customerProfileImageUrl,
    required this.validationIdentifier,
  });

  factory WalletValidationModel.fromJson(Map<String, dynamic> json) =>
      WalletValidationModel(
        message: json["message"] ?? "",
        status: json["status"] ?? "",
        customerName: json["customerName"] ?? "",
        customerProfileImageUrl: json["customerProfileImageUrl"] ?? "",
        validationIdentifier: json["validationIdentifier"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "customerName": customerName,
        "customerProfileImageUrl": customerProfileImageUrl,
        "validationIdentifier": validationIdentifier,
      };
}
