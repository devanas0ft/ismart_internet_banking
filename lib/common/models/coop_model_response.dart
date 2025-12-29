class CoopModelResponse {
  String? code;
  String? status;
  String? message;
  Detail? detail;

  CoopModelResponse({this.code, this.status, this.message, this.detail});

  CoopModelResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    detail =
        json['detail'] != null ? new Detail.fromJson(json['detail']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.detail != null) {
      data['detail'] = this.detail!.toJson();
    }
    return data;
  }
}

class Detail {
  String? name;
  String? themeColorPrimary;
  String? themeColorSecondary;
  String? themeColorTertiary;
  String? bannerUrl;
  String? logoUrl;
  String? iconUrl;
  String? clientID;
  String? clientSecret;
  String? apkUrl;
  String? address;
  String? contactNumber;
  String? facebookUrl;
  String? registerUrl;
  String? email;
  String? websiteUrl;

  Detail(
      {this.name,
      this.themeColorPrimary,
      this.themeColorSecondary,
      this.themeColorTertiary,
      this.bannerUrl,
      this.logoUrl,
      this.iconUrl,
      this.clientID,
      this.clientSecret,
      this.apkUrl,
      this.address,
      this.contactNumber,
      this.facebookUrl,
      this.registerUrl,
      this.email,
      this.websiteUrl});

  Detail.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    themeColorPrimary = json['themeColorPrimary'];
    themeColorSecondary = json['themeColorSecondary'];
    themeColorTertiary = json['themeColorTertiary'];
    bannerUrl = json['bannerUrl'];
    logoUrl = json['logoUrl'];
    iconUrl = json['iconUrl'];
    clientID = json['clientID'];
    clientSecret = json['clientSecret'];
    apkUrl = json['apkUrl'];
    address = json['address'];
    contactNumber = json['contactNumber'];
    facebookUrl = json['facebookUrl'];
    registerUrl = json['registerUrl'];
    email = json['email'];
    websiteUrl = json['websiteUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['themeColorPrimary'] = this.themeColorPrimary;
    data['themeColorSecondary'] = this.themeColorSecondary;
    data['themeColorTertiary'] = this.themeColorTertiary;
    data['bannerUrl'] = this.bannerUrl;
    data['logoUrl'] = this.logoUrl;
    data['iconUrl'] = this.iconUrl;
    data['clientID'] = this.clientID;
    data['clientSecret'] = this.clientSecret;
    data['apkUrl'] = this.apkUrl;
    data['address'] = this.address;
    data['contactNumber'] = this.contactNumber;
    data['facebookUrl'] = this.facebookUrl;
    data['registerUrl'] = this.registerUrl;
    data['email'] = this.email;
    data['websiteUrl'] = this.websiteUrl;
    return data;
  }
}
