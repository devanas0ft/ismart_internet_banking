import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/more/transactionLimit/circular_indicator_widget.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class TransactionProgressComponent extends StatefulWidget {
  final String title;
  final String profileType;
  final bool isOpen;
  final bool persistOpen;
  const TransactionProgressComponent({
    super.key,
    required this.title,
    required this.profileType,
    required this.persistOpen,
    this.isOpen = false,
  });

  @override
  State<TransactionProgressComponent> createState() =>
      _TransactionProgressComponentState();
}

class _TransactionProgressComponentState
    extends State<TransactionProgressComponent>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  bool showCount = true;
  bool _isDialogVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    if (widget.isOpen) {
      setState(() {});
      onButtonPressed();
      _isExpanded = true;
    }
  }

  Widget _buildExpandedContent(UtilityResponseData response) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                showCount
                    ? MainAxisAlignment.spaceAround
                    : MainAxisAlignment.center,
            children: [
              if (showCount) ...[
                MyCircularBar(
                  centerText:
                      response.detail["usedDailyCount"]?.toString() ??
                      'No Data',
                  title: "Count",
                  maxLimit: "Max limit in count",
                  maxLimitVal:
                      response.detail["dailyCountLimit"]?.toString() ??
                      'No Data',
                  primaryText: "Count",
                  primaryDesc:
                      response.detail["usedDailyCount"]?.toString() ??
                      'No Data',
                  remainLimit: "Remaning Limit Count",
                  remainLimitVal:
                      response.detail["remainingDailyCount"]?.toString() ??
                      'No Data',
                  percent: convertToFraction(
                    double.parse(
                      response.detail["dailyCountLimit"]?.toString() ??
                          'No Data',
                    ),
                    double.parse(
                      response.detail["usedDailyCount"]?.toString() ??
                          'No Data',
                    ),
                  ),
                  color: CustomTheme.primaryColor,
                ),
                MyCircularBar(
                  centerText:
                      "${convertToFraction(double.parse(response.detail["dailyAmountLimit"]?.toString() ?? 'No Data'), double.parse(response.detail["usedDailyAmount"]?.toString() ?? 'No Data')) * 100}%",
                  title: "Amount Transfer",
                  maxLimit: "Max Amount Transfer",
                  maxLimitVal:
                      "${response.detail["dailyAmountLimit"]?.toString() ?? 'No Data'} per day",
                  primaryText: "Amount Transfer",
                  primaryDesc:
                      "NPR ${response.detail['usedDailyAmount']?.toString() ?? 'No Data'}",
                  remainLimit: "Remaining Amount Transfer",
                  remainLimitVal:
                      "NPR ${response.detail["remainingDailyAmount"]?.toString() ?? 'No Data'}",
                  percent: convertToFraction(
                    double.parse(
                      response.detail["dailyAmountLimit"]?.toString() ??
                          'No Data',
                    ),
                    double.parse(
                      response.detail["usedDailyAmount"]?.toString() ??
                          'No Data',
                    ),
                  ),
                  // percent: .4,
                  color: CustomTheme.primaryColor,
                  // color: CustomTheme.white,
                ),
              ],
              if (!showCount)
                MyCircularBar(
                  centerText:
                      "${convertToFraction(double.parse(response.detail["dailyAmountLimit"]?.toString() ?? 'No Data'), double.parse(response.detail["usedDailyAmount"]?.toString() ?? 'No Data')) * 100}%",
                  title: "Amount Transfer",
                  maxLimit: "Max Amount Transfer",
                  maxLimitVal:
                      "${response.detail["monthlyAmountLimit"]?.toString() ?? 'No Data'} per month",
                  primaryText: "Amount Transfer",
                  primaryDesc:
                      "NPR ${response.detail['usedMonthlyAmount']?.toString() ?? 'No Data'}",
                  remainLimit: "Remaining Amount Transfer",
                  remainLimitVal:
                      "NPR ${response.detail["remainingMonthlyAmount"]?.toString() ?? 'No Data'}",
                  percent: convertToFraction(
                    double.parse(
                      response.detail["monthlyAmountLimit"]?.toString() ??
                          'No Data',
                    ),
                    double.parse(
                      response.detail["usedMonthlyAmount"]?.toString() ??
                          'No Data',
                    ),
                  ),
                  // percent: .6,
                  color: CustomTheme.primaryColor,
                  //color: CustomTheme.white,
                ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomRoundedButtom(
                  title: "Monthly",
                  onPressed: () {
                    setState(() {
                      showCount = false;
                    });
                  },
                  color:
                      showCount
                          ? Colors.grey.shade400
                          : CustomTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 13,
                  ),
                ),
                CustomRoundedButtom(
                  title: "Daily",
                  onPressed: () {
                    setState(() {
                      showCount = true;
                    });
                  },
                  color:
                      showCount
                          ? CustomTheme.primaryColor
                          : Colors.grey.shade400,
                  fontWeight: FontWeight.bold,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 7),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.transparent,
                  border: Border.all(color: Colors.grey.withOpacity(.5)),
                ),
                alignment: Alignment.center,
                height: 20,
                width: 220,
                child: Text(
                  "Daily Transaction Limit: ${response.detail['perTransactionLimit']?.toString() ?? 'No Data'}",
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handleLoadingDialog(bool show) async {
    if (show && !_isDialogVisible) {
      _isDialogVisible = true;
      await showLoadingDialogBox(context);
    } else if (!show && _isDialogVisible) {
      _isDialogVisible = false;
      if (Navigator.canPop(context)) {
        NavigationService.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UtilityPaymentCubit, CommonState>(
      listener: (context, state) async {
        await _handleLoadingDialog(state is CommonLoading);

        if (state is CommonError) {
          await showPopUpDialog(
            context: context,
            message: state.message,
            title: "Error",
            showCancelButton: false,
            buttonCallback: () {
              if (Navigator.canPop(context)) {
                NavigationService.pop();
              }
            },
          );
        }
      },
      builder: (context, state) {
        UtilityResponseData? limitData;

        if (state is CommonStateSuccess<UtilityResponseData>) {
          final response = state.data;
          if (response.code == "M0000") {
            limitData = response;
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showPopUpDialog(
                context: context,
                message: response.message,
                title: "Error",
                buttonCallback: () {
                  if (Navigator.canPop(context)) {
                    NavigationService.pop();
                  }
                },
                showCancelButton: false,
              );
            });
          }
        }

        return Card(
          elevation: 0,
          borderOnForeground: false,
          color: Colors.white,
          child: InkWell(
            onTap: () {
              if (!widget.persistOpen) {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
                if (_isExpanded) {
                  onButtonPressed();
                }
              }
            },
            child: AnimatedSize(
              alignment: Alignment.topCenter,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned(
                        right: 20,
                        child: Container(
                          alignment: AlignmentDirectional.topEnd,
                          width: 20,
                          height: 20,
                          // color: Colors.pink,
                          child: Icon(
                            _isExpanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xff1c1c1c),
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 5),
                                Container(
                                  width: 90,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: CustomTheme.primaryColor.withOpacity(
                                      .7,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 3),
                                Container(
                                  width: 5,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: CustomTheme.primaryColor.withOpacity(
                                      .7,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Divider(
                          //   color: CustomTheme.primaryColor,
                          // ),
                          if (limitData != null)
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (
                                Widget child,
                                Animation<double> animation,
                              ) {
                                return SizeTransition(
                                  sizeFactor: animation,
                                  axisAlignment: -1.0,
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                );
                              },
                              child:
                                  _isExpanded
                                      ? KeyedSubtree(
                                        key: const ValueKey<String>('expanded'),
                                        child: _buildExpandedContent(limitData),
                                      )
                                      : const SizedBox.shrink(
                                        key: ValueKey<String>('collapsed'),
                                      ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void onButtonPressed() {
    context.read<UtilityPaymentCubit>().fetchDetails(
      serviceIdentifier: '',
      accountDetails: {
        "profileType": widget.profileType,
        "accountNumber":
            RepositoryProvider.of<CustomerDetailRepository>(
              context,
            ).selectedAccount.value!.accountNumber,
      },
      apiEndpoint: "api/limit",
    );
  }

  double convertToFraction(double total, double used) {
    return total > 0 ? (used / total) : 0;
  }
}
