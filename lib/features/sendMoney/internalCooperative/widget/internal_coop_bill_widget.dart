import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_transaction_success_screen.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/common/widget/transactipon_pin_screen.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/cubits/internal_transfer_cubit.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/resources/internal_transfer_repository.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class InternalCoopBillDetailPage extends StatelessWidget {
  final String amount;
  final String accountNumber;
  final String accountName;
  final String remarks;
  final String branchCode;
  final Widget body;
  final String message;

  const InternalCoopBillDetailPage({
    super.key,
    required this.amount,
    required this.accountNumber,
    required this.accountName,
    required this.remarks,
    required this.branchCode,
    required this.body,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => InternalTransferCubit(
            internalTransferRepository:
                RepositoryProvider.of<InternalTransferRepository>(context),
          ),
      child: InternalCoopBillDetailWidget(
        accountName: accountName,
        accountNumber: accountNumber,
        amount: amount,
        body: body,
        branchCode: branchCode,
        message: message,
        remarks: remarks,
      ),
    );
  }
}

// ignore: must_be_immutable
class InternalCoopBillDetailWidget extends StatelessWidget {
  final String amount;
  final String accountNumber;
  final String accountName;
  final String remarks;
  final String branchCode;
  final Widget body;
  final String message;
  bool _isLoading = false;

  InternalCoopBillDetailWidget({
    super.key,
    required this.amount,
    required this.accountNumber,
    required this.accountName,
    required this.remarks,
    required this.branchCode,
    required this.body,
    required this.message,
  });
  @override
  Widget build(BuildContext context) {
    final _height = SizeUtils.height;

    return PageWrapper(
      body: BlocListener<InternalTransferCubit, CommonState>(
        listener: (context, state) {
          if (state is CommonLoading && _isLoading == false) {
            _isLoading = true;
            showLoadingDialogBox(context);
          }
          if (state is! CommonLoading && _isLoading) {
            NavigationService.pop();
            _isLoading = false;
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

          if (state is CommonStateSuccess<UtilityResponseData>) {
            final UtilityResponseData _response = state.data;
            if (_response.code == "M0000" ||
                _response.status.toLowerCase() == "Success" ||
                _response.message.toLowerCase().contains(
                  "success".toLowerCase(),
                )) {
              NavigationService.pushReplacement(
                target: CommonTransactionSuccessPage(
                  serviceName: "Fund Transfer",
                  transactionID: state.data.transactionIdentifier,
                  body: body,
                  message: state.data.message,
                ),
              );
            } else {
              showPopUpDialog(
                context: context,
                message: _response.message,
                title: _response.status,
                showCancelButton: false,
                buttonCallback: () {
                  NavigationService.pop();
                },
              );
            }
          }
        },
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                color: CustomTheme.white,
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      NavigationService.pop();
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  SizedBox(height: _height * 0.02),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: _height * 0.02),
                  const Divider(thickness: 1),
                  SizedBox(height: _height * 0.02),
                  Container(
                    padding: const EdgeInsets.all(12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFFF3F3F3),
                      // border: Border.all(color: Colors.black),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Paymet Details",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: _height * 0.02),
                        body,
                      ],
                    ),
                  ),
                  SizedBox(height: _height * 0.02),
                  CustomRoundedButtom(
                    title: "Pay",
                    onPressed: () {
                      NavigationService.push(
                        target: TransactionPinScreen(
                          onValueCallback: (pin) {
                            NavigationService.pop();
                            context.read<InternalTransferCubit>().fundTranfer(
                              amount: amount,
                              mpin: pin,
                              remarks: remarks,
                              receivingAccount: accountNumber,
                              receivingBranchId: branchCode,
                              sendingAccount:
                                  RepositoryProvider.of<
                                    CustomerDetailRepository
                                  >(
                                    context,
                                  ).selectedAccount.value!.accountNumber,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
