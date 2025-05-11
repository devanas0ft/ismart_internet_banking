import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/service/config_service.dart';
import 'package:ismart_web/features/Dahboard/widgets/dashboard_widget.dart';
import 'package:ismart_web/features/auth/ui/screens/login_page.dart';
import 'package:ismart_web/features/splash/cubit/startup_cubit.dart';

class LoaderScreen extends StatefulWidget {
  const LoaderScreen({super.key});

  @override
  State<LoaderScreen> createState() => _LoaderScreenState();
}

class _LoaderScreenState extends State<LoaderScreen> {
  final _configFuture = ConfigService().config;

  @override
  void initState() {
    CustomTheme().initializeTheme(_configFuture.primaryColor);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StartupCubit, StartupState>(
      listener: (context, state) {
        if (state is StartupSuccess) {
          NavigationService.pushReplacement(target: const LoginPage());
          if (state.isLogged) {
            NavigationService.pushReplacement(target: const DashboardWidget());
          }
        }
      },
      child: Scaffold(
        body: SafeArea(
          // child: Center(
          //   child: CircularProgressIndicator(color: Colors.deepOrangeAccent),
          // ),
          child: Center(child: Image.asset('assets/loader.gif')),
        ),
      ),
    );
  }
}
