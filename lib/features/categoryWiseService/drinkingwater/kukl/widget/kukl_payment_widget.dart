import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/models/key_value.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/key_value_tile.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/drinkingwater/kukl/widget/kukl_bill_detail.dart';
import 'package:ismart_web/features/categoryWiseService/drinkingwater/kukl/widget/kukl_select_counter_widget.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class KuklPaymentWidget extends StatefulWidget {
  final ServiceList service;

  const KuklPaymentWidget({Key? key, required this.service}) : super(key: key);

  @override
  State<KuklPaymentWidget> createState() => _KuklPaymentWidgetState();
}

class _KuklPaymentWidgetState extends State<KuklPaymentWidget> {
  final TextEditingController _customerNoCOntroller = TextEditingController();

  final TextEditingController _connectionNumberController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _selectedCounterController =
      TextEditingController();

  String? selectedCounterValue;

  bool isCustomerNo = true;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final _width = SizeUtils.width;
    final _height = SizeUtils.height;
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
          if (state is CommonStateSuccess<UtilityResponseData>) {
            final res = state.data;
            if (res.code == "M0000" && res.status.toLowerCase() == "success") {
              NavigationService.push(
                target: KuklBillDetailPage(
                  connectionNumber: _connectionNumberController.text,
                  counterValue: selectedCounterValue ?? "",
                  customerNumber: _customerNoCOntroller.text,
                  sessionRequestID: res.findValue(
                    primaryKey: "sessionInfo",
                    secondaryKey: "sessionRequestId",
                  ),
                  sessionAuthenticationSignature: res.findValue(
                    primaryKey: "sessionInfo",
                    secondaryKey: "sessionAuthenticationSignature",
                  ),
                  accountDetails: {
                    "accountNo":
                        RepositoryProvider.of<CustomerDetailRepository>(
                          context,
                        ).selectedAccount.value!.accountNumber,
                  },
                  apiEndpoint: "api/kukl/pay",
                  body: Column(
                    children: [
                      KeyValueTile(
                        title: "Name",
                        value: res.findValueString("customerName"),
                      ),
                      KeyValueTile(
                        title: "Address",
                        value: res.findValueString("address"),
                      ),
                      KeyValueTile(
                        title: "Area No",
                        value: res.findValueString("areaNumber"),
                      ),
                      KeyValueTile(
                        title: "Bill Month",
                        value: res.findValueString("billMonth"),
                      ),
                      KeyValueTile(
                        title: "Customer No",
                        value: res.findValueString("customerNo"),
                      ),
                      KeyValueTile(
                        title: "Customer Code",
                        value: res.findValueString("customerCode"),
                      ),
                      KeyValueTile(
                        title: "Penalty",
                        value: res.findValueString("penalty"),
                      ),
                      KeyValueTile(
                        title: "Bill Amount",
                        value: res.findValueString("amount"),
                      ),
                    ],
                  ),
                  service: widget.service,
                  serviceIdentifier: widget.service.uniqueIdentifier,
                ),
              );
            } else {
              showPopUpDialog(
                context: context,
                message: res.message,
                title: res.status,
                showCancelButton: false,
                buttonCallback: () {
                  NavigationService.pop();
                },
              );
            }
          }
        },
        child: CommonContainer(
          onRecentTransactionPressed: (p0) {
            // NavigationService.pop();
            selectedCounterValue = p0.requestDetail.counterCode.toString();
            _selectedCounterController.text =
                p0.requestDetail.counterCode.toString();
            saveValueToController(
              p0.requestDetail.serviceTo.toString(),
              _customerNoCOntroller,
              _connectionNumberController,
            );
            setState(() {});
          },
          showRecentTransaction: true,
          associatedId: widget.service.id.toString(),
          buttonName: "Show Bill",
          showAccountSelection: true,
          title: widget.service.service,
          detail: widget.service.instructions,
          showDetail: true,
          topbarName: "Khane Pani",
          onButtonPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<UtilityPaymentCubit>().makePayment(
                mPin: "",
                accountDetails: {},
                serviceIdentifier: widget.service.uniqueIdentifier,
                body: {
                  "customerno": _customerNoCOntroller.text,
                  "customercode": _connectionNumberController.text,
                  "counter": selectedCounterValue,
                  "type": "kukl Payment",
                },
                apiEndpoint: "api/kukl/inquiry",
              );
            }
          },
          body: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: _theme.primaryColor.withOpacity(0.05),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            _connectionNumberController.clear();
                            isCustomerNo = true;
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color:
                                  isCustomerNo == true
                                      ? CustomTheme.darkerBlack.withOpacity(0.5)
                                      : CustomTheme.white,
                            ),
                            height: _height * 0.04,
                            child: Center(
                              child: Text(
                                "Customer No",
                                style: _textTheme.titleSmall,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: _width * 0.05),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            _customerNoCOntroller.clear();
                            isCustomerNo = false;
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color:
                                  isCustomerNo == false
                                      ? CustomTheme.darkerBlack.withOpacity(0.5)
                                      : CustomTheme.white,
                            ),
                            height: _height * 0.04,
                            child: Center(
                              child: Text(
                                "Connection No",
                                style: _textTheme.titleSmall,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: _height * 0.02),
                CustomTextField(
                  title: "Select Counter",
                  hintText: "Select From List",
                  readOnly: true,
                  validator:
                      (val) =>
                          FormValidator.validateFieldNotEmpty(val, "Counter"),
                  controller: _selectedCounterController,
                  onTap: () {
                    NavigationService.push(
                      target: KuklCounterSearchWidget(
                        onChanged: (KeyValue<dynamic> value) {
                          _selectedCounterController.text = value.title;
                          selectedCounterValue = value.value;
                        },
                      ),
                    );
                  },
                ),
                CustomTextField(
                  required: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  title: isCustomerNo ? "Customer No" : "Connection No",
                  controller:
                      isCustomerNo
                          ? _customerNoCOntroller
                          : _connectionNumberController,
                  validator:
                      (value) => FormValidator.validateFieldNotEmpty(
                        value,
                        isCustomerNo ? "Customer No" : "Connection No",
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveValueToController(
    String text,
    TextEditingController customerNoController,
    TextEditingController connectionNumberController,
  ) {
    if (text.contains('customerno')) {
      isCustomerNo = true;
      customerNoController.text = text.split('-').last;
    } else if (text.contains('customercode')) {
      isCustomerNo = false;
      connectionNumberController.text = text.split('-').last;
    }
  }
}
