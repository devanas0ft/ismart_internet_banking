import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/categoryWiseService/internet/cg/widgets/cg_payment_widget.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class CgPaymentPage extends StatelessWidget {
  const CgPaymentPage({super.key, required this.service});
  final service;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => UtilityPaymentCubit(
            utilityPaymentRepository:
                RepositoryProvider.of<UtilityPaymentRepository>(context),
          ),
      child: CgPaymentWidget(service: service),
    );
  }
}
