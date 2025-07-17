import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/service/config_service.dart';
import 'package:ismart_web/features/Dahboard/widgets/dashboard_widget.dart';
import 'package:ismart_web/features/auth/ui/screens/login_page.dart';
import 'package:ismart_web/features/customerDetail/cubit/customer_detail_cubit.dart';
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
    super.initState();
    CustomTheme().initializeTheme(_configFuture.primaryColor);
  }

  @override
  Widget build(BuildContext context) {
    bool isUserLogged = false;
    return BlocListener<StartupCubit, StartupState>(
      listener: (context, state) {
        if (state is StartupSuccess) {
          isUserLogged = state.isLogged;
          context.read<CustomerDetailCubit>().fetchCustomerDetail(
            isCalledAtStatup: true,
          );
        }
      },
      child: BlocListener<CustomerDetailCubit, CommonState>(
        listener: (context, customerState) {
          if (customerState is CommonStateSuccess) {
            NavigationService.pushReplacement(target: const DashboardWidget());
          } else if (customerState is CommonError) {
            NavigationService.pushReplacement(target: LoginPage());
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Center(child: Image.asset('assets/loader.gif')),
          ),
        ),
      ),
    );
  }
}
