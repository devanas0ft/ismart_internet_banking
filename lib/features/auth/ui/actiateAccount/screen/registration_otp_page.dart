import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/auth/ui/actiateAccount/cubit/reset_otp_register_cubit.dart';
import 'package:ismart_web/features/auth/ui/actiateAccount/resources/reset_otp_register_repository.dart';
import 'package:ismart_web/features/auth/ui/actiateAccount/widget/registration_otp_widget.dart';
import 'package:ismart_web/features/auth/ui/resetPin/cubit/reset_pin_cubit.dart';
import 'package:ismart_web/features/auth/ui/resetPin/resources/reset_pin_repository.dart';

class RegisterOtpPage extends StatelessWidget {
  final String mobileNumber;
  final String accountNumber;

  const RegisterOtpPage({
    super.key,
    required this.mobileNumber,
    required this.accountNumber,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => ResetPinCubit(
                resetPinRepository: RepositoryProvider.of<ResetPinRepository>(
                  context,
                ),
              ),
        ),
        BlocProvider(
          create:
              (context) => ResetOtpRegistrationCubit(
                resetOtpRegisterRepository:
                    RepositoryProvider.of<ResetOtpRegisterRepository>(context),
              ),
        ),
      ],
      child: RegisterOtpWidget(
        accountNumber: accountNumber,
        mobileNumber: mobileNumber,
      ),
    );
  }
}
