import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/more/transactionLimit/transaction_progress_component.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class TransactionProgressPage extends StatelessWidget {
  final String title;
  final String profileType;
  final bool isOpen;
  final bool persistOpen;
  const TransactionProgressPage({
    super.key,
    required this.title,
    required this.profileType,
    this.persistOpen = false,
    this.isOpen = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => UtilityPaymentCubit(
            utilityPaymentRepository:
                RepositoryProvider.of<UtilityPaymentRepository>(context),
          ),
      child: TransactionProgressComponent(
        title: title,
        profileType: profileType,
        isOpen: isOpen,
        persistOpen: persistOpen,
      ),
    );
  }
}
