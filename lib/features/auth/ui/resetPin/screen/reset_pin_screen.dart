import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/auth/ui/resetPin/cubit/reset_pin_cubit.dart';
import 'package:ismart_web/features/auth/ui/resetPin/resources/reset_pin_repository.dart';
import 'package:ismart_web/features/auth/ui/resetPin/widget/reset_pin_widget.dart';

class ResetPinPage extends StatelessWidget {
  const ResetPinPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => ResetPinCubit(
            resetPinRepository: RepositoryProvider.of<ResetPinRepository>(
              context,
            ),
          ),
      child: ResetPinWidget(),
    );
  }
}
