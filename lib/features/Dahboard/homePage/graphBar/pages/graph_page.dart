import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/Dahboard/homePage/graphBar/widgets/transaction_summary_screen.dart';
import 'package:ismart_web/features/customerDetail/model/customer_detail_model.dart';

import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class GraphPage extends StatelessWidget {
  final CustomerDetailModel customer;
  const GraphPage({super.key, required this.customer});

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
              "accountNumber":
                  customer.accountDetail.firstOrNull?.accountNumber ?? "",
            },
            apiEndpoint: "api/graph/balance",
          ),
      child: const TransactionSummaryScreen(),
    );
  }
}
