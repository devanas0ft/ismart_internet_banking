// // lib/main.dart or wherever AppDev is used

// // import 'dart:ffi';

// import 'package:flutter/material.dart';
// import 'package:ismart_web/common/app/navigation_service.dart';
// import 'package:ismart_web/common/app/theme.dart';
// import 'package:ismart_web/common/http/api_provider.dart';
// import 'package:ismart_web/common/http/response.dart';
// import 'package:ismart_web/common/models/coop_config.dart';
// import 'package:ismart_web/common/models/coop_model_response.dart';
// import 'package:ismart_web/common/service/config_service.dart';
// import 'package:ismart_web/common/shared_pref.dart';
// import 'package:ismart_web/common/utils/hive_utils.dart';
// import 'package:ismart_web/common/wrapper/multi_bloc_wrapper.dart';
// import 'package:ismart_web/common/wrapper/multi_repo_wrapper.dart';
// import 'package:ismart_web/features/auth/resources/user_repository.dart';
// import 'package:ismart_web/features/splash/resource/loader_page.dart';
// import 'package:ismart_web/features/splash/resource/startup_repository.dart';
// import 'package:local_session_timeout/local_session_timeout.dart';

// class AppDev extends StatefulWidget {
//   final Widget home;
//   const AppDev({super.key, required this.home});

//   @override
//   State<AppDev> createState() => _AppDevState();
// }

// class _AppDevState extends State<AppDev> {
//   SessionConfig? sessionConfig;
//   bool _isLoading = true;
//   String? _errorMessage;
//   CoOperative? _config;
//   final ValueNotifier<Detail?> _dynamicCoop = ValueNotifier(null);

//   @override
//   void initState() {
//     super.initState();
//     ServiceHiveUtils.init();
//     _initializeConfig();
//     _setupSessionTimeout();
//     fetchDynamicIcons();
//   }

//   Future<Detail?> fetchDynamicIcons() async {
//     try {
//       final dynamicCoop = await SharedPref.getDynamicCoopDetails();
//       if (dynamicCoop != null) {
//         _dynamicCoop.value = dynamicCoop;
//       }

//       print("Token------------------------------------------");
//       print(_dynamicCoop.value);
//     } on Exception catch (_) {
//       print('custom exception is been obtained');
//     }
//     return _dynamicCoop.value;
//   }

//   void _setupSessionTimeout() {
//     sessionConfig = SessionConfig(
//       invalidateSessionForAppLostFocus: const Duration(minutes: 2),
//       invalidateSessionForUserInactivity: const Duration(minutes: 2),
//     );
//     sessionConfig!.stream.listen((event) {
//       if (event == SessionTimeoutState.appFocusTimeout ||
//           event == SessionTimeoutState.userInactivityTimeout) {
//         NavigationService.pushReplacement(
//           target: const AppDev(home: LoaderPage()),
//         );
//       }
//     });
//   }

//   Future<void> _initializeConfig() async {
//     try {
//       // Create a temporary config for initial API call
//       final tempConfig = CoOperative.defaultConfig();

//       // Initialize repository with temp config
//       final startupRepo = StartUpRepository(
//         env: tempConfig,
//         userRepository: UserRepository(
//           apiProvider: ApiProvider(baseUrl: "https://ismart.devanasoft.com.np"),
//           env: tempConfig,
//         ),
//         apiProvider: ApiProvider(baseUrl: "https://ismart.devanasoft.com.np"),
//       );

//       // Fetch dynamic config from API
//       final response = await startupRepo.dynamicCoopConfig();

//       if (response.status == Status.Success && response.data != null) {
//         setState(() {
//           _config = fetchDynamicCoop();
//           _isLoading = false;
//           _errorMessage = null;
//         });
//       } else {
//         setState(() {
//           _errorMessage = response.message ?? "Failed to load configuration";
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = "Unable to initialize app: ${e.toString()}";
//         _isLoading = false;
//       });
//     }
//   }

//   fetchDynamicCoop() {
//     return CoOperative(
//       coOperativeName: _dynamicCoop.value!.name!.toLowerCase(),
//       baseUrl: 'https://ismart.devanasoft.com.np/',
//       bannerImage:
//           "https://ismart.devanasoft.com.np/${_dynamicCoop.value!.bannerUrl}",
//       backgroundImage:
//           "https://ismart.devanasoft.com.np/${_dynamicCoop.value!.iconUrl}",
//       clientCode: _dynamicCoop.value!.clientID!,
//       clientSecret: _dynamicCoop.value!.clientSecret!,
//       coOperativeLogo:
//           "https://ismart.devanasoft.com.np/${_dynamicCoop.value!.logoUrl}",
//       primaryColor: Color(int.parse(_dynamicCoop.value!.themeColorPrimary!)),
//     );
//   }

//   Future<void> _retryConfiguration() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });
//     await _initializeConfig();
//   }

//   @override
//   void dispose() {
//     ServiceHiveUtils.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: Scaffold(
//           body: Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [Color(0xFF1A9640), Color(0xFF0D5C28)],
//               ),
//             ),
//             child: const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                   ),
//                   SizedBox(height: 24),
//                   Text(
//                     'Loading Configuration...',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     }

//     if (_errorMessage != null) {
//       return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: Scaffold(
//           body: Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [Color(0xFFEF5350), Color(0xFFC62828)],
//               ),
//             ),
//             child: Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(24.0),
//                 child: Card(
//                   elevation: 8,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(32.0),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(
//                           Icons.error_outline,
//                           color: Colors.red,
//                           size: 64,
//                         ),
//                         const SizedBox(height: 24),
//                         const Text(
//                           'Configuration Error',
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           _errorMessage!,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.black54,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 32),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             ElevatedButton.icon(
//                               onPressed: _retryConfiguration,
//                               icon: const Icon(Icons.refresh),
//                               label: const Text('Retry'),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.green,
//                                 foregroundColor: Colors.white,
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 32,
//                                   vertical: 16,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         const Text(
//                           'Please check your internet connection and try again.',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.black38,
//                             fontStyle: FontStyle.italic,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
//     }

//     // Success - build the app with loaded config
//     return MultiRepositoryWrapper(
//       env: _config!,
//       child: MultiBlocWrapper(
//         env: _config!,
//         child: GestureDetector(
//           onTap: () {
//             final currentFocus = FocusScope.of(context);
//             if (!currentFocus.hasPrimaryFocus &&
//                 currentFocus.focusedChild != null) {
//               FocusManager.instance.primaryFocus?.unfocus();
//             }
//           },
//           behavior: HitTestBehavior.translucent,
//           child: MaterialApp(
//             locale: const Locale('en', 'US'),
//             navigatorKey: NavigationService.navigationKey,
//             debugShowCheckedModeBanner: false,
//             theme: CustomTheme.lightTheme,
//             darkTheme: CustomTheme.lightTheme,
//             themeMode: ThemeMode.system,
//             title: "Ismart Web - ${_config!.coOperativeName}",
//             home: widget.home,
//           ),
//         ),
//       ),
//     );
//   }
// }

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
