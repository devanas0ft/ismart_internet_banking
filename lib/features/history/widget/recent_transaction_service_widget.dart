import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/features/history/cubit/receipt_download_cubit.dart';
import 'package:ismart_web/features/history/cubit/recent_transaction_cubit.dart';
import 'package:ismart_web/features/history/models/recent_transaction_model.dart';
import 'package:ismart_web/features/history/widget/transaction_detail_box_service.dart';

import '../../../common/app/navigation_service.dart';

class RecentTransactionServiceWidget extends StatefulWidget {
  final String serviceCategoryId;
  final String associatedId;
  final String service;
  final String serviceId;
  final VoidCallback onListTap;

  final Function(RecentTransactionModel) onRecentTransactionPressed;

  const RecentTransactionServiceWidget({
    Key? key,
    required this.serviceCategoryId,
    required this.associatedId,
    required this.service,
    required this.onRecentTransactionPressed,
    required this.onListTap,
    required this.serviceId,
  }) : super(key: key);

  @override
  State<RecentTransactionServiceWidget> createState() =>
      _RecentTransactionServiceWidgetState();
}

class _RecentTransactionServiceWidgetState
    extends State<RecentTransactionServiceWidget> {
  @override
  void initState() {
    super.initState();
    context.read<RecentTransactionCubit>().fetchrecentTransaction(
      serviceId: widget.serviceId,
      associatedId: widget.associatedId,
      service: widget.service,
      serviceCategoryId: widget.serviceCategoryId,
    );
  }

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;
    return BlocConsumer<RecentTransactionCubit, CommonState>(
      listener: (context, state) {
        if (state is CommonLoading && !_isLoading) {
          _isLoading = true;
          showLoadingDialogBox(context);
        } else if (state is! CommonLoading && _isLoading) {
          _isLoading = false;
          NavigationService.pop();
        }

        // if (state is CommonError) {
        //   showPopUpDialog(
        //     context: context,
        //     message: state.message,
        //     title: "Error",
        //     showCancelButton: false,
        //     buttonCallback: () {
        //       NavigationService.pop();
        //     },
        //   );
        // }
      },
      builder: (context, state) {
        final ValueNotifier<String> _downloadNotifierValue = ValueNotifier("");
        if (state is CommonDataFetchSuccess<RecentTransactionModel>) {
          return BlocListener<TransactionDownloadCubit, CommonState>(
            listener: (context, state) {
              if (state is CommonStateSuccess) {
                _downloadNotifierValue.value = state.data;
              }
            },
            child: ListView.builder(
              padding: const EdgeInsets.only(right: 10),
              scrollDirection: Axis.vertical,
              physics: const ClampingScrollPhysics(),
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                final _detail = state.data[index];
                return TransactionDetailBoxService(
                  onClickAction: () {
                    widget.onListTap();
                    widget.onRecentTransactionPressed(_detail);
                  },
                  recentTransactionModel: _detail,
                  // onClickAction: () {
                  //   context.read<TransactionDownloadCubit>().generateUrl(
                  //         transactionId: _detail.transactionIdentifier,
                  //       );
                  //   showDialog(
                  //     context: context,
                  //     builder: (context) {
                  //       return Dialog(
                  //         insetPadding:
                  //             const EdgeInsets.symmetric(horizontal: 18),
                  //         child: Container(
                  //           padding: const EdgeInsets.symmetric(vertical: 10),
                  //           width: double.infinity,
                  //           // height: _height * 0.5,
                  //           child: TransactionDetailAlertWidget(
                  //             recentTransactionModel: _detail,
                  //             downloadUrlNotifier: _downloadNotifierValue,
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   );
                  //   // NavigationService.push(
                  //   //   target: TransactionDetailScreen(
                  //   //     recentTransactionModel: _detail,
                  //   //   ),
                  //   // );
                  // },
                );
              },
            ),
          );
        } else {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, color: CustomTheme.spanishGray, size: 32),
                Text(
                  'There is no transaction yet.',
                  style: TextStyle(
                    fontSize: 16,
                    color: CustomTheme.spanishGray,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
