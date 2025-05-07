import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/no_data_screen.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/transaction_detail_box.dart';
import 'package:ismart_web/features/history/cubit/receipt_download_cubit.dart';
import 'package:ismart_web/features/history/cubit/recent_transaction_cubit.dart';
import 'package:ismart_web/features/history/models/recent_transaction_model.dart';
import 'package:ismart_web/features/history/widget/transaction_detail_widget.dart';

class RecentTransactionWidget extends StatefulWidget {
  const RecentTransactionWidget({Key? key}) : super(key: key);

  @override
  State<RecentTransactionWidget> createState() =>
      _RecentTransactionWidgetState();
}

class _RecentTransactionWidgetState extends State<RecentTransactionWidget> {
  DateTime toDate = DateTime.now();
  DateTime fromDate = DateTime.now().subtract(const Duration(days: 7));

  DateTime filtertoDate = DateTime.now();
  DateTime filterfromDate = DateTime.now().subtract(const Duration(days: 90));
  @override
  void initState() {
    super.initState();
    getRecentTransaction(fromDate, toDate);
  }

  int currentIndex = 0;

  getRecentTransaction(DateTime fromDatee, DateTime toDatee) {
    context.read<RecentTransactionCubit>().fetchrecentTransaction(
      fromDate: "${fromDate.year}-${fromDate.month}-${fromDate.day}",
      toDate: "${toDate.year}-${toDate.month}-${toDate.day}",
      serviceCategoryId: "",
      associatedId: "",
      serviceId: "",
    );
  }

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final _width = SizeUtils.width;
    final _height = SizeUtils.height;
    return PageWrapper(
      padding: EdgeInsets.zero,
      showAppBar: false,
      body: CommonContainer(
        showDetail: false,
        showBackBotton: false,
        showRoundBotton: false,
        showTitleText: false,
        topbarName: "Recent Transaction",
        body: Column(
          children: [
            Container(
              height: 40.hp,
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: predefinedPeriods.length,
                      itemBuilder:
                          (context, index) => predefinedPeriodButton(
                            predefinedPeriods[index],
                            currentIndex == index,
                          ),
                      scrollDirection: Axis.horizontal,
                      physics: const AlwaysScrollableScrollPhysics(),
                    ),
                  ),
                  InkWell(
                    onTap: showFilterDialog,
                    child: Container(
                      height: _height * 0.04,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color:
                              currentIndex == -1
                                  ? _theme.primaryColor
                                  : Colors.black54,
                        ),
                      ),
                      margin: const EdgeInsets.only(left: 5),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Text(
                            "Filter",
                            style: _textTheme.labelLarge!.copyWith(
                              color:
                                  currentIndex == -1
                                      ? _theme.primaryColor
                                      : Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: _width * 0.02),
                          SvgPicture.asset(
                            Assets.filterIcon,
                            height: _height * 0.025,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.hp),
            BlocConsumer<RecentTransactionCubit, CommonState>(
              listener: (context, state) {
                if (state is CommonLoading && !_isLoading) {
                  _isLoading = true;
                  showLoadingDialogBox(context);
                } else if (state is! CommonLoading && _isLoading) {
                  _isLoading = false;
                  NavigationService.pop();
                }
              },
              builder: (context, state) {
                final ValueNotifier<String> _downloadNotifierValue =
                    ValueNotifier("");
                if (state is CommonDataFetchSuccess<RecentTransactionModel>) {
                  return BlocListener<TransactionDownloadCubit, CommonState>(
                    listener: (context, state) {
                      if (state is CommonStateSuccess) {
                        _downloadNotifierValue.value = state.data;
                      }
                    },
                    child: Column(
                      children: [
                        ListView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.data.length,
                          itemBuilder: (context, index) {
                            final _detail = state.data[index];
                            return TransactionDetailBox(
                              recentTransactionModel: _detail,
                              onClickAction: () {
                                context
                                    .read<TransactionDownloadCubit>()
                                    .generateUrl(
                                      transactionId:
                                          _detail.transactionIdentifier,
                                    );
                                NavigationService.push(
                                  target: TransactionDetailPage(
                                    downloadUrlNotifier: _downloadNotifierValue,
                                    recentTransactionModel: _detail,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                } else {
                  return NoDataScreen(
                    title: "No transactions yet.",
                    details:
                        "Could not find transaction for date ${fromDate.year}-${fromDate.month}-${fromDate.day} to ${toDate.year}-${toDate.month}-${toDate.day}",
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showFilterDialog() async {
    DateTime tempFromDate = filterfromDate;
    DateTime tempToDate = filtertoDate;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Select Date",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      readOnly: true,
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: tempFromDate,
                          firstDate: DateTime(2021),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            tempFromDate = picked;
                            if (tempToDate.difference(tempFromDate).inDays >
                                90) {
                              tempToDate = tempFromDate.add(
                                const Duration(days: 90),
                              );
                            }
                          });
                        }
                      },
                      title: "From Date",
                      hintText:
                          "${tempFromDate.year}-${tempFromDate.month}-${tempFromDate.day}",
                      showSuffixImage: true,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      readOnly: true,
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: tempToDate,
                          firstDate: tempFromDate,
                          lastDate: tempFromDate.add(const Duration(days: 90)),
                        );
                        if (picked != null) {
                          setState(() {
                            tempToDate = picked;
                          });
                        }
                      },
                      title: "To Date",
                      hintText:
                          "${tempToDate.year}-${tempToDate.month}-${tempToDate.day}",
                      showSuffixImage: true,
                    ),
                    const SizedBox(height: 24),
                    CustomRoundedButtom(
                      title: "View",
                      onPressed: () {
                        setState(() {
                          filterfromDate = tempFromDate;
                          filtertoDate = tempToDate;
                          fromDate = filterfromDate;
                          toDate = filtertoDate;
                          currentIndex = -1; // Custom range selected
                        });
                        getRecentTransaction(fromDate, toDate);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  final List<int> predefinedPeriods = [7, 15, 30, 60];
  Widget predefinedPeriodButton(int days, bool isSelected) {
    return CustomRoundedButtom(
      color: CustomTheme.primaryColor.withOpacity(isSelected ? 1 : 0.5),
      title: "$days days",
      onPressed: () => selectPredefinedPeriod(days),
      fontSize: 11,
    );
  }

  void selectPredefinedPeriod(int days) {
    setState(() {
      toDate = DateTime.now();
      fromDate = toDate.subtract(Duration(days: days));
      currentIndex = predefinedPeriods.indexOf(days);
    });
    getRecentTransaction(fromDate, toDate);
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:ismart/app/theme.dart';
// import 'package:ismart/common/common/data_state.dart';
// import 'package:ismart/common/constant/assets.dart';
// import 'package:ismart/common/navigation/navigation_service.dart';
// import 'package:ismart/common/util/size_utils.dart';
// import 'package:ismart/common/widget/common_button.dart';
// import 'package:ismart/common/widget/common_container.dart';
// import 'package:ismart/common/widget/common_text_field.dart';
// import 'package:ismart/common/widget/no_data_screen.dart';
// import 'package:ismart/common/widget/page_wrapper.dart';
// import 'package:ismart/common/widget/show_loading_dialog.dart';
// import 'package:ismart/common/widget/transaction_detail_box.dart';
// import 'package:ismart/feature/history/cubit/receipt_download_cubit.dart';
// import 'package:ismart/feature/history/cubit/recent_transaction_cubit.dart';
// import 'package:ismart/feature/history/models/recent_transaction_model.dart';
// import 'package:ismart/feature/history/widget/transaction_detail_widget.dart';

// class RecentTransactionWidget extends StatefulWidget {
//   const RecentTransactionWidget({Key? key}) : super(key: key);

//   @override
//   State<RecentTransactionWidget> createState() =>
//       _RecentTransactionWidgetState();
// }

// class _RecentTransactionWidgetState extends State<RecentTransactionWidget> {
//   DateTime toDate = DateTime.now();
//   DateTime fromDate = DateTime.now().subtract(const Duration(days: 7));

//   DateTime filtertoDate = DateTime.now();
//   DateTime filterfromDate = DateTime.now().subtract(const Duration(days: 90));
//   @override
//   void initState() {
//     super.initState();
//     getRecentTransaction(fromDate, toDate);
//   }

//   int currentIndex = 0;

//   getRecentTransaction(DateTime fromDatee, DateTime toDatee) {
//     context.read<RecentTransactionCubit>().fetchrecentTransaction(
//         fromDate: "${fromDate.year}-${fromDate.month}-${fromDate.day}",
//         toDate: "${toDate.year}-${toDate.month}-${toDate.day}",
//         serviceCategoryId: "",
//         associatedId: "",
//         serviceId: "");
//   }

//   bool _isLoading = false;
//   @override
//   Widget build(BuildContext context) {
//     final _theme = Theme.of(context);
//     final _textTheme = _theme.textTheme;
//     final _width = SizeUtils.width;
//     final _height = SizeUtils.height;
//     return PageWrapper(
//       padding: EdgeInsets.zero,
//       showAppBar: false,
//       body: CommonContainer(
//         showDetail: false,
//         showBackBotton: false,
//         showRoundBotton: false,
//         showTitleText: false,
//         topbarName: "Recent Transaction",
//         body: Column(
//           children: [
//             Container(
//               height: 40.hp,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: daysCount.length,
//                       itemBuilder: (context, index) => dateFilterButton(
//                           isSelected: currentIndex == index ? false : true,
//                           title: daysCount[index].toString() + " days",
//                           onPressed: () {
//                             getRecentTransaction(
//                                 fromDate
//                                     .subtract(Duration(days: daysCount[index])),
//                                 toDate);
//                             setState(() {
//                               currentIndex = index;
//                             });
//                           }),
//                       scrollDirection: Axis.horizontal,
//                       physics: const AlwaysScrollableScrollPhysics(),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       showDialog(
//                         context: context,
//                         builder: (context) {
//                           return StatefulBuilder(
//                             builder: (context, setState) {
//                               return AlertDialog(
//                                 actionsPadding: EdgeInsets.zero,
//                                 actions: [
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(18),
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(18.0),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "Filter",
//                                             style: _textTheme.labelLarge!
//                                                 .copyWith(
//                                                     fontSize: 18,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                           ),
//                                           CustomTextField(
//                                             customHintTextStyle: true,
//                                             readOnly: true,
//                                             onTap: () async {
//                                               final DateTime? picked =
//                                                   await showDatePicker(
//                                                       context: context,
//                                                       initialDate:
//                                                           filterfromDate,
//                                                       firstDate:
//                                                           DateTime(2000, 8),
//                                                       lastDate: DateTime.now());
//                                               setState(() {
//                                                 filterfromDate = picked!;
//                                               });
//                                             },
//                                             showSuffixImage: true,
//                                             title: "From Date",
//                                             hintText:
//                                                 "${filterfromDate.year}-${filterfromDate.month}-${filterfromDate.day}",
//                                           ),
//                                           CustomTextField(
//                                             showSuffixImage: true,
//                                             customHintTextStyle: true,
//                                             readOnly: true,
//                                             hintText:
//                                                 "${filtertoDate.year}-${filtertoDate.month}-${filtertoDate.day}",
//                                             title: "To Date",
//                                             onTap: () async {
//                                               final DateTime? picked =
//                                                   await showDatePicker(
//                                                       context: context,
//                                                       initialDate: filtertoDate,
//                                                       firstDate: filterfromDate
//                                                           .subtract(
//                                                               const Duration(
//                                                                   days: 90)),
//                                                       lastDate: DateTime.now());
//                                               setState(() {
//                                                 filtertoDate = picked!;
//                                               });
//                                             },
//                                           ),
//                                           CustomRoundedButtom(
//                                             title: "View",
//                                             onPressed: () {
//                                               getRecentTransaction(
//                                                   fromDate, toDate);
//                                               NavigationService.pop();
//                                               currentIndex = 5;
//                                             },
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         },
//                       );
//                     },
//                     child: Container(
//                       height: _height * 0.04,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(6),
//                           border: Border.all(
//                               color: fromDate != DateTime.now()
//                                   ? Colors.black54
//                                   : _theme.primaryColor)),
//                       margin: const EdgeInsets.only(left: 5),
//                       padding: const EdgeInsets.all(4),
//                       child: Row(
//                         children: [
//                           Text(
//                             "Filter",
//                             style: _textTheme.labelLarge!.copyWith(
//                                 color: fromDate != DateTime.now()
//                                     ? Colors.black54
//                                     : _theme.primaryColor,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(width: _width * 0.02),
//                           SvgPicture.asset(
//                             Assets.filterIcon,
//                             height: _height * 0.025,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10.hp),
//             BlocConsumer<RecentTransactionCubit, CommonState>(
//               listener: (context, state) {
//                 if (state is CommonLoading && !_isLoading) {
//                   _isLoading = true;
//                   showLoadingDialogBox(context);
//                 } else if (state is! CommonLoading && _isLoading) {
//                   _isLoading = false;
//                   NavigationService.pop();
//                 }
//               },
//               builder: (context, state) {
//                 print("state iss $state");
//                 final ValueNotifier<String> _downloadNotifierValue =
//                     ValueNotifier("");
//                 if (state is CommonDataFetchSuccess<RecentTransactionModel>) {
//                   return BlocListener<TransactionDownloadCubit, CommonState>(
//                     listener: (context, state) {
//                       if (state is CommonStateSuccess) {
//                         _downloadNotifierValue.value = state.data;
//                       }
//                     },
//                     child: Column(
//                       children: [
//                         ListView.builder(
//                           physics: const ScrollPhysics(),
//                           shrinkWrap: true,
//                           itemCount: state.data.length,
//                           itemBuilder: (context, index) {
//                             final _detail = state.data[index];
//                             return TransactionDetailBox(
//                               recentTransactionModel: _detail,
//                               onClickAction: () {
//                                 context
//                                     .read<TransactionDownloadCubit>()
//                                     .generateUrl(
//                                       transactionId:
//                                           _detail.transactionIdentifier,
//                                     );

//                                 NavigationService.push(
//                                     target: TransactionDetailWidget(
//                                   downloadUrlNotifier: _downloadNotifierValue,
//                                   recentTransactionModel: _detail,
//                                 ));
//                               },
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   );
//                 } else {
//                   return NoDataScreen(
//                     title: "No transactions yet.",
//                     details:
//                         "Could not find transaction for date ${fromDate.year}-${fromDate.month}-${fromDate.day} to ${toDate.year}-${toDate.month}-${toDate.day}",
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   final List daysCount = [7, 15, 30, 60];

//   dateFilterButton(
//       {required String title,
//       required Function() onPressed,
//       required bool isSelected}) {
//     return InkWell(
//       child: CustomRoundedButtom(
//         color: CustomTheme.primaryColor.withOpacity(isSelected ? 0.5 : 1),
//         title: title,
//         onPressed: onPressed,
//         fontSize: 11,
//       ),
//     );
//   }
// }
