// To parse this JSON data, do
//
//     final busDetailModel = busDetailModelFromJson(jsonString);

import 'dart:convert';

List<BusDetailModel> busDetailModelFromJson(String str) =>
    List<BusDetailModel>.from(
        json.decode(str).map((x) => BusDetailModel.fromJson(x)));

String busDetailModelToJson(List<BusDetailModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BusDetailModel {
  int status;
  String id;
  Date date;
  DateTime dateEn;
  String departureTime;
  bool lockStatus;
  String busDetailModelOperator;
  BusNo busNo;
  String busType;
  bool multiPrice;
  int ticketPrice;
  int noOfColumn;
  String tripHashcode;
  List<SeatLayout> seatLayout;
  List<String>? amenities;
  String inputTypeCode;

  BusDetailModel({
    required this.status,
    required this.id,
    required this.date,
    required this.dateEn,
    required this.departureTime,
    required this.lockStatus,
    required this.busDetailModelOperator,
    required this.busNo,
    required this.busType,
    required this.multiPrice,
    required this.ticketPrice,
    required this.noOfColumn,
    required this.tripHashcode,
    required this.seatLayout,
    required this.amenities,
    required this.inputTypeCode,
  });

  factory BusDetailModel.fromJson(Map<String, dynamic> json) => BusDetailModel(
        status: json["status"],
        id: json["id"],
        date: dateValues.map[json["date"]]!,
        dateEn: DateTime.parse(json["dateEn"]),
        departureTime: json["departureTime"],
        lockStatus: json["lockStatus"],
        busDetailModelOperator: json["operator"],
        busNo: busNoValues.map[json["busNo"]]!,
        busType: json["busType"],
        multiPrice: json["multiPrice"],
        ticketPrice: json["ticketPrice"],
        noOfColumn: json["noOfColumn"],
        tripHashcode: json["tripHashcode"],
        seatLayout: List<SeatLayout>.from(
            json["seatLayout"].map((x) => SeatLayout.fromJson(x))),
        amenities: json["amenities"] == null
            ? []
            : List<String>.from(json["amenities"]!.map((x) => x)),
        inputTypeCode: json["inputTypeCode"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "id": id,
        "date": dateValues.reverse[date],
        "dateEn":
            "${dateEn.year.toString().padLeft(4, '0')}-${dateEn.month.toString().padLeft(2, '0')}-${dateEn.day.toString().padLeft(2, '0')}",
        "departureTime": departureTime,
        "lockStatus": lockStatus,
        "operator": busDetailModelOperator,
        "busNo": busNoValues.reverse[busNo],
        "busType": busType,
        "multiPrice": multiPrice,
        "ticketPrice": ticketPrice,
        "noOfColumn": noOfColumn,
        "tripHashcode": tripHashcode,
        "seatLayout": List<dynamic>.from(seatLayout.map((x) => x.toJson())),
        "amenities": amenities == null
            ? []
            : List<dynamic>.from(amenities!.map((x) => x)),
        "inputTypeCode": inputTypeCode,
      };
}

enum BusNo { BA_1_PA_1365, N_A }

final busNoValues =
    EnumValues({"BA 1 PA 1365": BusNo.BA_1_PA_1365, "n/a": BusNo.N_A});

enum Date { THE_2080_KARTIK_14 }

final dateValues = EnumValues({"2080-Kartik-14": Date.THE_2080_KARTIK_14});

class SeatLayout {
  String displayName;
  BookingStatus bookingStatus;

  SeatLayout({
    required this.displayName,
    required this.bookingStatus,
  });

  factory SeatLayout.fromJson(Map<String, dynamic> json) => SeatLayout(
        displayName: json["displayName"],
        bookingStatus: bookingStatusValues.map[json["bookingStatus"]]!,
      );

  Map<String, dynamic> toJson() => {
        "displayName": displayName,
        "bookingStatus": bookingStatusValues.reverse[bookingStatus],
      };
}

enum BookingStatus { NA, NO, YES }

final bookingStatusValues = EnumValues(
    {"na": BookingStatus.NA, "No": BookingStatus.NO, "Yes": BookingStatus.YES});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
