// To parse this JSON data, do
//
//     final passengerDetailModel = passengerDetailModelFromJson(jsonString);

import 'dart:convert';

List<PassengerDetailModel> passengerDetailModelFromJson(String str) =>
    List<PassengerDetailModel>.from(
        json.decode(str).map((x) => PassengerDetailModel.fromJson(x)));

String passengerDetailModelToJson(List<PassengerDetailModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PassengerDetailModel {
  String firstname;
  String lastname;
  String type;
  String title;
  String gender;
  String remarks;
  String nationality;
  String nationalityName;

  PassengerDetailModel(
      {required this.firstname,
      required this.lastname,
      required this.type,
      required this.title,
      required this.gender,
      required this.remarks,
      required this.nationality,
      required this.nationalityName});

  factory PassengerDetailModel.fromJson(Map<String, dynamic> json) =>
      PassengerDetailModel(
        firstname: json["firstName"],
        lastname: json["lastName"],
        type: json["paxType"],
        title: json["title"],
        gender: json["gender"],
        remarks: json["paxRemarks"],
        nationality: json["nationality"],
        nationalityName: json["nationalityName"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstname,
        "lastName": lastname,
        "paxType": type,
        "title": title,
        "gender": gender,
        "nationality": nationality,
        "paxRemarks": remarks,
        // "nationalityName": nationalityName
      };
}
