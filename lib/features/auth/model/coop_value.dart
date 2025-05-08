class LoginCoOpValue {
  final String clientId;
  final String clientSecret;
  final String bank;
  final String logo;
  final String banner;

  LoginCoOpValue({
    required this.clientId,
    required this.clientSecret,
    required this.bank,
    required this.logo,
    required this.banner,
  });

  factory LoginCoOpValue.fromJson(Map<String, dynamic> json) => LoginCoOpValue(
        clientId: json["clientId"] ?? "",
        clientSecret: json["clientSecret"] ?? "",
        bank: json["bank"] ?? "",
        logo: json["logo"] ?? "",
        banner: json["banner"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "clientId": clientId,
        "clientSecret": clientSecret,
        "bank": bank,
        "logo": logo,
        "banner": banner,
      };
}
