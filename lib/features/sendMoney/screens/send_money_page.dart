import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/appServiceManagement/resource/app_service_repository.dart';
import 'package:ismart_web/features/sendMoney/widget/send_money_widget.dart';

import '../../appServiceManagement/cubit/app_service_cubit.dart';

class SendMoneyPage extends StatelessWidget {
  const SendMoneyPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => AppServiceCubit(
            appServiceRepository: RepositoryProvider.of<AppServiceRepository>(
              context,
            ),
          ),
      child: SendMoneyWidget(),
    );
  }
}
