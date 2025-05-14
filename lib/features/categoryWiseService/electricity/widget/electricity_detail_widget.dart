import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/utils/amount_utils.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/utils/text_utils.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/common_table_widget.dart';
import 'package:ismart_web/common/widget/common_transaction_success_screen.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/key_value_tile.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/common/widget/transactipon_pin_screen.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class ElectricityDetailsWidgets extends StatefulWidget {
  final UtilityResponseData useServiceResponse;
  final String counterName;
  final String customerId;
  final String scNumber;
  final ServiceList service;
  final String counterCode;
  const ElectricityDetailsWidgets({
    Key? key,
    required this.useServiceResponse,
    required this.counterName,
    required this.customerId,
    required this.scNumber,
    required this.service,
    required this.counterCode,
  }) : super(key: key);

  @override
  State<ElectricityDetailsWidgets> createState() =>
      _ElectricityDetailsWidgetsState();
}

class _ElectricityDetailsWidgetsState extends State<ElectricityDetailsWidgets> {
  final TextEditingController _amountController = TextEditingController();
  // final ValueNotifier<String> _promoCode = ValueNotifier("");

  bool _makeAdvancePayment = false;

  bool _isLoading = false;

  double _totalAmountToPay = 0.0;

  _updateMakePaymentStatus(bool status) {
    _makeAdvancePayment = status;

    setState(() {});
  }

  double get _totalDueAmount {
    return AmountUtils.getAmountInRupees(
      amount: widget.useServiceResponse.findValue(
        primaryKey: "hashResponse",
        secondaryKey: "Amount",
      ),
    );
  }

  getTotalPayingAmount() {
    print(_makeAdvancePayment);
    print(_totalDueAmount);
    _totalAmountToPay = 0.0;
    if (!_makeAdvancePayment) {
      _amountController.text = "";
      _totalAmountToPay = _totalDueAmount;

      // setState(() {});

      return;
    }

    final double _totalBillDue = _totalDueAmount;

    final double _totalAdvAmount =
        double.tryParse(_amountController.text) ?? 0.0;
    _totalAmountToPay = _totalBillDue + _totalAdvAmount;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // _amountController.text = _totalDueAmount.toString();

    _amountController.addListener(() {
      getTotalPayingAmount();
    });

    getTotalPayingAmount();
  }

  List<List<String>> get _billsDetails {
    final List<Map<String, dynamic>> _temp =
        widget.useServiceResponse
            .findValue<List>(primaryKey: "payment")
            ?.cast<Map<String, dynamic>>() ??
        [];
    return [
      ["Due Date", "Bill Amt", "Remarks", "Payable"],
      ..._temp.map<List<String>>(
        (e) => [
          TextUtils.replaceEmptyWithDash(e["_billDate"]),
          AmountUtils.getAmountInRupees(
            amount: TextUtils.replaceEmptyWithDash(e["_billAmount"]),
          ).toString(),
          TextUtils.replaceEmptyWithDash(e["_description"]),
          AmountUtils.getAmountInRupees(
            amount: TextUtils.replaceEmptyWithDash(e["_amount"]),
          ).toString(),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;

    return BlocListener<UtilityPaymentCubit, CommonState>(
      listener: (context, state) {
        if (state is CommonLoading && _isLoading == false) {
          _isLoading = true;
          showLoadingDialogBox(context);
        } else if (state is! CommonLoading && _isLoading) {
          _isLoading = false;
          Navigator.pop(context);
        }

        if (state is CommonStateSuccess<UtilityResponseData>) {
          final UtilityResponseData _response = state.data;
          if (_response.status.toLowerCase() == "success".toLowerCase()) {
            NavigationService.push(
              target: CommonTransactionSuccessPage(
                serviceName: widget.service.service,
                body: Column(
                  children: [
                    KeyValueTile(
                      title: "Name",
                      value:
                          widget.useServiceResponse.findValue<String>(
                            primaryKey: "hashResponse",
                            secondaryKey: "Customer Name",
                          ) ??
                          "",
                    ),
                    KeyValueTile(title: "Counter", value: widget.counterName),
                    KeyValueTile(
                      title: "Customer ID",
                      value: widget.customerId,
                    ),
                    KeyValueTile(
                      title: "SC Number",
                      value: widget.scNumber,
                      bottomPadding: 0,
                    ),
                    KeyValueTile(
                      title: "Total Amount",
                      value: _totalAmountToPay.toString(),
                      bottomPadding: 0,
                    ),
                  ],
                ),
                message: state.data.message,
                transactionID: state.data.transactionIdentifier,
              ),
            );
          } else {
            showPopUpDialog(
              context: context,
              message: _response.message,
              buttonCallback: () {},
              title: 'Error',
            );
          }
        } else if (state is CommonError) {
          showPopUpDialog(
            context: context,
            message: state.message,
            buttonCallback: () {},
            title: 'Error',
          );
        }
      },
      child: PageWrapper(
        body: CommonContainer(
          verificationAmount: _totalAmountToPay.toString(),
          onButtonPressed: () {
            NavigationService.push(
              target: TransactionPinScreen(
                onValueCallback: (p0) {
                  NavigationService.pop();
                  context.read<UtilityPaymentCubit>().makePayment(
                    serviceIdentifier: widget.service.uniqueIdentifier,
                    accountDetails: {
                      "scno": widget.scNumber,
                      "office_code": widget.counterCode,
                      "customerId": widget.customerId,
                      "amount":
                          AmountUtils.getAmountInPaisa(
                            amount: _totalAmountToPay.toString(),
                          ).toString(),
                      "account_number":
                          RepositoryProvider.of<CustomerDetailRepository>(
                            context,
                          ).selectedAccount.value!.accountNumber,
                      "customerName":
                          widget.useServiceResponse.findValue<String>(
                            primaryKey: "hashResponse",
                            secondaryKey: "Customer Name",
                          ) ??
                          "",
                    },
                    body: {
                      "customerId": widget.customerId,
                      "sessionId":
                          widget.useServiceResponse.findValue(
                            primaryKey: "hashResponse",
                            secondaryKey: "sessionId",
                          ) ??
                          "",
                    },
                    apiEndpoint: "/api/neapay",
                    mPin: p0,
                  );
                },
              ),
            );
          },
          buttonName: "Procced",
          title: widget.service.service,
          detail: widget.service.instructions,
          showDetail: true,
          topbarName: widget.service.serviceCategoryName,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Customer Details",
                style: _textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                children: [
                  KeyValueTile(
                    title: "Name",
                    value:
                        widget.useServiceResponse.findValue<String>(
                          primaryKey: "hashResponse",
                          secondaryKey: "Customer Name",
                        ) ??
                        "",
                  ),
                  KeyValueTile(title: "Counter", value: widget.counterName),
                  KeyValueTile(title: "Customer ID", value: widget.customerId),
                  KeyValueTile(
                    title: "SC Number",
                    value: widget.scNumber,
                    bottomPadding: 0,
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 20.hp, bottom: 10.hp),
                padding: const EdgeInsets.symmetric(
                  horizontal: CustomTheme.symmetricHozPadding,
                ),
                child: Text(
                  "Bill Details",
                  style: _textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // CommonDetailsWrapper(
              //   topPadding: 20,
              //   bottomPadding: 20,
              //   showDivider: false,
              //   horizontalMargin: CustomTheme.symmetricHozPadding,
              //   header:
              //   footer: Container(),
              // ),
              CommonTableWidget(values: _billsDetails),
              Container(
                padding: EdgeInsets.only(
                  top: 20.hp,
                  bottom: 15.hp,
                  left: CustomTheme.symmetricHozPadding,
                  right: CustomTheme.symmetricHozPadding,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      height: 24.hp,
                      width: 24.hp,
                      child: Checkbox(
                        value: _makeAdvancePayment,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        activeColor: _theme.primaryColor,
                        onChanged: (val) {
                          if (val != null) {
                            _updateMakePaymentStatus(val);
                          }
                          getTotalPayingAmount();
                        },
                      ),
                    ),
                    SizedBox(width: 10.wp),
                    GestureDetector(
                      onTap: () {
                        _updateMakePaymentStatus(!_makeAdvancePayment);
                        getTotalPayingAmount();
                      },
                      child: Text(
                        "Make Advance Payment",
                        style: _textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (_makeAdvancePayment)
                CustomTextField(
                  controller: _amountController,
                  hintText: "Enter advanced amount.",
                ),
              KeyValueTile(
                isRedColor: true,
                useCustomColor: true,
                title: "Total Amount",
                value: _totalAmountToPay.toString(),
                titleFontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
