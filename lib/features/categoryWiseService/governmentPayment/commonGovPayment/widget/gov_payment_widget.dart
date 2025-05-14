import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/widget/common_bill_details_screen.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/key_value_tile.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class GovPaymentWidget extends StatefulWidget {
  const GovPaymentWidget({super.key, required this.service});

  final ServiceList service;

  @override
  State<GovPaymentWidget> createState() => _GovPaymentWidgetState();
}

class _GovPaymentWidgetState extends State<GovPaymentWidget> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _ebpNumberController = TextEditingController();
  final _amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      body: BlocListener<UtilityPaymentCubit, CommonState>(
        listener: (context, state) {
          if (state is CommonLoading && _isLoading == false) {
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
              title: "Sorry",
              buttonCallback: () {
                NavigationService.pop();
              },
              showCancelButton: false,
            );
          }
          if (state is CommonStateSuccess<UtilityResponseData>) {
            final UtilityResponseData _response = state.data;
            if (_response.code == "M0000") {
              NavigationService.push(
                target: CommonBillDetailPage(
                  serviceName: widget.service.service,
                  service: widget.service,
                  serviceIdentifier: widget.service.uniqueIdentifier,
                  accountDetails: {
                    'amount': _amountController.text,
                    'account_number':
                        RepositoryProvider.of<CustomerDetailRepository>(
                          context,
                        ).selectedAccount.value!.accountNumber,
                  },
                  apiBody: {
                    "voucherCode": _ebpNumberController.text,
                    "billerCode": _response.findValue(
                      primaryKey: "hashResponse",
                      secondaryKey: "billerCode",
                    ),
                    "serviceCharge": _response.findValue(
                      primaryKey: "hashResponse",
                      secondaryKey: "serviceCharge",
                    ),
                  },
                  apiEndpoint: '/api/governmentpayment/pay',
                  body: Column(
                    children: [
                      KeyValueTile(
                        title: "Biller Code",
                        value:
                            _response
                                .findValue(
                                  primaryKey: "hashResponse",
                                  secondaryKey: "billerCode",
                                )
                                .toString(),
                      ),
                      KeyValueTile(
                        title: "Customer Name",
                        value:
                            _response
                                .findValue(
                                  primaryKey: "hashResponse",
                                  secondaryKey: "customerName",
                                )
                                .toString(),
                      ),
                      KeyValueTile(
                        title: "Bank Name",
                        value:
                            _response
                                .findValue(
                                  primaryKey: "hashResponse",
                                  secondaryKey: "bankName",
                                )
                                .toString(),
                      ),
                      KeyValueTile(
                        title: "Office Name",
                        value:
                            _response
                                .findValue(
                                  primaryKey: "hashResponse",
                                  secondaryKey: "officeName",
                                )
                                .toString(),
                      ),
                      KeyValueTile(
                        title: "Amount",
                        value:
                            _response
                                .findValue(
                                  primaryKey: "hashResponse",
                                  secondaryKey: "amount",
                                )
                                .toString(),
                      ),
                      KeyValueTile(
                        title: "Service Charge",
                        value:
                            _response
                                .findValue(
                                  primaryKey: "hashResponse",
                                  secondaryKey: "serviceCharge",
                                )
                                .toString(),
                      ),
                      KeyValueTile(
                        title: "Total Amount",
                        value:
                            _response
                                .findValue(
                                  primaryKey: "hashResponse",
                                  secondaryKey: "totalAmount",
                                )
                                .toString(),
                      ),
                      KeyValueTile(
                        title: "Remarks",
                        value:
                            _response
                                .findValue(
                                  primaryKey: "hashResponse",
                                  secondaryKey: "remarks",
                                )
                                .toString(),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              showPopUpDialog(
                context: context,
                message: _response.message,
                title: _response.status,
                buttonCallback: () {
                  NavigationService.pop();
                },
                showCancelButton: false,
              );
            }
          }
        },
        child: CommonContainer(
          showRecentTransaction: true,
          associatedId: widget.service.id.toString(),
          showAccountSelection: true,
          topbarName: widget.service.serviceCategoryName,
          title: widget.service.service,
          detail: widget.service.instructions,
          showDetail: true,
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _ebpNumberController,
                  title: widget.service.labelName,
                  hintText: widget.service.labelSample,
                  validator:
                      (value) => FormValidator.validateFieldNotEmpty(
                        value,
                        widget.service.labelName,
                      ),
                ),
                CustomTextField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator:
                      (value) => FormValidator.validateAmount(
                        val: value.toString(),
                        maxAmount: widget.service.maxValue,
                        minAmount: widget.service.minValue,
                      ),
                  controller: _amountController,
                  textInputType: TextInputType.number,
                  title: 'Amount',
                  hintText: 'Enter the amount',
                ),
              ],
            ),
          ),
          buttonName: 'Get details',
          onButtonPressed: () {
            _formKey.currentState!.save();
            if (_formKey.currentState!.validate()) {
              context.read<UtilityPaymentCubit>().fetchDetails(
                serviceIdentifier: widget.service.uniqueIdentifier,
                accountDetails: {
                  'voucherCode': _ebpNumberController.text, // '2077-4623757',
                  'amount': _amountController.text,
                },
                apiEndpoint: '/api/governmentpayment/revenueDetail',
              );
            }
          },
        ),
      ),
    );
  }
}
