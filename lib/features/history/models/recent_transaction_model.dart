class RecentTransactionModel {
  double amount;
  String service;
  var serviceTo;
  String accountNumber;
  String customerRemarks;

  String transactionIdentifier;
  DateTime date;
  String status;
  dynamic airlinesPdfUrl;
  dynamic sessionId;
  int id;
  DateTime createdDate;
  String destination;
  double charge;
  double totalAmount;
  RequestDetail requestDetail;
  ResponseDetail responseDetail;
  String iconUrl;
  bool debit;
  String channelType;
  RecentTransactionModel({
    required this.amount,
    required this.service,
    required this.serviceTo,
    required this.accountNumber,
    required this.transactionIdentifier,
    required this.date,
    required this.status,
    required this.airlinesPdfUrl,
    required this.sessionId,
    required this.id,
    required this.createdDate,
    required this.destination,
    required this.charge,
    required this.totalAmount,
    required this.requestDetail,
    required this.responseDetail,
    required this.iconUrl,
    required this.debit,
    required this.channelType,
    required this.customerRemarks,
  });

  factory RecentTransactionModel.fromJson(Map<String, dynamic> json) =>
      RecentTransactionModel(
        amount: json["amount"]?.toDouble(),
        service: json["service"],
        serviceTo: json["serviceTo"],
        accountNumber: json["accountNumber"],
        transactionIdentifier: json["transactionIdentifier"],
        date: DateTime.tryParse(json["date"]) ?? DateTime.now(),
        status: json["status"],
        airlinesPdfUrl: json["airlinesPdfUrl"],
        sessionId: json["sessionId"],
        id: json["id"],
        createdDate: DateTime.parse(json["createdDate"]),
        destination: json["destination"] ?? "",
        charge: json["charge"],
        totalAmount: json["totalAmount"]?.toDouble(),
        requestDetail: RequestDetail.fromJson(json["requestDetail"]),
        responseDetail: ResponseDetail.fromJson(json["responseDetail"]),
        iconUrl: json["iconUrl"],
        debit: json["debit"],
        channelType: json["channelType"] ?? "",
        customerRemarks: json["customerRemarks"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "service": service,
        "serviceTo": serviceTo,
        "accountNumber": accountNumberValues.reverse[accountNumber],
        "transactionIdentifier": transactionIdentifier,
        "date": date.toIso8601String(),
        "status": recentTransactionModelStatusValues.reverse[status],
        "airlinesPdfUrl": airlinesPdfUrl,
        "sessionId": sessionId,
        "id": id,
        "createdDate": createdDate.toIso8601String(),
        "destination": destination,
        "charge": charge,
        "totalAmount": totalAmount,
        "requestDetail": requestDetail.toJson(),
        "responseDetail": responseDetail.toJson(),
        "iconUrl": iconUrl,
        "debit": debit,
        "customerRemarks": customerRemarks,
        "channelType": channelTypeValues.reverse[channelType],
      };
}

enum AccountNumber { THE_0010010011010001091, THE_0010010011110001013 }

final accountNumberValues = EnumValues({
  "001001-001-101-0001091": AccountNumber.THE_0010010011010001091,
  "001001-001-111-0001013": AccountNumber.THE_0010010011110001013
});

enum ChannelType { GPRS }

final channelTypeValues = EnumValues({"GPRS": ChannelType.GPRS});

class RequestDetail {
  String? destinationBankId;
  String? destinationBranchName;
  String? destinationAccountNumber;
  String? destinationBankName;
  String? destinationAccountName;
  String? customerAddress;
  String? amount;
  String? mobileNumber;
  String? serviceId;
  String? serviceTo;
  String? scno;
  String? officeCode;
  String? customerId;
  String? counterCode;

  RequestDetail({
    this.destinationBankId,
    this.destinationBranchName,
    this.destinationAccountNumber,
    this.destinationBankName,
    this.destinationAccountName,
    this.customerAddress,
    this.amount,
    this.mobileNumber,
    this.serviceId,
    this.serviceTo,
    this.customerId,
    this.officeCode,
    this.scno,
    this.counterCode,
  });

  factory RequestDetail.fromJson(Map<String, dynamic> json) => RequestDetail(
      destinationBankId: json["destinationBankId"],
      destinationBranchName: json["destinationBranchName"],
      destinationAccountNumber: json["destinationAccountNumber"],
      destinationBankName: json["destinationBankName"],
      destinationAccountName: json["destinationAccountName"],
      customerAddress: json["customer_address"],
      amount: json["amount"],
      mobileNumber: json["mobile_number"],
      serviceId: json["serviceId"],
      serviceTo: json["serviceTo"],
      customerId: json["customerId"],
      officeCode: json["officeCode"],
      scno: json["scno"],
      counterCode: json["counter_code"]);

  Map<String, dynamic> toJson() => {
        "destinationBankId": destinationBankId,
        "destinationBranchName": destinationBranchName,
        "destinationAccountNumber": destinationAccountNumber,
        "destinationBankName": destinationBankName,
        "destinationAccountName": destinationAccountName,
        "customer_address": customerAddress,
        "amount": amount,
        "mobile_number": mobileNumber,
        "serviceId": serviceId,
        "serviceTo": serviceTo,
        "customerId": customerId,
        "officeCode": officeCode,
        "scno": scno,
        "counter_code": counterCode,
      };
}

class ResponseDetail {
  String resultMessage;
  String? refStan;
  String? status;
  String? transactionIdentifier;
  String? serviceTo;
  String? isoCode;

  ResponseDetail({
    required this.resultMessage,
    this.refStan,
    required this.status,
    this.transactionIdentifier,
    this.serviceTo,
    this.isoCode,
  });

  factory ResponseDetail.fromJson(Map<String, dynamic> json) => ResponseDetail(
        resultMessage: json["Result Message"] ?? "",
        refStan: json["RefStan"] ?? "",
        status: json["status"] ?? "",
        transactionIdentifier: json["transactionIdentifier"] ?? "",
        serviceTo: json["serviceTo"] ?? "",
        isoCode: json["isoCode"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Result Message": resultMessage,
        "RefStan": refStan,
        "status": status,
        "transactionIdentifier": transactionIdentifier,
        "serviceTo": serviceTo,
        "isoCode": isoCode,
      };
}

enum RecentTransactionModelStatus { CANCELLED_WITH_REFUND, COMPLETE }

final recentTransactionModelStatusValues = EnumValues({
  "Cancelled With Refund": RecentTransactionModelStatus.CANCELLED_WITH_REFUND,
  "Complete": RecentTransactionModelStatus.COMPLETE
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

// class RecentTransactionModel {
//   double amount;
//   String service;
//   var serviceTo;
//   String accountNumber;
//   String transactionIdentifier;
//   DateTime date;
//   String status;
//   dynamic airlinesPdfUrl;
//   dynamic sessionId;
//   int id;
//   DateTime createdDate;
//   String destination;
//   double charge;
//   double totalAmount;
//   RequestDetail requestDetail;
//   ResponseDetail responseDetail;
//   String iconUrl;
//   bool debit;
//   String channelType;

//   RecentTransactionModel({
//     required this.amount,
//     required this.service,
//     required this.serviceTo,
//     required this.accountNumber,
//     required this.transactionIdentifier,
//     required this.date,
//     required this.status,
//     this.airlinesPdfUrl,
//     required this.channelType,
//     this.sessionId,
//     required this.id,
//     required this.createdDate,
//     required this.destination,
//     required this.charge,
//     required this.totalAmount,
//     required this.requestDetail,
//     required this.responseDetail,
//     required this.iconUrl,
//     required this.debit,
//   });

//   factory RecentTransactionModel.fromJson(Map<String, dynamic> json) =>
//       RecentTransactionModel(
//         amount: json["amount"],
//         service: json["service"],
//         serviceTo: json["serviceTo"],
//         accountNumber: json["accountNumber"],
//         transactionIdentifier: json["transactionIdentifier"],
//         date: DateTime.parse(json["date"]),
//         status: json["status"],
//         airlinesPdfUrl: json["airlinesPdfUrl"],
//         sessionId: json["sessionId"],
//         id: json["id"],
//         createdDate: DateTime.parse(json["createdDate"]),
//         destination: json["destination"] ?? "",
//         charge: json["charge"],
//         totalAmount: json["totalAmount"],
//         requestDetail: json["requestDetail"] ?? {},
//         responseDetail: json["responseDetail"] ?? {},
//         iconUrl: json["iconUrl"],
//         debit: json["debit"] ?? true,
//         channelType: json["channelType"] ?? "",
//       );

//   Map<String, dynamic> toJson() => {
//         "amount": amount,
//         "service": service,
//         "serviceTo": serviceTo,
//         "accountNumber": accountNumber,
//         "transactionIdentifier": transactionIdentifier,
//         "date": date.toIso8601String(),
//         "status": status,
//         "airlinesPdfUrl": airlinesPdfUrl,
//         "sessionId": sessionId,
//         "id": id,
//         "createdDate": createdDate.toIso8601String(),
//         "destination": destination,
//         "charge": charge,
//         "totalAmount": totalAmount,
//         "requestDetail": requestDetail,
//         "responseDetail": responseDetail,
//         "iconUrl": iconUrl,
//         "debit": debit,
//         "channelType": channelType,
//       };
// }

// class RequestDetail {
//   String? destinationBankId;
//   String? destinationBranchName;
//   String? destinationAccountNumber;
//   String? destinationBankName;
//   String? destinationAccountName;
//   String? customerAddress;
//   String? amount;
//   String? mobileNumber;
//   String? serviceId;
//   String? serviceTo;

//   RequestDetail({
//     this.destinationBankId,
//     this.destinationBranchName,
//     this.destinationAccountNumber,
//     this.destinationBankName,
//     this.destinationAccountName,
//     this.customerAddress,
//     this.amount,
//     this.mobileNumber,
//     this.serviceId,
//     this.serviceTo,
//   });

//   factory RequestDetail.fromJson(Map<String, dynamic> json) => RequestDetail(
//         destinationBankId: json["destinationBankId"],
//         destinationBranchName: json["destinationBranchName"],
//         destinationAccountNumber: json["destinationAccountNumber"],
//         destinationBankName: json["destinationBankName"],
//         destinationAccountName: json["destinationAccountName"],
//         customerAddress: json["customer_address"],
//         amount: json["amount"],
//         mobileNumber: json["mobile_number"],
//         serviceId: json["serviceId"],
//         serviceTo: json["serviceTo"],
//       );

//   Map<String, dynamic> toJson() => {
//         "destinationBankId": destinationBankId,
//         "destinationBranchName": destinationBranchName,
//         "destinationAccountNumber": destinationAccountNumber,
//         "destinationBankName": destinationBankName,
//         "destinationAccountName": destinationAccountName,
//         "customer_address": customerAddress,
//         "amount": amount,
//         "mobile_number": mobileNumber,
//         "serviceId": serviceId,
//         "serviceTo": serviceTo,
//       };
// }

// class ResponseDetail {
//   String? code;
//   String status;
//   String? resultMessage;
//   String? serviceTo;
//   String? isoCode;
//   String? transactionIdentifier;

//   ResponseDetail({
//     this.code,
//     required this.status,
//     this.resultMessage,
//     this.serviceTo,
//     this.isoCode,
//     this.transactionIdentifier,
//   });

//   factory ResponseDetail.fromJson(Map<String, dynamic> json) => ResponseDetail(
//         code: json["code"],
//         status: json["status"],
//         resultMessage: json["Result Message"],
//         serviceTo: json["serviceTo"],
//         isoCode: json["isoCode"],
//         transactionIdentifier: json["transactionIdentifier"],
//       );

//   Map<String, dynamic> toJson() => {
//         "code": code,
//         "status": status,
//         "Result Message": resultMessage,
//         "serviceTo": serviceTo,
//         "isoCode": isoCode,
//         "transactionIdentifier": transactionIdentifier,
//       };
// }
