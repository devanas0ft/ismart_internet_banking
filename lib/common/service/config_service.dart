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

    // _currentConfig = await _loadConfigForCoop(coopName);

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
      default:
        return CoOperative.defaultConfig();
    }
  }
}
