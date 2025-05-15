import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/no_data_screen.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/features/banking/loan/screen/loan_page.dart';
import 'package:ismart_web/features/banking/loan/widget/loan_account_box.dart';
import 'package:ismart_web/features/customerDetail/model/customer_detail_model.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';

class ChooseAccountLoanWidget extends StatefulWidget {
  const ChooseAccountLoanWidget.ChooseLoanAccountWidget({Key? key})
    : super(key: key);

  @override
  State<ChooseAccountLoanWidget> createState() =>
      _ChooseAccountLoanWidgetState();
}

class _ChooseAccountLoanWidgetState extends State<ChooseAccountLoanWidget> {
  String selectedAccountNumber = "";

  @override
  Widget build(BuildContext context) {
    final _customerDetailRepo = RepositoryProvider.of<CustomerDetailRepository>(
      context,
    );
    return PageWrapper(
      body: ValueListenableBuilder<AccountDetail?>(
        valueListenable: _customerDetailRepo.selectedAccount,
        builder: (context, selectedAccount, _) {
          return ValueListenableBuilder<CustomerDetailModel?>(
            valueListenable: _customerDetailRepo.customerDetailModel,
            builder: (context, val, _) {
              if (val != null) {
                final List showValidAccount =
                    val.accountDetail
                        .where(
                          (element) =>
                              element.accountType.toLowerCase() == "loan" ||
                              element.accountType.toLowerCase() == "od",
                        )
                        .toList();
                return CommonContainer(
                  showRoundBotton: showValidAccount.isNotEmpty,
                  showAccountSelection: false,
                  accountTitle: "Select Account",
                  topbarName: "Loan",
                  detail: "Select the Account you want to view loan detail.",
                  buttonName: "Proceed",
                  onButtonPressed: () {
                    NavigationService.pushReplacement(
                      target: LoanPage(
                        accountNumber: showValidAccount.first.accountNumber,
                      ),
                    );
                  },
                  body: Column(
                    children: [
                      showValidAccount.isNotEmpty
                          ? LoanAccountBox(
                            onPressed: (p0) {
                              selectedAccountNumber = p0;
                              setState(() {});
                              NavigationService.pushReplacement(
                                target: LoanPage(
                                  accountNumber: selectedAccountNumber,
                                ),
                              );
                            },
                          )
                          : const NoDataScreen(
                            title: "No Loan Found.",
                            details: "No Loan Account associated found.",
                          ),
                    ],
                  ),
                );
              } else {
                return const NoDataScreen(
                  title: "No Loan Found.",
                  details: "No Loan Account associated found.",
                );
              }
            },
          );
        },
      ),
    );
  }
}
