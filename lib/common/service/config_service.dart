// import 'dart:html' as html;
import 'package:flutter/material.dart';
// import 'package:web/web.dart';
import 'package:ismart_web/common/models/coop_config.dart';

class ConfigService {
  static final ConfigService _instance = ConfigService._internal();

  factory ConfigService() => _instance;

  ConfigService._internal();

  CoOperative? _currentConfig;

  CoOperative get config => _currentConfig ?? CoOperative.defaultConfig();

  Future<CoOperative> initialize() async {
    // final uri = Uri.parse(html.window.location.href);

    // final pathSegments = uri.pathSegments;

    // String? coopName;
    // if (pathSegments.isNotEmpty) {
    //   coopName = pathSegments.first;
    // }

    _currentConfig = await _loadConfigForCoop('sadasyasewa');

    return config;
  }

  Future<CoOperative> _loadConfigForCoop(String? coopName) async {
    if (coopName == null || coopName.isEmpty) {
      return CoOperative.defaultConfig();
    }

    switch (coopName.toLowerCase()) {
      case 'shubhasandesh':
        return CoOperative(
          coOperativeName: 'shubhasandesh',
          bannerImage: 'assets/images/shubhasandesh_banner.png',
          clientCode: 'JCJY7XP42T',
          clientSecret: '149163',
          primaryColor: Color(0xFF0A1172),
        );
      case 'bhimad':
        return CoOperative(
          coOperativeName: 'bhimad',
          bannerImage: 'assets/images/bhimad_banner.png',
          clientCode: '01O76FM7KC',
          clientSecret: '186933',
          primaryColor: Color(0xFF006837),
        );
      case 'aadarsha':
        return CoOperative(
          coOperativeName: 'aadarsha',
          bannerImage: 'assets/images/aadarsha_banner.png',
          clientCode: '6LDSFON6DI',
          clientSecret: '219548',
          primaryColor: Color(0xFFF44336),
        );
      case 'pacific':
        return CoOperative(
          coOperativeName: 'pacific',
          bannerImage: 'assets/images/pacific/pacific_banner.png',
          clientCode: 'M66VVYESH8',
          clientSecret: "126072",
          primaryColor: const Color(0xFF1A9640),
        );
      case 'abhyudaya':
        return CoOperative(
          coOperativeName: 'Abhyudaya',
          baseUrl: 'https://ismart.devanasoft.com.np/',
          bannerImage: "assets/images/abhyudaya/abhyudaya_banner.png",
          backgroundImage: "assets/images/abhyudaya/abhyudaya_background.png",
          clientCode: 'QQ2D2C09VY',
          clientSecret: "112055",
          coOperativeLogo: 'assets/images/abhyudaya/abhyudaya_logo.png',
          splashImage: "assets/images/abhyudaya/abhyudaya_splash.png",
          primaryColor: const Color(0xFF1A9640),
          appTitle: 'Abhyudaya',
        );
      case 'sadasyasewa':
        return CoOperative(
          coOperativeName: 'Sadasya Sewa',
          baseUrl: 'https://ismart.devanasoft.com.np/',
          bannerImage: "assets/images/sadasya_sewa/sadasyasewa_banner.png",
          backgroundImage:
              "assets/images/sadasya_sewa/sadasyasewa_background.png",
          clientCode: 'JY2BVRD208',
          clientSecret: "164786",
          coOperativeLogo: 'assets/images/sadasya_sewa/sadasyasewa_logo.png',
          splashImage: "assets/images/sadasya_sewa/sadasyasewa_splash.png",
          primaryColor: const Color(0xFF1A9640),

          appTitle: 'Sadasya Sewa',
        );
      default:
        return CoOperative.defaultConfig();
    }
  }
}
