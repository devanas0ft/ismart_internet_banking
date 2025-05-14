// To parse this JSON data, do
//
//     final tvPaymentModel = tvPaymentModelFromJson(jsonString);

import 'dart:convert';

TvDetailModel tvPaymentModelFromJson(String str) =>
    TvDetailModel.fromJson(json.decode(str));

String tvPaymentModelToJson(TvDetailModel data) => json.encode(data.toJson());

class TvDetailModel {
  String status;
  String code;
  String message;
  Details details;
  dynamic detail;

  TvDetailModel({
    required this.status,
    required this.code,
    required this.message,
    required this.details,
    this.detail,
  });

  factory TvDetailModel.fromJson(Map<String, dynamic> json) => TvDetailModel(
        status: json["status"],
        code: json["code"],
        message: json["message"],
        details: Details.fromJson(json["details"]),
        detail: json["detail"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
        "details": details.toJson(),
        "detail": detail,
      };
}

class Details {
  HashResponse hashResponse;
  List<TvPackages> tvPackages;
  List<CurrentPackage> currentPackages;

  Details({
    required this.hashResponse,
    required this.tvPackages,
    required this.currentPackages,
  });

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        hashResponse: HashResponse.fromJson(json["hashResponse"]),
        tvPackages: List<TvPackages>.from(
            json["packages"].map((x) => TvPackages.fromJson(x))),
        currentPackages: List<CurrentPackage>.from(
            json["currentPackages"].map((x) => CurrentPackage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "hashResponse": hashResponse.toJson(),
        "packages": List<dynamic>.from(tvPackages.map((x) => x.toJson())),
        "currentPackages":
            List<dynamic>.from(currentPackages.map((x) => x.toJson())),
      };
}

class CurrentPackage {
  int? id;
  String? amount;
  String? currency;
  String? text;
  String? description;
  String? planExpiryDate;

  CurrentPackage({
    this.id,
    this.amount,
    required this.currency,
    required this.text,
    this.description,
    required this.planExpiryDate,
  });

  factory CurrentPackage.fromJson(Map<String, dynamic> json) => CurrentPackage(
        id: json["id"],
        amount: json["amount"],
        currency: json["currency"],
        text: json["text"],
        description: json["description"],
        planExpiryDate: json["planExpiryDate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "currency": currency,
        "text": text,
        "description": description,
        "planExpiryDate": planExpiryDate,
      };
}

class TvPackages {
  String? id;
  String? amount;
  String? currency;
  String? text;
  String? description;
  String? planExpiryDate;

  TvPackages({
    this.id,
    this.amount,
    required this.currency,
    required this.text,
    this.description,
    required this.planExpiryDate,
  });

  factory TvPackages.fromJson(Map<String, dynamic> json) => TvPackages(
        id: json["id"],
        amount: json["amount"],
        currency: json["currency"],
        text: json["text"],
        description: json["description"],
        planExpiryDate: json["planExpiryDate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "currency": currency,
        "text": text,
        "description": description,
        "planExpiryDate": planExpiryDate,
      };
}

class HashResponse {
  String casId;
  String expiryDate;
  String resultMessage;
  String balance;
  String currentPlan;
  String customerId;
  String customerName;
  String status;

  HashResponse({
    required this.casId,
    required this.expiryDate,
    required this.resultMessage,
    required this.balance,
    required this.currentPlan,
    required this.customerId,
    required this.customerName,
    required this.status,
  });

  factory HashResponse.fromJson(Map<String, dynamic> json) => HashResponse(
        casId: json["casId"] ?? "",
        expiryDate: json["expiryDate"] ?? "",
        resultMessage: json["Result Message"] ?? "",
        balance: json["balance"] ?? "",
        currentPlan: json["currentPlan"] ?? "",
        customerId: json["customerId "] ?? "",
        customerName: json["customerName"] ?? "",
        status: json["status"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "casId": casId,
        "expiryDate": expiryDate,
        "Result Message": resultMessage,
        "balance": balance,
        "currentPlan": currentPlan,
        "customerId ": customerId,
        "customerName": customerName,
        "status": status,
      };
}
