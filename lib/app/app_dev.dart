import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/service/config_service.dart';

class AppDev extends StatelessWidget {
  final Widget home;
  const AppDev({super.key, required this.home});

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
        title: "Ismart Web - ${config.coopName}",
        home: home,
        // onGenerateRoute: RoutesGenerator.generateRoute,
      ),
    );
  }
}
