import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ismart_web/app/app_dev.dart';
import 'package:ismart_web/features/auth/ui/screens/login_screen.dart';

import 'common/utils/log.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      runApp(AppDev(home: LoginScreen()));
    },
    (e, s) {
      Log.e(e);
      Log.d(s);
    },
  );
}
