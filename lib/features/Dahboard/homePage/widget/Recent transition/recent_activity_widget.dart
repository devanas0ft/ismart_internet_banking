import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/widget/no_data_screen.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/features/history/cubit/recent_transaction_cubit.dart';
import 'package:ismart_web/features/history/models/recent_transaction_model.dart';

class RecentActivityTable extends StatefulWidget {
  const RecentActivityTable({super.key});
  @override
  State<RecentActivityTable> createState() => _RecentActivityTableState();
}

class _RecentActivityTableState extends State<RecentActivityTable> {
  DateTime toDate = DateTime.now();
  DateTime fromDate = DateTime.now().subtract(const Duration(days: 30));
  int activeIndex = 0;
  final List<String> _tabs = ['Full Statement', 'Recent Activity'];

  @override
  void initState() {
    super.initState();
    getRecentTransaction(fromDate, toDate);
  }

  getRecentTransaction(DateTime fromDatee, DateTime toDatee) {
    context.read<RecentTransactionCubit>().fetchrecentTransaction(
      fromDate: "${fromDate.year}-${fromDate.month}-${fromDate.day}",
      toDate: "${toDate.year}-${toDate.month}-${toDate.day}",
      serviceCategoryId: "",
      associatedId: "",
      serviceId: "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: CustomTheme.white,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: CustomTheme.darkGray,
              ),
            ),
          ),
          Container(
            color: Colors.blue.shade50,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: const [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Service Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Transferred to/from',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Through',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Amount',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          BlocConsumer<RecentTransactionCubit, CommonState>(
            listener: (context, state) {
              if (state is CommonLoading) {
                showLoadingDialogBox(context);
              } else if (state is! CommonLoading) {}
            },
            builder: (context, state) {
              if (state is CommonDataFetchSuccess<RecentTransactionModel>) {
                return SizedBox(
                  height: 300,
                  child: ListView.separated(
                    itemCount: state.data.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = state.data[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                item.service,
                                style: TextStyle(
                                  fontSize: 10,

                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(flex: 2, child: Text(item.destination)),
                            Expanded(flex: 2, child: Text(item.accountNumber)),
                            Expanded(
                              flex: 1,
                              child: Text(
                                item.amount.toString(),
                                style: TextStyle(
                                  color: item.debit ? Colors.red : Colors.green,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              } else {
                return SizedBox(
                  height: 300,
                  child: NoDataScreen(
                    title: "No transactions yet.",
                    details:
                        "Could not find transaction for date ${fromDate.year}-${fromDate.month}-${fromDate.day} to ${toDate.year}-${toDate.month}-${toDate.day}",
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
