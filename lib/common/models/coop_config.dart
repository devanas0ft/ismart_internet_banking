import 'package:flutter/material.dart';

class CoOperative {
  final String baseUrl;
  final String clientCode;
  final String clientSecret;
  final String coOperativeName;
  final String bannerImage;
  final String coOperativeLogo;
  final String splashImage;
  final Color primaryColor;
  final String backgroundImage;
  final String appStoreID;
  final String packageName;
  final String appTitle;
  final String channelPartner;
  final bool shouldValidateCooperative;

  const CoOperative({
    required this.clientCode,
    required this.clientSecret,
    required this.coOperativeName,
    required this.bannerImage,
    this.coOperativeLogo = 'assets/images/ismart_logo_only.png',
    this.baseUrl = 'https://ismart.devanasoft.com.np/',
    this.splashImage = 'assets/images/ismart_splash.png',
    this.primaryColor = const Color(0xFF010C80),
    this.backgroundImage = 'assets/images/ismart_background_image.jpg',
    this.appStoreID = '',
    this.packageName = '',
    this.appTitle = 'Ismart',
    this.channelPartner = "",
    this.shouldValidateCooperative = false,
  });

  factory CoOperative.defaultConfig() {
    return const CoOperative(
      coOperativeName: 'ismart',
      bannerImage: 'assets/images/ismart_banner.png',
      clientCode: 'EHVNI7CZJ3',
      clientSecret: '126489',
      primaryColor: Color(0xFF010C80),
      coOperativeLogo: '',
      baseUrl: '',
      appStoreID: '',
      appTitle: 'Ismart',
      backgroundImage: '',
      packageName: '',
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
