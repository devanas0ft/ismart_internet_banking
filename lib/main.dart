import 'dart:async';
import 'dart:io';

import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ismart_web/app/app_dev.dart';
import 'package:ismart_web/features/splash/resource/loader_page.dart';

import 'common/utils/log.dart';

Future<void> main() async {
  await EasyLocalization.ensureInitialized();
  runZonedGuarded(
    () async {
      HttpOverrides.global = MyHttpOverrides();
      WidgetsFlutterBinding.ensureInitialized();
      runApp(
        DevicePreview(
          enabled: !kReleaseMode,
          builder: (context) => AppDev(home: LoaderPage()),
        ),
      );
    },
    (e, s) {
      Log.e(e);
      Log.d(s);
    },
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
