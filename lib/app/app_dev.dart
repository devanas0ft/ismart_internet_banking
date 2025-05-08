import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/service/config_service.dart';
import 'package:ismart_web/common/utils/hive_utils.dart';

class AppDev extends StatefulWidget {
  final Widget home;
  const AppDev({super.key, required this.home});

  @override
  State<AppDev> createState() => _AppDevState();
}

class _AppDevState extends State<AppDev> {
  @override
  void initState() {
    ServiceHiveUtils.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final config = ConfigService().config;
    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      behavior: HitTestBehavior.translucent,
      child: MaterialApp(
        locale: const Locale('en', 'US'),
        navigatorKey: NavigationService.navigationKey,
        debugShowCheckedModeBanner: false,
        theme: CustomTheme.lightTheme,
        darkTheme: CustomTheme.lightTheme,
        themeMode: ThemeMode.system,
        title: "Ismart Web - ${config.coOperativeName}",
        home: widget.home,
        // onGenerateRoute: RoutesGenerator.generateRoute,
      ),
    );
  }
}
