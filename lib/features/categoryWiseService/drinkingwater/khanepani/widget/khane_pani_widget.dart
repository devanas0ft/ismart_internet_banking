import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/enum/counters_fetch_enum.dart';
import 'package:ismart_web/common/models/key_value.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/drinkingwater/khanepani/screen/khanepani_detail_screen.dart';
import 'package:ismart_web/features/categoryWiseService/electricity/screen/electricity_search_page.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class KhanePaniWidget extends StatefulWidget {
  final ServiceList service;
  const KhanePaniWidget({Key? key, required this.service}) : super(key: key);

  @override
  State<KhanePaniWidget> createState() => _KhanePaniWidgetState();
}

class _KhanePaniWidgetState extends State<KhanePaniWidget> {
  final TextEditingController _selectedCounterController =
      TextEditingController();

  final TextEditingController _customerIdController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String recentTransactionCounterCode = "";
  KeyValue? selectedCounter;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      body: BlocListener<UtilityPaymentCubit, CommonState>(
        listener: (context, state) {
          if (state is CommonLoading && !_isLoading) {
            _isLoading = true;
            showLoadingDialogBox(context);
          } else if (state is! CommonLoading && _isLoading) {
            NavigationService.pop();
          }
          if (state is CommonError) {
            showPopUpDialog(
              context: context,
              message: state.message,
              title: "Error",
              buttonCallback: () {
                NavigationService.pop();
              },
              showCancelButton: false,
            );
          }

          if (state is CommonStateSuccess<UtilityResponseData>) {
            final _response = state.data;

            if (state.data.code == "M0000" ||
                state.data.status.toLowerCase() == "success") {
              NavigationService.push(
                target: KhanepaniDetailsPage(
                  selectedCounterName: selectedCounter?.title ?? "",
                  serivceList: widget.service,
                  customerCode: _customerIdController.text,
                  selectedCounter: selectedCounter?.value,
                  useServiceResponse: _response,
                ),
              );
              // NavigationService.push(
              //     target: CommonBillDetailPage(
              //         body: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             KeyValueTile(
              //               title: "Customer Code",
              //               value: _response.findValueString("customer_code"),
              //             ),
              //             KeyValueTile(
              //               title: "Customer Name",
              //               value: _response.findValueString("customer_name"),
              //             ),
              //             KeyValueTile(
              //               title: "Address",
              //               value: _response.findValueString("address"),
              //             ),
              //             KeyValueTile(
              //               title: "Current Month Dues",
              //               value:
              //                   _response.findValueString("current_month_dues"),
              //             ),
              //             KeyValueTile(
              //               title: "Current Fine",
              //               value:
              //                   _response.findValueString("current_month_fine"),
              //             ),
              //             KeyValueTile(
              //               title: "Discount",
              //               value: _response
              //                   .findValueString("current_month_discount"),
              //             ),
              //             KeyValueTile(
              //               title: "Total Credit Sales Amount",
              //               value: _response
              //                   .findValueString("total_credit_sales_amount"),
              //             ),
              //             KeyValueTile(
              //               title: "Total Advance Amount",
              //               value: _response
              //                   .findValueString("total_advance_amount"),
              //             ),
              //             KeyValueTile(
              //               title: "Previous Dues",
              //               value: _response.findValueString("previous_dues"),
              //             ),
              //             Text("Bill Details",
              //                 style: Theme.of(context).textTheme.titleSmall),
              //             CommonTableWidget(
              //               values: billsDetails(_response),
              //             ),
              //           ],
              //         ),
              //         accountDetails: {
              //           "account_number":
              //               RepositoryProvider.of<CustomerDetailRepository>(
              //                       context)
              //                   .selectedAccount
              //                   .value!
              //                   .accountNumber,
              //           "amount": _response.findValueString("previous_dues"),
              //           "customer_code": _customerIdController.text,
              //           "counter": selectedCounter?.value,
              //         },
              //         apiEndpoint: "/api/khanepanipay",
              //         apiBody: {},
              //         service: widget.service,
              //         serviceIdentifier: widget.service.uniqueIdentifier));
              // // NavigationService.push(
              // //     target: KhanepaniDetailsPage(
              // //   counterName: selectedCounter?.title ?? "",
              // //   customerCode: _customerIdController.text,
              // //   useServiceResponse: state.data,
              // //   counterCode: selectedCounter?.value ?? "",
              // // ));
            } else {
              showPopUpDialog(
                context: context,
                message: state.data.message,
                title: state.data.status,
                buttonCallback: () {
                  NavigationService.pop();
                },
                showCancelButton: false,
              );
            }
          }
        },
        child: CommonContainer(
          onRecentTransactionPressed: (p0) {
            // NavigationService.pop();
            _customerIdController.text = p0.requestDetail.serviceTo.toString();
            recentTransactionCounterCode =
                p0.requestDetail.counterCode.toString();
            _selectedCounterController.text =
                p0.requestDetail.counterCode.toString();
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
              onButtonPressed(
                custmerCode: _customerIdController.text,
                counterCode:
                    selectedCounter?.value ?? recentTransactionCounterCode,
              );
            }
          },
          body: Form(
            key: _formKey,
            child: Column(
              children: [
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
                      target: CounterSearchPage(
                        counterType: CountersEnums.Khanepani,
                        onChanged: (val) {
                          selectedCounter = val;
                          _selectedCounterController.text =
                              selectedCounter?.title ?? "";
                        },
                      ),
                    );
                  },
                ),
                CustomTextField(
                  title: "Customer code",
                  hintText: "XXXXXXXXX",
                  controller: _customerIdController,
                  validator:
                      (val) => FormValidator.validateFieldNotEmpty(
                        val,
                        "Customer Code",
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onButtonPressed({
    required String custmerCode,
    required String counterCode,
  }) {
    context.read<UtilityPaymentCubit>().fetchDetails(
      serviceIdentifier: widget.service.uniqueIdentifier,
      accountDetails: {
        "account_number":
            RepositoryProvider.of<CustomerDetailRepository>(
              context,
            ).selectedAccount.value!.accountNumber,
        "customer_code": custmerCode,
        "counter": counterCode,
        "month_id": 0,
      },
      apiEndpoint: "api/getkhanepanibill",
    );
  }
}
