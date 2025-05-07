class CustomerDetailModel {
  String fullName;
  String addressOne;
  String mobileNumber;
  String firstName;
  String addressTwo;
  String middleName;
  String lastName;
  String city;
  String state;
  String email;
  String bank;
  String bankBranch;
  bool alertType;
  bool mobileBanking;
  bool smsService;
  String bankBranchCode;
  bool appVerification;
  bool beneficiaryFlag;
  String deviceToken;
  String bankCode;
  List<AccountDetail> accountDetail;
  int oauthTokenCount;
  bool firebaseToken;
  String gender;
  DateTime? dateOfBirth;
  String otpString;
  bool bankTransferOtp;
  int unseenNotificationCount;
  bool registered;
  String imageUrl;
  bool instaLoanEnable;

  CustomerDetailModel({
    required this.fullName,
    required this.addressOne,
    required this.mobileNumber,
    required this.firstName,
    required this.addressTwo,
    required this.middleName,
    required this.lastName,
    required this.city,
    required this.state,
    required this.email,
    required this.bank,
    required this.bankBranch,
    required this.alertType,
    required this.mobileBanking,
    required this.smsService,
    required this.bankBranchCode,
    required this.appVerification,
    required this.beneficiaryFlag,
    required this.deviceToken,
    required this.bankCode,
    required this.accountDetail,
    required this.oauthTokenCount,
    required this.firebaseToken,
    required this.gender,
    this.dateOfBirth,
    required this.otpString,
    required this.bankTransferOtp,
    required this.unseenNotificationCount,
    required this.registered,
    required this.imageUrl,
    required this.instaLoanEnable,
  });

  factory CustomerDetailModel.fromJson(Map<String, dynamic> json) =>
      CustomerDetailModel(
        fullName: json["fullName"] ?? "",
        addressOne: json["addressOne"] ?? "",
        mobileNumber: json["mobileNumber"] ?? "",
        firstName: json["firstName"] ?? "",
        addressTwo: json["addressTwo"] ?? "",
        middleName: json["middleName"] ?? "",
        lastName: json["lastName"] ?? "",
        city: json["city"] ?? "",
        state: json["state"] ?? "",
        email: json["email"] ?? "",
        bank: json["bank"] ?? "",
        bankBranch: json["bankBranch"] ?? "",
        alertType: json["alertType"],
        mobileBanking: json["mobileBanking"],
        smsService: json["smsService"],
        bankBranchCode: json["bankBranchCode"] ?? "",
        appVerification: json["appVerification"],
        beneficiaryFlag: json["beneficiaryFlag"],
        deviceToken: json["deviceToken"] ?? "",
        bankCode: json["bankCode"] ?? "",
        accountDetail: List<AccountDetail>.from(
            json["accountDetail"].map((x) => AccountDetail.fromJson(x))),
        oauthTokenCount: json["oauthTokenCount"],
        firebaseToken: json["firebaseToken"],
        gender: json["gender"],
        dateOfBirth: json["dateOfBirth"] != null
            ? DateTime.parse(json["dateOfBirth"])
            : null,
        otpString: json["otpString"],
        bankTransferOtp: json["bankTransferOtp"],
        unseenNotificationCount: json["unseenNotificationCount"],
        registered: json["registered"],
        imageUrl: _getUserImageUrl(json),
        instaLoanEnable: json['instaLoanEnable'] ?? false,
      );

  static String _getUserImageUrl(Map<String, dynamic> json) {
    String _url = "";

    final String _clippedUrl = json['imageUrl'] ?? "";

    if (_clippedUrl.isNotEmpty) {
      _url = "https://ismart.devanasoft.com.np" + _clippedUrl;
    }
    return _url;
  }

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "addressOne": addressOne,
        "mobileNumber": mobileNumber,
        "firstName": firstName,
        "addressTwo": addressTwo,
        "middleName": middleName,
        "lastName": lastName,
        "city": city,
        "state": state,
        "email": email,
        "bank": bank,
        "bankBranch": bankBranch,
        "alertType": alertType,
        "mobileBanking": mobileBanking,
        "smsService": smsService,
        "bankBranchCode": bankBranchCode,
        "appVerification": appVerification,
        "beneficiaryFlag": beneficiaryFlag,
        "deviceToken": deviceToken,
        "bankCode": bankCode,
        "accountDetail":
            List<dynamic>.from(accountDetail.map((x) => x.toJson())),
        "oauthTokenCount": oauthTokenCount,
        "firebaseToken": firebaseToken,
        "gender": gender,
        "dateOfBirth": dateOfBirth?.toIso8601String() ?? "",
        "otpString": otpString,
        "bankTransferOtp": bankTransferOtp,
        "unseenNotificationCount": unseenNotificationCount,
        "registered": registered,
        "instaLoanEnable": instaLoanEnable,
      };
}

class AccountDetail {
  String interestRate;
  String accountType;
  String accountTypeDescription;

  String branchName;
  String accruedInterest;
  String accountNumber;
  String accountHolderName;
  String availableBalance;
  String branchCode;
  String mainCode;
  String minimumBalance;
  String clientCode;
  String actualBalance;
  String mobileBanking;
  String sms;
  String id;
  String primary;

  AccountDetail({
    required this.interestRate,
    required this.accountType,
    required this.branchName,
    required this.accruedInterest,
    required this.accountNumber,
    required this.accountHolderName,
    required this.availableBalance,
    required this.branchCode,
    required this.mainCode,
    required this.minimumBalance,
    required this.clientCode,
    required this.actualBalance,
    required this.mobileBanking,
    required this.sms,
    required this.id,
    required this.accountTypeDescription,
    required this.primary,
  });

  factory AccountDetail.fromJson(Map<String, dynamic> json) => AccountDetail(
        interestRate: json["interestRate"] ?? "",
        accountType: json["accountType"] ?? "",
        accountTypeDescription: json["accountTypeDescription"] ?? "",
        branchName: json["branchName"] ?? "",
        accruedInterest: json["accruedInterest"] ?? "",
        accountNumber: json["accountNumber"] ?? "",
        accountHolderName: json["accountHolderName"] ?? "",
        availableBalance: json["availableBalance"] ?? "",
        branchCode: json["branchCode"] ?? "",
        mainCode: json["mainCode"] ?? "",
        minimumBalance: json["minimumBalance"] ?? "",
        clientCode: json["clientCode"] ?? "",
        actualBalance: json["actualBalance"] ?? "",
        mobileBanking: json["mobileBanking"] ?? "",
        sms: json["sms"] ?? "",
        id: json["id"] ?? "",
        primary: json["primary"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "interestRate": interestRate,
        "accountType": accountType,
        "accountTypeDescription": accountTypeDescription,
        "branchName": branchName,
        "accruedInterest": accruedInterest,
        "accountNumber": accountNumber,
        "accountHolderName": accountHolderName,
        "availableBalance": availableBalance,
        "branchCode": branchCode,
        "mainCode": mainCode,
        "minimumBalance": minimumBalance,
        "clientCode": clientCode,
        "actualBalance": actualBalance,
        "mobileBanking": mobileBanking,
        "sms": sms,
        "id": id,
        "primary": primary,
      };
}
