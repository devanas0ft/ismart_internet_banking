import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/Dahboard/homePage/widget/homepage_money_widget.dart';
import 'package:ismart_web/features/appServiceManagement/cubit/app_service_cubit.dart';
import 'package:ismart_web/features/appServiceManagement/resource/app_service_repository.dart';

class HomePageMoneyPage extends StatelessWidget {
  const HomePageMoneyPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => AppServiceCubit(
            appServiceRepository: RepositoryProvider.of<AppServiceRepository>(
              context,
            ),
          )..fetchAppService(),
      child: const HomePageMoneyWidget(),
    );
  }
}
