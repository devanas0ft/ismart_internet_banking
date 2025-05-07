import 'package:flutter/material.dart';
import 'package:ismart_web/common/constants/assets.dart';

class CoOperative {
  CoOperative({
    required this.clientCode,
    required this.clientSecret,
    required this.coOperativeName,
    required this.bannerImage,
    required this.coOperativeLogo,
    required this.baseUrl,
    required this.splashImage,
    required this.primaryColor,
    required this.backgroundImage,
    required this.appStoreID,
    required this.packageName,
    required this.appTitle,
    this.channelPartner = "",
    this.shouldValidateCooperative = false,
  });

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

  CoOperative copyWith({required String clientCode}) {
    return CoOperative(
      clientCode: clientCode,
      clientSecret: clientSecret,
      coOperativeName: coOperativeName,
      bannerImage: bannerImage,
      coOperativeLogo: coOperativeLogo,
      baseUrl: baseUrl,
      splashImage: splashImage,
      primaryColor: primaryColor,
      backgroundImage: backgroundImage,
      appStoreID: appStoreID,
      packageName: packageName,
      appTitle: appTitle,
      channelPartner: channelPartner,
    );
  }
}

class CoOperativeValue {
  static const String baseUrl = "https://ismart.devanasoft.com.np/";

  static final CoOperative skJhurkiya = CoOperative(
    appStoreID: "",
    packageName: "com.devanasoft.skJhurkiya",
    baseUrl: 'https://ismart.devanasoft.com.np/',
    bannerImage: "assets/skJhurkiya/skJhurkiya_banner.png",
    backgroundImage: "assets/skJhurkiya/skJhurkiya_background.png",
    clientCode: 'AJ55922FRN',
    clientSecret: "117059",
    coOperativeLogo: 'assets/skJhurkiya/skJhurkiya_logo.png',
    splashImage: "assets/skJhurkiya/skJhurkiya_splash.png",
    primaryColor: const Color(0xFF009A4E),
    coOperativeName: "Sana Kisan Agriculture Cooperative Ltd Jhurkiya",
    appTitle: 'Jhurkiya SFACl iSmart',
  );
  static final CoOperative skShankharpur = CoOperative(
    appStoreID: "",
    packageName: "com.devanasoft.skShankharpur",
    baseUrl: 'https://ismart.devanasoft.com.np/',
    bannerImage: "assets/skShankharpur/skShankharpur_banner.png",
    backgroundImage: "assets/skShankharpur/skShankharpur_background.png",
    clientCode: '56ILOXKHY1',
    clientSecret: "214152",
    coOperativeLogo: 'assets/skShankharpur/skShankharpur_logo.png',
    splashImage: "assets/skShankharpur/skShankharpur_splash.png",
    primaryColor: const Color(0xFF009A4E),
    coOperativeName: "Sana Kisan Agriculture Cooperative Ltd Shankharpur",
    appTitle: 'Shankharpur SFACl iSmart',
  );

  static final CoOperative jharanaCoop = CoOperative(
    appStoreID: "com.devanasoft.jharana",
    packageName: "com.devanasoft.jharana",
    baseUrl: 'https://ismart.devanasoft.com.np/',
    bannerImage: "assets/jharana/jharana_banner.png",
    backgroundImage: "assets/jharana/jharana_background.png",
    clientCode: 'CTYB8TKXX0',
    clientSecret: "208577",
    coOperativeLogo: 'assets/jharana/jharana_logo.png',
    splashImage: "assets/jharana/jharana_splash.png",
    primaryColor: const Color(0xFF2C732E),
    coOperativeName: "Jharana Saving and Credit Cooperative Ltd",
    appTitle: 'Jharana iSmart',
  );

  //  DEV TEST700746
  static final CoOperative devLive = CoOperative(
    backgroundImage: "assets/images/ismart_background_image.jpg",
    bannerImage: "assets/images/ismart_banner.png",
    coOperativeLogo: Assets.ismartLogo,
    clientCode: 'EHVNI7CZJ3',
    clientSecret: "126489",
    splashImage: "assets/images/ismart_splash.png",
    primaryColor: const Color(0xFF010C80),
    baseUrl: 'https://ismart.devanasoft.com.np/',
    packageName: "com.devanasoft.ismart",
    appStoreID: "com.devanasoft.ismart",
    shouldValidateCooperative: true,
    coOperativeName: "ISMART DEMO APPKTM",
    appTitle: "iSmart Devanasoft",
  );

  static final CoOperative shubhaSandeshCoop = CoOperative(
    appStoreID: "com.devanasoft.subhaSandesh",
    packageName: "com.devanasoft.subhaSandesh",
    baseUrl: 'https://ismart.devanasoft.com.np/',
    bannerImage: "assets/shubhaSandesh/shubha_sandesh_banner.png",
    backgroundImage: "assets/shubhaSandesh/shubha_sandesh_background.png",
    clientCode: 'JCJY7XP42T',
    clientSecret: "149163",
    coOperativeLogo: 'assets/shubhaSandesh/shubha_sandesh_logo.png',
    splashImage: "assets/shubhaSandesh/shubha_sandesh_splash.png",
    primaryColor: const Color(0xFF0A1172),
    coOperativeName: "Shubha Sandesh Multipurpose Co-operative Ltd",
    appTitle: "Shubha Sandesh iSmart",
  );

  static CoOperative currentCoop = devLive;
  static void updateCurrentCoop(CoOperative newCoop) {
    currentCoop = newCoop;
  }
}
