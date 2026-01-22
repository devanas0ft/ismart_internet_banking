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
    return CoOperative(
      coOperativeName: 'Sadasya Sewa',
      bannerImage: 'assets/images/sadasyasewa_banner.png',
      clientCode: 'JY2BVRD208',
      clientSecret: '164786',
      primaryColor: Color(0xFF0072BB),
      // coOperativeName: 'pacific',
      // baseUrl: 'https://ismart.devanasoft.com.np/',
      // bannerImage: "assets/images/pacific/pacific_banner.png",
      // backgroundImage: "assets/images/pacific/pacific_background.png",
      // clientCode: 'M66VVYESH8',
      // clientSecret: "126072",
      // coOperativeLogo: 'assets/images/pacific/pacific_logo.png',
      // splashImage: "assets/images/pacific/pacific_splash.png",
      // primaryColor: const Color(0xFF1A9640),

      // appTitle: 'Pacific iSmart',
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
