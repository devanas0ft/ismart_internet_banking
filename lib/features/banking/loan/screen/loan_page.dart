import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/banking/loan/widget/loan_widget.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class LoanPage extends StatefulWidget {
  final String accountNumber;
  const LoanPage({Key? key, required this.accountNumber}) : super(key: key);

  @override
  State<LoanPage> createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => UtilityPaymentCubit(
            utilityPaymentRepository:
                RepositoryProvider.of<UtilityPaymentRepository>(context),
          )..fetchDetails(
            serviceIdentifier: "",
            accountDetails: {
              "accountNumber": widget.accountNumber,
              // "mPin": getMpin(),
            },
            shouldIncludeMPIN: true,
            apiEndpoint: "/api/loan/details",
          ),
      child: LoanWidget(loanAccountNumber: widget.accountNumber),
    );
  }
}
