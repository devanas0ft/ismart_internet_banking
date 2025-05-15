import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/common_loading_widget.dart';
import 'package:ismart_web/common/widget/loan_key_value_tile.dart';
import 'package:ismart_web/common/widget/no_data_screen.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/features/banking/loan/loanSchedule/page/loan_schedule_page.dart';
import 'package:ismart_web/features/banking/loan/loanStatement/page/loan_statement_page.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class LoanWidget extends StatefulWidget {
  final String loanAccountNumber;

  const LoanWidget({super.key, required this.loanAccountNumber});

  @override
  State<LoanWidget> createState() => _LoanWidgetState();
}

class _LoanWidgetState extends State<LoanWidget> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchLoanDetails() async {
    // final String mPin = await SecureStorageService.appPassword;
    context.read<UtilityPaymentCubit>().fetchDetails(
      serviceIdentifier: "",
      accountDetails: {
        "accountNumber":
            RepositoryProvider.of<CustomerDetailRepository>(
              context,
            ).selectedAccount.value!.accountNumber,
        "mPin": '778899',
      },
      apiEndpoint: "api/loan/details",
    );
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    return PageWrapper(
      body: CommonContainer(
        title: "Loan Information",
        showRoundBotton: false,
        body: BlocBuilder<UtilityPaymentCubit, CommonState>(
          builder: (context, state) {
            if (state is CommonStateSuccess<UtilityResponseData>) {
              final UtilityResponseData response = state.data;
              if (response.code == "M0000") {
                return Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: _theme.primaryColor.withOpacity(0.05),
                          ),
                          child: Column(
                            children: [
                              LoanKeyValueTile(
                                title: "Product Name",
                                value: response.findValueString("product"),
                                axis: Axis.horizontal,
                              ),
                              LoanKeyValueTile(
                                title: "Account Number",
                                value: response.findValueString(
                                  "accountNumber",
                                ),
                                axis: Axis.horizontal,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          child: Table(
                            children: [
                              TableRow(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      LoanKeyValueTile(
                                        title: "Interest Type",
                                        value: response.findValueString(
                                          "interestType",
                                        ),
                                        axis: Axis.vertical,
                                      ),
                                      LoanKeyValueTile(
                                        title: "Issued On",
                                        value: response.findValueString(
                                          "issuedOn",
                                        ),
                                        axis: Axis.vertical,
                                      ),
                                      if (response
                                              .findValueString(
                                                "principalInstallments",
                                              )
                                              .toLowerCase() !=
                                          "null")
                                        LoanKeyValueTile(
                                          title: "Principal Installments",
                                          value: response.findValueString(
                                            "principalInstallments",
                                          ),
                                          axis: Axis.vertical,
                                        ),
                                      if (response
                                              .findValueString(
                                                "principalInstallments",
                                              )
                                              .toLowerCase() !=
                                          "null")
                                        LoanKeyValueTile(
                                          title: "Interest Installments",
                                          value: response.findValueString(
                                            "interestInstallments",
                                          ),
                                          axis: Axis.vertical,
                                        ),
                                      LoanKeyValueTile(
                                        title: "Balance",
                                        value: response.findValueString(
                                          "balance",
                                        ),
                                        axis: Axis.vertical,
                                      ),
                                      LoanKeyValueTile(
                                        title: "Duration",
                                        value: response.findValueString(
                                          "duration",
                                        ),
                                        axis: Axis.vertical,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.wp),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        LoanKeyValueTile(
                                          title: "Interest Rate",
                                          value: response.findValueString(
                                            "interestRate",
                                          ),
                                          axis: Axis.vertical,
                                        ),
                                        LoanKeyValueTile(
                                          title: "Matures On",
                                          value: response.findValueString(
                                            "maturesOn",
                                          ),
                                          axis: Axis.vertical,
                                        ),
                                        LoanKeyValueTile(
                                          title: "Disbursed Amount",
                                          value: response.findValueString(
                                            "disbursedAmount",
                                          ),
                                          axis: Axis.vertical,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              NavigationService.push(
                                target: LoanStatementPage(
                                  loanAccountNumber: widget.loanAccountNumber,
                                ),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    offset: const Offset(7, 7),
                                    blurRadius: 8,
                                    spreadRadius: -5,
                                  ),
                                ],
                                color: _theme.scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SvgPicture.asset(
                                    Assets.loanStatement,
                                    height: 25.hp,
                                    color: _theme.primaryColor,
                                  ),
                                  Text(
                                    "Loan Statement",
                                    style: _textTheme.titleLarge!.copyWith(
                                      color: _theme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.wp),
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              NavigationService.push(
                                target: LoanSchedulePage(),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    offset: const Offset(7, 7),
                                    blurRadius: 8,
                                    spreadRadius: -5,
                                  ),
                                ],
                                color: _theme.scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SvgPicture.asset(
                                    Assets.loanSchedule,
                                    height: 25.hp,
                                    color: _theme.primaryColor,
                                  ),
                                  Text(
                                    "Loan Schedule",
                                    style: _textTheme.titleLarge!.copyWith(
                                      color: _theme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.hp),
                    //   Row(
                    //     children: [
                    //       Expanded(
                    //         child: InkWell(
                    //           borderRadius: BorderRadius.circular(12),
                    //           onTap: () {
                    //             NavigationService.push(
                    //               target: const LoanPaymentPage(),
                    //             );
                    //           },
                    //           child: Container(
                    //             alignment: Alignment.center,
                    //             padding:
                    //                 const EdgeInsets.symmetric(vertical: 18),
                    //             decoration: BoxDecoration(
                    //                 boxShadow: [
                    //                   BoxShadow(
                    //                     color: Colors.grey.withOpacity(0.3),
                    //                     offset: const Offset(7, 7),
                    //                     blurRadius: 8,
                    //                     spreadRadius: -5,
                    //                   ),
                    //                 ],
                    //                 color: _theme.scaffoldBackgroundColor,
                    //                 borderRadius: BorderRadius.circular(8)),
                    //             child: Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceEvenly,
                    //               children: [
                    //                 SvgPicture.asset(
                    //                   Assets.loanIcon,
                    //                   height: 25.hp,
                    //                   color: _theme.primaryColor,
                    //                 ),
                    //                 Text(
                    //                   "Loan Payment",
                    //                   style: _textTheme.titleLarge!.copyWith(
                    //                       color: _theme.primaryColor,
                    //                       fontWeight: FontWeight.bold),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       SizedBox(width: 10.wp),
                    //       const Spacer(),
                    //     ],
                    //   ),
                  ],
                );
              } else {
                return NoDataScreen(
                  title: response.status,
                  details: response.message,
                );
              }
            } else if (state is CommonError) {
              return NoDataScreen(
                title: "No Data Found",
                details: state.message,
              );
            } else if (state is CommonLoading) {
              return const CommonLoadingWidget();
            } else {
              return Container(child: Text(state.toString()));
            }
          },
        ),
        topbarName: "Loan",
      ),
    );
  }
}
