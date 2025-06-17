import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
