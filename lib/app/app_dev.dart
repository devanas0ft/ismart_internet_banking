import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/service/config_service.dart';
import 'package:ismart_web/common/utils/hive_utils.dart';
import 'package:ismart_web/common/wrapper/multi_bloc_wrapper.dart';
import 'package:ismart_web/common/wrapper/multi_repo_wrapper.dart';
import 'package:ismart_web/features/splash/resource/loader_page.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

class AppDev extends StatefulWidget {
  final Widget home;
  const AppDev({super.key, required this.home});

  @override
  State<AppDev> createState() => _AppDevState();
}

class _AppDevState extends State<AppDev> {
  late Future<CoOperative> _configFuture;
  SessionConfig? sessionConfig;

  @override
  void initState() {
    super.initState();
    ServiceHiveUtils.init();
    _configFuture = ConfigService().initialize();
    sessionConfig = SessionConfig(
      invalidateSessionForAppLostFocus: const Duration(minutes: 2),
      invalidateSessionForUserInactivity: const Duration(minutes: 2),
    );
    sessionConfig!.stream.listen((event) {
      if (event == SessionTimeoutState.appFocusTimeout ||
          event == SessionTimeoutState.userInactivityTimeout) {
        NavigationService.pushReplacement(
          target: const AppDev(home: LoaderPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    ServiceHiveUtils.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CoOperative>(
      future: _configFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.pink,
            child: const Center(
              child: CircularProgressIndicator(color: Colors.amber),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final config = snapshot.data!;
        return MultiRepositoryWrapper(
          env: config,
          child: MultiBlocWrapper(
            env: config,
            child: GestureDetector(
              onTap: () {
                final currentFocus = FocusScope.of(context);
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
              ),
            ),
          ),
        );
      },
    );
  }
}
