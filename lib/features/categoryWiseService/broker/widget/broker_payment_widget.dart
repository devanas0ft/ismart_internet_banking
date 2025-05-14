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
import 'package:ismart_web/features/categoryWiseService/broker/widget/broker_list_page.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';

class BrokerPaymentWidget extends StatefulWidget {
  final ServiceList service;
  const BrokerPaymentWidget({Key? key, required this.service})
    : super(key: key);

  @override
  State<BrokerPaymentWidget> createState() => _BrokerPaymentWidgetState();
}

class _BrokerPaymentWidgetState extends State<BrokerPaymentWidget> {
  final TextEditingController _selectedBrokerController =
      TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _clientIdController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();

  final TextEditingController _remarksController = TextEditingController();
  bool _isLoading = false;
  String? _selectedBrokerCode;
  String _currentAmount = '';
  final _formKey = GlobalKey<FormState>();
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
              title: "Error",
              showCancelButton: false,
              buttonCallback: () {
                NavigationService.pop();
              },
            );
          }

          if (state is CommonStateSuccess) {
            final String _response = state.data;

            NavigationService.push(
              target: CommonBillDetailPage(
                serviceName: widget.service.service,
                body: Column(
                  children: [
                    KeyValueTile(
                      title: "Broker Name",
                      value: _selectedBrokerController.text,
                    ),
                    KeyValueTile(
                      title: "Client ID",
                      value: _clientIdController.text,
                    ),
                    KeyValueTile(
                      title: "Client Name",
                      value: _clientNameController.text,
                    ),
                    KeyValueTile(
                      title: "Mobile Number",
                      value: _mobileNumberController.text,
                    ),
                    KeyValueTile(title: "Charge", value: _response.toString()),
                    KeyValueTile(
                      title: "Amount",
                      value: _amountController.text,
                    ),
                  ],
                ),
                accountDetails: const {},
                apiEndpoint: "/api/broker/payment",
                apiBody: {
                  "accountNumber":
                      RepositoryProvider.of<CustomerDetailRepository>(
                        context,
                      ).selectedAccount.value!.accountNumber,
                  "charge": 5.0,
                  "amount": _amountController.text,
                  "clientId": _clientIdController.text,
                  "brokerCode": _selectedBrokerCode,
                  "clientName": _clientNameController.text,
                  "mobileNumber": _mobileNumberController.text,
                  "remarks": _remarksController.text,
                },
                service: widget.service,
                serviceIdentifier: widget.service.uniqueIdentifier,
              ),
            );
          }
        },
        child: CommonContainer(
          verificationAmount: _currentAmount,
          showRecentTransaction: true,
          associatedId: widget.service.id.toString(),
          title: widget.service.service,
          buttonName: "Proceed",
          showAccountSelection: true,
          showDetail: true,
          topbarName: widget.service.serviceCategoryName,
          detail: widget.service.instructions,
          onButtonPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<UtilityPaymentCubit>().getCharges(
                accountDetails: {
                  "amount": _amountController.text,
                  "code": _selectedBrokerCode,
                },
                apiEndpoint: "/api/broker/charge",
              );
            }
          },
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  hintText: "Select Broker",
                  title: "Select Broker",
                  readOnly: true,
                  controller: _selectedBrokerController,
                  onTap: () {
                    NavigationService.push(
                      target: BrokerSearchPage(
                        onChanged: (val) {
                          _selectedBrokerController.text = val.title;
                          _selectedBrokerCode = val.value;
                          setState(() {});
                        },
                      ),
                    );
                  },
                  validator:
                      (value) =>
                          FormValidator.validateFieldNotEmpty(value, "Broker"),
                ),
                CustomTextField(
                  controller: _clientIdController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  title: "Client Name",
                  hintText: "Name",
                  controller: _clientNameController,
                  validator: (value) => FormValidator.validateName(value),
                ),
                CustomTextField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  title: "Mobile Number",
                  hintText: "+977",
                  controller: _mobileNumberController,
                  validator:
                      (value) => FormValidator.validatePhoneNumber(value),
                ),
                CustomTextField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  title: "Amount",
                  hintText: "NPR",
                  onChanged: (value) {
                    setState(() {
                      _currentAmount = value;
                    });
                  },
                  controller: _amountController,
                  validator:
                      (value) => FormValidator.validateAmount(
                        val: value.toString(),
                        minAmount: widget.service.minValue,
                        maxAmount: widget.service.maxValue,
                      ),
                ),
                CustomTextField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  title: "Remarks",
                  controller: _remarksController,
                  hintText: "Remarks",
                  validator:
                      (value) =>
                          FormValidator.validateFieldNotEmpty(value, "Remarks"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
