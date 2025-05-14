// To parse this JSON data, do
//
//     final provinceListGovModel = provinceListGovModelFromJson(jsonString);

import 'dart:convert';

ProvinceListGovModel provinceListGovModelFromJson(String str) =>
    ProvinceListGovModel.fromJson(json.decode(str));

String provinceListGovModelToJson(ProvinceListGovModel data) =>
    json.encode(data.toJson());

class ProvinceListGovModel {
  String status;
  String code;
  String message;
  List<Detail> details;
  dynamic detail;

  ProvinceListGovModel({
    required this.status,
    required this.code,
    required this.message,
    required this.details,
    this.detail,
  });

  factory ProvinceListGovModel.fromJson(Map<String, dynamic> json) =>
      ProvinceListGovModel(
        status: json["status"],
        code: json["code"],
        message: json["message"],
        details:
            List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
        detail: json["detail"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
        "detail": detail,
      };
}

class Detail {
  String name;
  String code;
  bool isDistrict;

  Detail({
    required this.name,
    required this.code,
    required this.isDistrict,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        name: json["name"],
        code: json["code"],
        isDistrict: json["isDistrict"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "code": code,
        "isDistrict": isDistrict,
      };
}
