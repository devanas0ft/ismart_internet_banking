import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/auth/ui/resetPin/cubit/reset_pin_cubit.dart';
import 'package:ismart_web/features/auth/ui/resetPin/resources/reset_pin_repository.dart';
import 'package:ismart_web/features/auth/ui/resetPin/widget/reset_otp_widget.dart';

class ResetOTPPage extends StatelessWidget {
  final String mobileNumber;
  const ResetOTPPage({Key? key, required this.mobileNumber}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => ResetPinCubit(
            resetPinRepository: RepositoryProvider.of<ResetPinRepository>(
              context,
            ),
          ),
      child: ResetOTPWidget(mobileNumber: mobileNumber),
    );
  }
}
