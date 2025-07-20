import 'dart:convert';

class NotificationModel {
  String responseStatus;
  String message;
  dynamic refresh;
  List<Detail> detail;
  dynamic details;
  dynamic status;

  NotificationModel({
    required this.responseStatus,
    required this.message,
    required this.refresh,
    required this.detail,
    required this.details,
    required this.status,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      responseStatus: json["responseStatus"],
      message: json["message"],
      refresh: json["refresh"],
      detail: List<Detail>.from(json["detail"].map((x) => Detail.fromJson(x))),
      details: json["details"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() => {
        "responseStatus": responseStatus,
        "message": message,
        "refresh": refresh,
        "detail": List<dynamic>.from(detail.map((x) => x.toJson())),
        "details": details,
        "status": status,
      };
}

class Detail {
  String date;
  String title;
  String body;
  String imageUrl;
  String redirectUrl;
  bool topic;
  bool allCustomer;
  bool toMobile;
  bool allBankCustomer;
  bool allBranchCustomer;

  Detail({
    required this.date,
    required this.title,
    required this.body,
    required this.imageUrl,
    required this.redirectUrl,
    required this.topic,
    required this.allCustomer,
    required this.toMobile,
    required this.allBankCustomer,
    required this.allBranchCustomer,
  });

  factory Detail.fromJson(Map<String, dynamic> json) {
    print(jsonEncode(json));
    return Detail(
      date: json["date"],
      title: json["title"],
      body: json["body"],
      topic: json["topic"],
      imageUrl: json["imageUrl"] ?? "",
      redirectUrl: json["redirectUrl"] ?? "",
      allCustomer: json["allCustomer"],
      toMobile: json["toMobile"],
      allBankCustomer: json["allBankCustomer"],
      allBranchCustomer: json["allBranchCustomer"],
    );
  }

  Map<String, dynamic> toJson() => {
        "date": date,
        "title": title,
        "body": body,
        "topic": topic,
        "allCustomer": allCustomer,
        "toMobile": toMobile,
        "allBankCustomer": allBankCustomer,
        "allBranchCustomer": allBranchCustomer,
      };
}
