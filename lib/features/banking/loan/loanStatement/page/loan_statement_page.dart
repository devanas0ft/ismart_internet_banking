import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/banking/loan/loanStatement/widget/loan_statement_widget.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class LoanStatementPage extends StatelessWidget {
  final String loanAccountNumber;

  const LoanStatementPage({super.key, required this.loanAccountNumber});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => UtilityPaymentCubit(
            utilityPaymentRepository:
                RepositoryProvider.of<UtilityPaymentRepository>(context),
          ),
      child: LoanStatementWidget(loanAccountNumber: loanAccountNumber),
    );
  }
}
