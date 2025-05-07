class FullStatementModel {
  double openingBalance;
  double closingBalance;
  String fromDate;
  String toDate;
  String accountNumber;
  String accountType;
  String address;
  String pdfUrl;
  List<AccountStatementDtos> accountStatementDtos;
  String accountName;

  FullStatementModel({
    required this.openingBalance,
    required this.closingBalance,
    required this.fromDate,
    required this.toDate,
    required this.accountNumber,
    required this.accountType,
    required this.address,
    required this.pdfUrl,
    required this.accountStatementDtos,
    required this.accountName,
  });

  factory FullStatementModel.fromJson(Map<String, dynamic> json) {
    return FullStatementModel(
      openingBalance: json['openingBalance'] ?? 0.0,
      closingBalance: json['closingBalance'] ?? 0.0,
      fromDate: json['fromDate'] ?? DateTime.now().toString(),
      toDate: json['toDate'] ?? DateTime.now().toString(),
      accountNumber: json['accountNumber'] ?? "",
      accountType: json['accountType'] ?? "",
      address: json['address'] ?? "",
      pdfUrl: json['pdfUrl'] ?? "",
      accountStatementDtos: _getStatement(json),
      accountName: json['accountName'] ?? "",
    );
  }

  static _getStatement(Map<String, dynamic> json) {
    List<AccountStatementDtos> _statementsList = [];

    List _rawList = List.from(json['accountStatementDtos'] ?? []);
    _rawList.forEach((v) {
      _statementsList.add(AccountStatementDtos.fromJson(v));
    });

    return _statementsList;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['openingBalance'] = openingBalance;
    data['closingBalance'] = closingBalance;
    data['fromDate'] = fromDate;
    data['toDate'] = toDate;
    data['accountNumber'] = accountNumber;
    data['accountType'] = accountType;
    data['address'] = address;
    data['pdfUrl'] = pdfUrl;
    data['accountStatementDtos'] =
        accountStatementDtos.map((v) => v.toJson()).toList();
    data['accountName'] = accountName;
    return data;
  }
}

class AccountStatementDtos {
  String transactionDate;
  String remarks;
  double debit;
  double credit;
  double balance;

  AccountStatementDtos({
    required this.transactionDate,
    required this.remarks,
    required this.debit,
    required this.credit,
    required this.balance,
  });

  factory AccountStatementDtos.fromJson(Map<String, dynamic> json) {
    return AccountStatementDtos(
      transactionDate: json['transactionDate'],
      remarks: json['remarks'] ?? "",
      debit: json['debit'] ?? 0.0,
      credit: json['credit'] ?? 0.0,
      balance: json['balance'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transactionDate'] = transactionDate;
    data['remarks'] = remarks;
    data['debit'] = debit;
    data['credit'] = credit;
    data['balance'] = balance;
    return data;
  }
}
