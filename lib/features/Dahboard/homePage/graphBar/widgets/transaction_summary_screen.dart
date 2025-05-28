import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/widget/common_loading_widget.dart';
import 'package:ismart_web/features/Dahboard/homePage/graphBar/widgets/balance_card.dart';
import 'package:ismart_web/features/Dahboard/homePage/graphBar/widgets/graph_box.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class TransactionSummaryScreen extends StatefulWidget {
  const TransactionSummaryScreen({super.key});

  @override
  State<TransactionSummaryScreen> createState() =>
      _TransactionSummaryScreenState();
}

class _TransactionSummaryScreenState extends State<TransactionSummaryScreen> {
  bool isMonthlyView = true;

  List<double> monthlyData = [
    500.0,
    200.0,
    320.0,
    320.0,
    430.0,
    320.0,
    300.0,
    320.0,
    120.0,
    320.0,
    320.0,
    320.0,
    320.0,
    320.0,
    320.0,
    320.0,
    320.0,
    320.0,
    320.0,
    320.0,
    320.0,
    320.0,
    320.0,
    320.0,
    320.0,
    320.0,
    320.0,
    320.0,
    320.0,
    320.0,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UtilityPaymentCubit, CommonState>(
      builder: (context, state) {
        if (state is CommonStateSuccess<UtilityResponseData>) {
          final data = state.data.findValue(primaryKey: "balanceList");
          List<double> monthsData = [];
          double openingbalacne = state.data.findValue(
            primaryKey: "openingBalance",
          );
          double closingbalance = state.data.findValue(
            primaryKey: "closingBalance",
          );

          for (int i = 0; i < data.length; i++) {
            final item = data[i];
            monthsData.add((item['balance'] ?? 0.0).toDouble());
          }

          return GraphBox(
            monthlyData: monthsData,
            openingBalance: openingbalacne.toString(),
            closingBalance: closingbalance.toString(),
          );
        } else if (state is CommonLoading) {
          // return SizedBox(height: 330, child: const CommonLoadingWidget());
          return GraphBox(
            monthlyData: monthlyData,
            openingBalance: 'Loading....',
            closingBalance: 'Loading....',
          );
        } else {
          return GraphBox(
            monthlyData: monthlyData,
            openingBalance: 'Not Data',
            closingBalance: 'No Data',
          );
        }
      },
    );
  }
}
