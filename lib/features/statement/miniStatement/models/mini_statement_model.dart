class MiniStatementModel {
  List<MinistatementList> ministatementList;
  double availableBalance;
  DateTime balanceDate;

  MiniStatementModel({
    required this.ministatementList,
    required this.availableBalance,
    required this.balanceDate,
  });

  factory MiniStatementModel.fromJson(Map<String, dynamic> json) =>
      MiniStatementModel(
        ministatementList: List<MinistatementList>.from(
            json["ministatementList"]
                .map((x) => MinistatementList.fromJson(x))),
        availableBalance: json["availableBalance"],
        balanceDate: DateTime.parse(json["balanceDate"]),
      );

  Map<String, dynamic> toJson() => {
        "ministatementList":
            List<dynamic>.from(ministatementList.map((x) => x.toJson())),
        "availableBalance": availableBalance,
        "balanceDate":
            "${balanceDate.year.toString().padLeft(4, '0')}-${balanceDate.month.toString().padLeft(2, '0')}-${balanceDate.day.toString().padLeft(2, '0')}",
      };
}

class MinistatementList {
  String transactionDate;
  String remarks;
  bool isCredit;
  double amount;
  String transactionCode;
  bool credit;

  MinistatementList({
    required this.transactionDate,
    required this.remarks,
    required this.isCredit,
    required this.amount,
    required this.transactionCode,
    required this.credit,
  });

  factory MinistatementList.fromJson(Map<String, dynamic> json) =>
      MinistatementList(
        transactionDate: json["transactionDate"] ?? "",
        remarks: json["remarks"] ?? "",
        isCredit: json["isCredit"] ?? false,
        amount: json["amount"] ?? 0.0,
        transactionCode: json["transactionCode"] ?? "",
        credit: json["credit"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "transactionDate": transactionDate,
        "remarks": remarks,
        "isCredit": isCredit,
        "amount": amount,
        "transactionCode": transactionCode,
        "credit": credit,
      };
}
