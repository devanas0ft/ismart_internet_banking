import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/bank_transfer_receipt.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/common/widget/transactipon_pin_screen.dart';
import 'package:ismart_web/features/customerDetail/cubit/customer_detail_cubit.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/sendMoney/cubits/send_to_bank_cubit.dart';
import 'package:ismart_web/features/sendMoney/resources/send_to_bank_repository.dart';

import 'custom_cached_network_image.dart';

class BankTransferBillPage extends StatelessWidget {
  final String? charge;
  final String? imageUrl;
  final String? amount;
  final String serviceName;
  final String? remarks;
  final String? bankCode;
  final String? accountName;
  final String? accountNumber;
  final String? bankName;
  final Widget body;
  final String message;
  final String otp;

  const BankTransferBillPage({
    super.key,
    required this.body,
    this.charge,
    this.amount,
    this.remarks,
    this.bankCode,
    this.accountName,
    this.accountNumber,
    this.bankName,
    required this.serviceName,
    required this.message,
    this.imageUrl,
    required this.otp,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => SendToBankCubit(
            sendToBankRepository: RepositoryProvider.of<SendToBankRepository>(
              context,
            ),
          ),
      child: BankTransferBillWidget(
        otp: otp,
        iamgeUrl: imageUrl,
        accountName: accountName,
        message: message,
        accountNumber: accountNumber,
        amount: amount,
        bankCode: bankCode,
        bankName: bankName,
        charge: charge,
        remarks: remarks,
        body: body,
        serviceName: serviceName,
      ),
    );
  }
}

class BankTransferBillWidget extends StatefulWidget {
  final Widget body;

  final String? charge;
  final String? amount;
  final String serviceName;
  final String? iamgeUrl;
  final String message;
  final String? remarks;
  final String? bankCode;
  final String? accountName;
  final String? accountNumber;
  final String? bankName;
  final String otp;

  const BankTransferBillWidget({
    super.key,
    required this.body,
    this.charge,
    this.amount,
    this.remarks,
    this.bankCode,
    this.accountName,
    this.accountNumber,
    this.bankName,
    required this.serviceName,
    required this.message,
    required this.iamgeUrl,
    required this.otp,
  });

  @override
  State<BankTransferBillWidget> createState() => _BankTransferBillWidgetState();
}

class _BankTransferBillWidgetState extends State<BankTransferBillWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final _height = SizeUtils.height;
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    return PageWrapper(
      showBackButton: true,
      body: BlocListener<SendToBankCubit, CommonState>(
        listener: (context, state) {
          if (state is CommonLoading && _isLoading == false) {
            _isLoading = true;
            showLoadingDialogBox(context);
          }
          if (state is! CommonLoading && _isLoading) {
            NavigationService.pop();
            _isLoading = false;
          }

          if (state is CommonStateSuccess) {
            NavigationService.pushReplacement(
              target: BankTransferReciptPage(
                transactionID: state.data.toString(),
                body: widget.body,
                message: "Transaction Success for the Service",
              ),
            );
            context.read<CustomerDetailCubit>().fetchCustomerDetail();
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.message,
                          style: _textTheme.titleSmall,
                        ),
                      ),
                      SizedBox(width: 20.wp),
                      // Text(widget.iamgeUrl.toString() + "hello"),
                      CustomCachedNetworkImage(
                        url: widget.iamgeUrl.toString(),
                        fit: BoxFit.contain,
                        height: 30.hp,
                        width: 30.wp,
                      ),
                    ],
                  ),
                  SizedBox(height: _height * 0.01),
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
                          "Payment Details",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: _height * 0.02),
                        widget.body,
                      ],
                    ),
                  ),
                  SizedBox(height: _height * 0.02),
                  CustomRoundedButtom(
                    title: "Proceed",
                    onPressed: () {
                      NavigationService.push(
                        target: TransactionPinScreen(
                          onValueCallback: (p0) {
                            NavigationService.pop();

                            context.read<SendToBankCubit>().sendMoneyToBank(
                              otp: widget.otp,
                              charge: widget.charge ?? "",
                              amount: widget.amount ?? "",
                              mpin: p0,
                              remarks: widget.remarks ?? "",
                              destinationBankInstrumentCode:
                                  widget.bankCode ?? "",
                              destinationBankAccountName:
                                  widget.accountName ?? "",
                              destinationBankAccountNumber:
                                  widget.accountNumber ?? "",
                              destinationBankName: widget.bankName ?? "",
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
