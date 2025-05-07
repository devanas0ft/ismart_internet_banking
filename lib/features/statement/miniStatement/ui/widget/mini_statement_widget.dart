import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/customerDetail/model/customer_detail_model.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/statement/miniStatement/cubit/mini_statement_cubit.dart';
import 'package:ismart_web/features/statement/miniStatement/models/mini_statement_model.dart';

class MiniStatementWidget extends StatefulWidget {
  const MiniStatementWidget({Key? key}) : super(key: key);

  @override
  State<MiniStatementWidget> createState() => _MiniStatementWidgetState();
}

class _MiniStatementWidgetState extends State<MiniStatementWidget> {
  ValueNotifier<MiniStatementModel?> miniStatementDetail = ValueNotifier(null);
  ValueNotifier<CustomerDetailModel?> customerDetail = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    customerDetail =
        RepositoryProvider.of<CustomerDetailRepository>(
          context,
        ).customerDetailModel;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // ignore: unused_local_variable
      final cubit = context.read<MiniStatementCubit>().fetchMiniStatement(
        accountNumbner:
            RepositoryProvider.of<CustomerDetailRepository>(
              context,
            ).selectedAccount.value!.accountNumber,
      );
    });
  }

  bool sortList = true;
  getList({required List dataList}) {
    return sortList == true ? dataList.reversed.toList() : dataList;
  }

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final selectedAccount =
        RepositoryProvider.of<CustomerDetailRepository>(
          context,
        ).selectedAccount.value;
    final _width = SizeUtils.width;
    final _height = SizeUtils.height;
    return PageWrapper(
      body: CommonContainer(
        onButtonPressed: () {
          NavigationService.pushReplacement(target: Container());
        },
        showRoundBotton: false,
        verticalPadding: 0,
        topbarName: "Mini Statement",
        horizontalPadding: 0,
        showDetail: false,
        body: BlocConsumer<MiniStatementCubit, CommonState>(
          listener: (context, state) {
            if (state is CommonLoading && !_isLoading) {
              _isLoading = true;
              showLoadingDialogBox(context);
            } else if (state is! CommonLoading && _isLoading) {
              _isLoading = false;
              NavigationService.pop();
            }

            if (state is CommonError) {
              showPopUpDialog(
                context: context,
                message: state.message,
                title: "Error",
                showCancelButton: false,
                buttonCallback: () {
                  NavigationService.pop();
                },
              );
            }
          },
          builder: (context, state) {
            if (state is CommonStateSuccess<MiniStatementModel>) {
              final res = state.data.ministatementList;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // InkWell(
                  //   onTap: () {
                  //     setState(() {
                  //       shotList = !shotList;
                  //     });
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  //     child: SvgPicture.asset(Assets.sortICon, height: 20),
                  //   ),
                  // ),
                  ValueListenableBuilder<CustomerDetailModel?>(
                    valueListenable: customerDetail,
                    builder: (context, val, _) {
                      if (val != null) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Account No. ${selectedAccount!.mainCode}",
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.titleLarge,
                                        ),
                                      ),
                                      SizedBox(width: 15.wp),
                                      Text(
                                        "Sorting",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          letterSpacing: 0.3,
                                          color: CustomTheme.primaryColor,
                                        ),
                                      ),
                                      Switch(
                                        activeColor: CustomTheme.primaryColor,
                                        value: sortList,
                                        onChanged: (value) {
                                          setState(() {
                                            sortList = !sortList;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: _height * 0.01),
                                  Container(
                                    padding: const EdgeInsets.all(18),
                                    width: double.infinity,
                                    height: _height * 0.11,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color:
                                          Theme.of(
                                            context,
                                          ).scaffoldBackgroundColor,
                                      border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Available Balance",
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.titleLarge,
                                            ),
                                            Text(
                                              "NPR ${selectedAccount.availableBalance}",
                                              style: TextStyle(
                                                fontFamily: "popinBold",
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Actual Balance",
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.titleLarge,
                                            ),
                                            Text(
                                              "NPR ${selectedAccount.actualBalance}",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "popinBold",
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: _height * 0.02),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  if (state.data.ministatementList.isNotEmpty)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        sortAscending: false,
                        columnSpacing: _width / 5,
                        headingRowHeight: 40,
                        dataTextStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                        headingRowColor: const MaterialStatePropertyAll(
                          Colors.black12,
                        ),
                        columns: const [
                          DataColumn(
                            label: Text(
                              "Date",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Amount",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Status",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                        rows:
                            List.from(getList(dataList: res))
                                .map(
                                  (e) => DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                          "${e.transactionDate.toString().substring(0, 10)}\n${e.transactionDate.toString().substring(10)}",
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      // DataCell(Text(
                                      //     "${e.transactionDate.year}-${e.transactionDate.month}-${e.transactionDate.day}")),
                                      DataCell(
                                        Text(
                                          e.amount.toString(),
                                          style: TextStyle(
                                            color:
                                                e.credit
                                                    ? Colors.green
                                                    : Colors.red,
                                          ),
                                        ),
                                      ),

                                      DataCell(
                                        Text(
                                          e.credit ? "Deposit" : "Withdrawl",
                                          style: TextStyle(
                                            color:
                                                e.credit
                                                    ? Colors.green
                                                    : Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  if (state.data.ministatementList.isEmpty)
                    Container(
                      child: const Center(
                        child: Text(
                          "No data found.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
