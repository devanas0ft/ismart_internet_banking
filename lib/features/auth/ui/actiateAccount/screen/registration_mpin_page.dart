import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/auth/ui/actiateAccount/widget/registration_mpin_widget.dart';
import 'package:ismart_web/features/auth/ui/resetPin/cubit/reset_pin_cubit.dart';
import 'package:ismart_web/features/auth/ui/resetPin/resources/reset_pin_repository.dart';

class RegisterMpinPage extends StatelessWidget {
  final String mobileNumber;
  final String accountNumber;
  final String otp;

  const RegisterMpinPage({
    super.key,
    required this.mobileNumber,
    required this.accountNumber,
    required this.otp,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => ResetPinCubit(
            resetPinRepository: RepositoryProvider.of<ResetPinRepository>(
              context,
            ),
          ),
      child: RegisterMpinWidget(
        otp: otp,
        accountNumber: accountNumber,
        mobileNumber: mobileNumber,
      ),
    );
  }
}
