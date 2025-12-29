// import 'dart:html' as html;
import 'package:flutter/material.dart';
// import 'package:web/web.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/models/coop_model_response.dart';
import 'package:ismart_web/features/splash/resource/startup_repository.dart';

class ConfigService {
  static final ConfigService _instance = ConfigService._internal();

  factory ConfigService() => _instance;

  ConfigService._internal();

  CoOperative? _currentConfig;

  bool _isInitialized = false;

  CoOperative get config => _currentConfig ?? CoOperative.defaultConfig();

  bool get isInitialized => _isInitialized;

   void setConfig(CoOperative config) {
    _currentConfig = config;
    _isInitialized = true;
  }
  Future<dynamic> initialize(){
     if (_isInitialized && _currentConfig != null) {
      return Future.value(_currentConfig);
     }
     return Future.value('Coop is not configured');
  }

  // Future<CoOperative> initialize() async {
  //   if (_isInitialized && _currentConfig != null) {
  //     return _currentConfig!;
  //   }
  //   return config;
  // }

  void clearConfig() {
    _currentConfig = null;
    _isInitialized = false;
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
      default:
        return CoOperative.defaultConfig();
    }
  }
}
