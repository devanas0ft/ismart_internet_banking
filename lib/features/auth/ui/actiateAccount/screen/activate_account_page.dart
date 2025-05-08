import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/auth/ui/actiateAccount/widget/activate_account_widget.dart';
import 'package:ismart_web/features/auth/ui/resetPin/cubit/reset_pin_cubit.dart';
import 'package:ismart_web/features/auth/ui/resetPin/resources/reset_pin_repository.dart';

class ActivateAccountPage extends StatelessWidget {
  const ActivateAccountPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => ResetPinCubit(
            resetPinRepository: RepositoryProvider.of<ResetPinRepository>(
              context,
            ),
          ),
      child: ActivateAccountWidget(),
    );
  }
}
