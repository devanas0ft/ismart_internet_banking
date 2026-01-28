import 'package:flutter/material.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/models/coop_model_response.dart';
import 'package:ismart_web/common/shared_pref.dart';

enum ConfigLoadingState {
  uninitialized,
  loading,
  success,
  error,
}

class ConfigService {
  static final ConfigService _instance = ConfigService._internal();

  factory ConfigService() => _instance;

  ConfigService._internal();

  CoOperative? _currentConfig;
  ConfigLoadingState _state = ConfigLoadingState.uninitialized;
  String? _errorMessage;

  // Getters
  CoOperative? get config => _currentConfig;
  bool get isInitialized => _state == ConfigLoadingState.success;
  ConfigLoadingState get state => _state;
  String? get errorMessage => _errorMessage;

  // Set config after successful API call
  void setConfig(CoOperative config) {
    _currentConfig = config;
    _state = ConfigLoadingState.success;
    _errorMessage = null;
  }

  // Set loading state
  void setLoading() {
    _state = ConfigLoadingState.loading;
    _errorMessage = null;
  }

  // Set error state
  void setError(String error) {
    _state = ConfigLoadingState.error;
    _errorMessage = error;
    _currentConfig = null;
  }

  // Clear config (for logout or reset)
  void clearConfig() {
    _currentConfig = null;
    _state = ConfigLoadingState.uninitialized;
    _errorMessage = null;
  }

  // Check if valid config exists
  bool hasConfig() {
    return _currentConfig != null && _state == ConfigLoadingState.success;
  }

  // Try to load config from cache
  Future<CoOperative?> loadFromCache() async {
    try {
      final Detail? detail = await SharedPref.getDynamicCoopDetails();
      if (detail != null) {
        final config = _buildConfigFromDetail(detail);
        setConfig(config);
        return config;
      }
      return null;
    } catch (e) {
      print('Error loading config from cache: $e');
      return null;
    }
  }

  // Build CoOperative from Detail
  CoOperative _buildConfigFromDetail(Detail detail) {
    return CoOperative(
      coOperativeName: detail.name?.toLowerCase() ?? '',
      baseUrl: 'https://ismart.devanasoft.com.np/',
      bannerImage: "https://ismart.devanasoft.com.np/${detail.bannerUrl}",
      backgroundImage: "https://ismart.devanasoft.com.np/${detail.iconUrl}",
      clientCode: detail.clientID ?? '',
      clientSecret: detail.clientSecret ?? '',
      coOperativeLogo: "https://ismart.devanasoft.com.np/${detail.logoUrl}",
      primaryColor: Color(int.parse(detail.themeColorPrimary ?? '0xFF1A9640')),
    );
  }
}
// // import 'dart:html' as html;
// import 'package:flutter/material.dart';
// // import 'package:web/web.dart';
// import 'package:ismart_web/common/models/coop_config.dart';
// import 'package:ismart_web/common/models/coop_model_response.dart';
// import 'package:ismart_web/common/shared_pref.dart';
// import 'package:ismart_web/features/splash/resource/startup_repository.dart';

// enum ConfigLoadingState {
//   uninitialized,
//   loading,
//   success,
//   error,
// }

// class ConfigService {
//   // static final ConfigService _instance = ConfigService._internal();

//   // factory ConfigService() => _instance;

//   // ConfigService._internal();

//   // CoOperative? _currentConfig;

//   // bool _isInitialized = false;

//   // CoOperative get config => _currentConfig ?? CoOperative.defaultConfig();
//   // bool get isInitialized => _isInitialized;
//    static final ConfigService _instance = ConfigService._internal();

//   factory ConfigService() => _instance;

//   ConfigService._internal();

//   CoOperative? _currentConfig;
//   ConfigLoadingState _state = ConfigLoadingState.uninitialized;
//   String? _errorMessage;

//   CoOperative? get config => _currentConfig ?? getDynamicCatchCoopConfig() as CoOperative?;
//   bool get isInitialized => _state == ConfigLoadingState.success;
//   ConfigLoadingState get state => _state;
//   String? get errorMessage => _errorMessage;

// void setConfig(CoOperative config) {
//     _currentConfig = config;
//     _state = ConfigLoadingState.success;
//     _errorMessage = null;
//   }

//  void setLoading() {
//     _state = ConfigLoadingState.loading;
//     _errorMessage = null;
//   }

//   void setError(String error) {
//     _state = ConfigLoadingState.error;
//     _errorMessage = error;
//     _currentConfig = null;
//   }

//   void clearConfig() {
//     _currentConfig = null;
//     _state = ConfigLoadingState.uninitialized;
//     _errorMessage = null;
//   }

//   bool hasConfig() {
//     return _currentConfig != null && _state == ConfigLoadingState.success;
//   }
//   Future<CoOperative?> getDynamicCatchCoopConfig() async {
//     Detail? detail = await SharedPref.getDynamicCoopDetails();
//     if (detail != null) {
//       return CoOperative(
//         coOperativeName: detail.name!.toLowerCase(),
//       baseUrl: 'https://ismart.devanasoft.com.np/',
//       bannerImage: "https://ismart.devanasoft.com.np/${detail.bannerUrl}",
//       backgroundImage: "https://ismart.devanasoft.com.np/${detail.iconUrl}",
//       clientCode: detail.clientID!,
//       clientSecret: detail.clientSecret!,
//       coOperativeLogo: "https://ismart.devanasoft.com.np/${detail.logoUrl}",
//       primaryColor:  Color(int.parse(detail.themeColorPrimary!)),
//       );
//     } else {
//       throw Exception("No cooperative configuration found in cache.");
//     }
//   }

  //  void setConfig(CoOperative config) {
  //   _currentConfig = config;
  //   _isInitialized = true;
  // }
  // Future<CoOperative> initialize() async {
  //   if (_isInitialized && _currentConfig != null) {
  //     return _currentConfig!;
  //   }
  //   return config;
  // }
  // Future<CoOperative> initialize() async {
  //   if (_isInitialized && _currentConfig != null) {
  //     return _currentConfig!;
  //   }
  //   return config;
  // }

  // void clearConfig() {
  //   _currentConfig = null;
  //   _isInitialized = false;
  // }


  // Future<CoOperative> _loadConfigForCoop(String? coopName) async {
  //   if (coopName == null || coopName.isEmpty) {
  //     return CoOperative.defaultConfig();
  //   }

  //   switch (coopName.toLowerCase()) {
  //     case 'shubhasandesh':
  //       return CoOperative(
  //         coOperativeName: 'shubhasandesh',
  //         bannerImage: 'assets/images/shubhasandesh_banner.png',
  //         clientCode: 'JCJY7XP42T',
  //         clientSecret: '149163',
  //         primaryColor: Color(0xFF0A1172),
  //       );
  //     case 'bhimad':
  //       return CoOperative(
  //         coOperativeName: 'bhimad',
  //         bannerImage: 'assets/images/bhimad_banner.png',
  //         clientCode: '01O76FM7KC',
  //         clientSecret: '186933',
  //         primaryColor: Color(0xFF006837),
  //       );
  //     case 'aadarsha':
  //       return CoOperative(
  //         coOperativeName: 'aadarsha',
  //         bannerImage: 'assets/images/aadarsha_banner.png',
  //         clientCode: '6LDSFON6DI',
  //         clientSecret: '219548',
  //         primaryColor: Color(0xFFF44336),
  //       );
  //       case 'pacific':
  //       return CoOperative(
  //         coOperativeName: 'pacific',
  //         bannerImage: 'assets/images/pacific/pacific_banner.png',
  //         clientCode: 'M66VVYESH8',
  //        clientSecret: "126072",
  //         primaryColor: const Color(0xFF1A9640),
  //       );
  //     default:
  //       return CoOperative.defaultConfig();
  //   }
  // }
// }
