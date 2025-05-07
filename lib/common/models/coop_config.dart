import 'package:flutter/material.dart';

class CoopConfig {
  final String coopName;
  final String bannerImagePath;
  final String clientKey;
  final String clientSecret;
  final Color primaryColor;

  const CoopConfig({
    required this.coopName,
    required this.bannerImagePath,
    required this.clientKey,
    required this.clientSecret,
    required this.primaryColor,
  });

  factory CoopConfig.defaultConfig() {
    return const CoopConfig(
      coopName: 'ismart',
      bannerImagePath: 'assets/images/ismart_banner.png',
      clientKey: 'default_client_key',
      clientSecret: 'default_client_secret',
      primaryColor: Color(0xFF1976D2),
    );
  }

  CoopConfig copyWith({
    String? coopName,
    String? bannerImagePath,
    String? clientKey,
    String? clientSecret,
    Color? primaryColor,
  }) {
    return CoopConfig(
      coopName: coopName ?? this.coopName,
      bannerImagePath: bannerImagePath ?? this.bannerImagePath,
      clientKey: clientKey ?? this.clientKey,
      clientSecret: clientSecret ?? this.clientSecret,
      primaryColor: primaryColor ?? this.primaryColor,
    );
  }
}
