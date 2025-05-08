class InternalBranch {
  final int id;
  final String name;
  final String address;
  final String branchCode;
  final String bank;
  final String city;
  final bool checker;
  final bool maker;
  final String state;
  final int bankId;
  final String bankCode;
  final String cbsBranchCode;
  final String email;
  final String branchId;
  final String latitude;
  final String longitude;
  final String nchl;
  final String fax;
  final String telephoneNumber;
  final String branchManager;
  final DateTime createdDate;

  InternalBranch({
    required this.id,
    required this.name,
    required this.address,
    required this.branchCode,
    required this.bank,
    required this.city,
    required this.checker,
    required this.maker,
    required this.state,
    required this.bankId,
    required this.bankCode,
    required this.cbsBranchCode,
    required this.email,
    required this.branchId,
    required this.latitude,
    required this.longitude,
    required this.nchl,
    required this.fax,
    required this.telephoneNumber,
    required this.branchManager,
    required this.createdDate,
  });

  factory InternalBranch.fromJson(Map<String, dynamic> json) => InternalBranch(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        branchCode: json["branchCode"],
        bank: json["bank"],
        city: json["city"],
        checker: json["checker"],
        maker: json["maker"],
        state: json["state"],
        bankId: json["bankId"],
        bankCode: json["bankCode"],
        cbsBranchCode: json["cbsBranchCode"],
        email: json["email"],
        branchId: json["branchId"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        nchl: json["nchl"],
        fax: json["fax"],
        telephoneNumber: json["telephoneNumber"],
        branchManager: json["branchManager"],
        createdDate: DateTime.parse(json["createdDate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "branchCode": branchCode,
        "bank": bank,
        "city": city,
        "checker": checker,
        "maker": maker,
        "state": state,
        "bankId": bankId,
        "bankCode": bankCode,
        "cbsBranchCode": cbsBranchCode,
        "email": email,
        "branchId": branchId,
        "latitude": latitude,
        "longitude": longitude,
        "nchl": nchl,
        "fax": fax,
        "telephoneNumber": telephoneNumber,
        "branchManager": branchManager,
        "createdDate": createdDate.toIso8601String(),
      };
}
