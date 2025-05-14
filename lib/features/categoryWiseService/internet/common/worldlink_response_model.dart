// class WorldlinkResponseModel {
//   String? status;
//   String? code;
//   String? message;
//   Details? details;
//   Null? detail;

//   WorldlinkResponseModel(
//       {this.status, this.code, this.message, this.details, this.detail});

//   WorldlinkResponseModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     code = json['code'];
//     message = json['message'];
//     details =
//         json['details'] != null ? new Details.fromJson(json['details']) : null;
//     detail = json['detail'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['code'] = this.code;
//     data['message'] = this.message;
//     if (this.details != null) {
//       data['details'] = this.details!.toJson();
//     }
//     data['detail'] = this.detail;
//     return data;
//   }
// }

// class Details {
//   HashResponse? hashResponse;
//   List<Packages>? packages;
//   Null? currentPackages;

//   Details({this.hashResponse, this.packages, this.currentPackages});

//   Details.fromJson(Map<String, dynamic> json) {
//     hashResponse = json['hashResponse'] != null
//         ? new HashResponse.fromJson(json['hashResponse'])
//         : null;
//     if (json['packages'] != null) {
//       packages = <Packages>[];
//       json['packages'].forEach((v) {
//         packages!.add(new Packages.fromJson(v));
//       });
//     }
//     currentPackages = json['currentPackages'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.hashResponse != null) {
//       data['hashResponse'] = this.hashResponse!.toJson();
//     }
//     if (this.packages != null) {
//       data['packages'] = this.packages!.map((v) => v.toJson()).toList();
//     }
//     data['currentPackages'] = this.currentPackages;
//     return data;
//   }
// }

// class HashResponse {
//   String? reserveInfo;
//   String? wlinkUserName;
//   String? resultMessage;
//   String? subscribedPackageName;
//   String? paymentMessage;
//   String? dueAmount;
//   String? amount;
//   String? isNew;
//   String? sessionId;
//   String? customerName;
//   String? subscribedPackageType;
//   String? status;

//   HashResponse(
//       {this.reserveInfo,
//       this.wlinkUserName,
//       this.resultMessage,
//       this.subscribedPackageName,
//       this.paymentMessage,
//       this.dueAmount,
//       this.amount,
//       this.isNew,
//       this.sessionId,
//       this.customerName,
//       this.subscribedPackageType,
//       this.status});

//   HashResponse.fromJson(Map<String, dynamic> json) {
//     reserveInfo = json['Reserve Info'];
//     wlinkUserName = json['wlinkUserName'];
//     resultMessage = json['Result Message'];
//     subscribedPackageName = json['subscribedPackageName'];
//     paymentMessage = json['paymentMessage'];
//     dueAmount = json['dueAmount'];
//     amount = json['Amount'];
//     isNew = json['isNew'];
//     sessionId = json['sessionId'];
//     customerName = json['customerName'];
//     subscribedPackageType = json['subscribedPackageType'];
//     status = json['status'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['Reserve Info'] = this.reserveInfo;
//     data['wlinkUserName'] = this.wlinkUserName;
//     data['Result Message'] = this.resultMessage;
//     data['subscribedPackageName'] = this.subscribedPackageName;
//     data['paymentMessage'] = this.paymentMessage;
//     data['dueAmount'] = this.dueAmount;
//     data['Amount'] = this.amount;
//     data['isNew'] = this.isNew;
//     data['sessionId'] = this.sessionId;
//     data['customerName'] = this.customerName;
//     data['subscribedPackageType'] = this.subscribedPackageType;
//     data['status'] = this.status;
//     return data;
//   }
// }

// class Packages {
//   String? id;
//   String? amount;
//   String? currency;
//   String? text;
//   String? label;

//   Packages({this.id, this.amount, this.currency, this.text, this.label});

//   Packages.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     amount = json['amount'];
//     currency = json['currency'];
//     text = json['text'];
//     label = json['label'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['amount'] = this.amount;
//     data['currency'] = this.currency;
//     data['text'] = this.text;
//     data['label'] = this.label;
//     return data;
//   }
// }
