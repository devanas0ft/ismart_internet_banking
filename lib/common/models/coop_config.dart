import 'package:flutter/material.dart';

class CoOperative {
  String baseUrl;
  String clientCode;
  String clientSecret;
  String coOperativeName;
  String bannerImage;
  String coOperativeLogo;
  String splashImage;
  Color primaryColor;
  String backgroundImage;
  String appStoreID;
  String packageName;
  String appTitle;
  String channelPartner;
  bool shouldValidateCooperative;

  CoOperative({
    required this.clientCode,
    required this.clientSecret,
    required this.coOperativeName,
    required this.bannerImage,
    this.coOperativeLogo = 'assets/images/ismart_logo_only.png',
    this.baseUrl = 'https://ismart.devanasoft.com.np/',
    // this.baseUrl = 'http://localhost:3000/',
    this.splashImage = 'assets/images/ismart_splash.png',
    this.primaryColor = const Color(0xFF010C80),
    this.backgroundImage = 'assets/images/ismart_background_image.jpg',
    this.appStoreID = 'com.devanasoft.ismart',
    this.packageName = 'com.devanasoft.ismart',
    this.appTitle = 'Ismart',
    this.channelPartner = "",
    this.shouldValidateCooperative = false,
  });

  factory CoOperative.defaultConfig() {
    // return CoOperative(
    //   coOperativeName: 'ismart',
    //   bannerImage: 'assets/images/ismart_banner.png',
    //   clientCode: 'EHVNI7CZJ3',
    //   clientSecret: '126489',
    //   primaryColor: Color(0xFF010C80),
    //   coOperativeLogo: 'assets/images/ismart_logo_only.png',
    //   appStoreID: 'com.devanasoft.ismart',
    //   appTitle: 'iSmart Devanasoft',
    //   backgroundImage: 'assets/images/ismart_background_image.jpg',
    //   packageName: 'com.devanasoft.ismart',
    //   splashImage: '',
    //   channelPartner: '',
    // );
    return CoOperative(
      coOperativeName: 'shubhasandesh',
      bannerImage: 'assets/images/shubhasandesh_banner.png',
      clientCode: 'JCJY7XP42T',
      clientSecret: '149163',
      primaryColor: Color(0xFF0A1172),
      coOperativeLogo: 'assets/images/ismart_logo_only.png',
      appStoreID: 'com.devanasoft.ismart',
      appTitle: 'iSmart Devanasoft',
      backgroundImage: 'assets/images/ismart_background_image.jpg',
      packageName: 'com.devanasoft.ismart',
      splashImage: '',
      channelPartner: '',
    );
  }

  CoOperative copyWith({
    String? coOperativeName,
    String? bannerImage,
    String? clientCode,
    String? clientSecret,
    Color? primaryColor,
  }) {
    return CoOperative(
      coOperativeName: coOperativeName ?? this.coOperativeName,
      bannerImage: bannerImage ?? this.bannerImage,
      clientCode: clientCode ?? this.clientCode,
      clientSecret: clientSecret ?? this.clientSecret,
      primaryColor: primaryColor ?? this.primaryColor,
    );
  }
}
