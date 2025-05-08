import 'dart:html' as html;
import 'package:flutter/material.dart';
// import 'package:web/web.dart';
import 'package:ismart_web/common/models/coop_config.dart';

class ConfigService {
  static final ConfigService _instance = ConfigService._internal();

  factory ConfigService() => _instance;

  ConfigService._internal();

  CoopConfig? _currentConfig;

  CoopConfig get config => _currentConfig ?? CoopConfig.defaultConfig();

  Future<CoopConfig> initialize() async {
    final uri = Uri.parse(html.window.location.href);

    final pathSegments = uri.pathSegments;

    String? coopName;
    if (pathSegments.isNotEmpty) {
      coopName = pathSegments.first;
    }

    _currentConfig = await _loadConfigForCoop(coopName);

    return config;
  }

  Future<CoopConfig> _loadConfigForCoop(String? coopName) async {
    if (coopName == null || coopName.isEmpty) {
      return CoopConfig.defaultConfig();
    }

    switch (coopName.toLowerCase()) {
      case 'shubhasandesh':
        return const CoopConfig(
          coopName: 'shubhasandesh',
          bannerImagePath: 'assets/images/shubhasandesh_banner.png',
          clientKey: 'JCJY7XP42T',
          clientSecret: '149163',
          primaryColor: Color(0xFF0A1172),
        );
      case 'bhimad':
        return const CoopConfig(
          coopName: 'bhimad',
          bannerImagePath: 'assets/images/bhimad_banner.png',
          clientKey: '01O76FM7KC',
          clientSecret: '186933',
          primaryColor: Color(0xFF006837),
        );
      case 'aadarsha':
        return const CoopConfig(
          coopName: 'aadarsha',
          bannerImagePath: 'assets/images/aadarsha_banner.png',
          clientKey: '6LDSFON6DI',
          clientSecret: '219548',
          primaryColor: Color(0xFFF44336),
        );
      default:
        return CoopConfig.defaultConfig();
    }

    // In a real application, you might want to fetch this data from an API
    // return await _fetchConfigFromApi(coopName);
  }

  // Example method to fetch configuration from an API
  // Future<CoopConfig> _fetchConfigFromApi(String coopName) async {
  //   // Implement API call to get coop configuration
  //   // Return the fetched configuration or default if not found
  // }
}
