import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/service/config_service.dart';
import 'package:ismart_web/features/auth/ui/screens/login_screen.dart';

class LoaderScreen extends StatefulWidget {
  const LoaderScreen({Key? key}) : super(key: key);

  @override
  State<LoaderScreen> createState() => _LoaderScreenState();
}

class _LoaderScreenState extends State<LoaderScreen> {
  late Future<CoopConfig> _configFuture;

  @override
  void initState() {
    super.initState();
    _configFuture = ConfigService().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CoopConfig>(
      future: _configFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Loading configuration...'),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 60),
                  SizedBox(height: 20),
                  Text('Error loading configuration'),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _configFuture = ConfigService().initialize();
                      });
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final config = ConfigService().config;
            CustomTheme().initializeTheme(config.primaryColor);
            Future.delayed(const Duration(seconds: 5), () {
              final config = ConfigService().config;
              CustomTheme().initializeTheme(config.primaryColor);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            });
          });

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
