import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/service/config_service.dart';
import 'package:ismart_web/features/appServiceManagement/resource/app_service_repository.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';
import 'package:ismart_web/features/splash/cubit/startup_cubit.dart';
import 'package:ismart_web/features/splash/loader_screen.dart';
import 'package:ismart_web/features/splash/resource/startup_repository.dart';

class LoaderPage extends StatefulWidget {
  const LoaderPage({super.key});

  @override
  State<LoaderPage> createState() => _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Add your initialization logic here
     if (!ConfigService().isInitialized) {
      _showConfigError();
      return;
    }
  }
  void _showConfigError() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 8),
              Text('Configuration Required'),
            ],
          ),
          content: const Text(
            'The application configuration could not be loaded. '
            'Please restart the application and ensure you have an active internet connection.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Restart app or navigate back to initial screen
                Navigator.of(context).pop();
                // You might want to implement app restart logic here
              },
              child: const Text('Restart App'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => StartupCubit(
            appServiceRepository: RepositoryProvider.of<AppServiceRepository>(
              context,
            ),
            startUpRepository: RepositoryProvider.of<StartUpRepository>(
              context,
            ),
            userRepository: RepositoryProvider.of<UserRepository>(context),
          )..fetchStartupData(),
      child: LoaderScreen(),
    );
  }
}
