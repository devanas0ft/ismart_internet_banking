import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ismart_web/app/app_dev.dart';
import 'package:ismart_web/features/splash/loader_screen.dart';

import 'common/utils/log.dart';

Future<void> main() async {
  await EasyLocalization.ensureInitialized();
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      runApp(AppDev(home: LoaderScreen()));
    },
    (e, s) {
      Log.e(e);
      Log.d(s);
    },
  );
}
