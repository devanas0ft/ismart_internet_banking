import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/common_transaction_success_screen.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/key_value_tile.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/common/widget/transactipon_pin_screen.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/screen/select_co_op_branch.dart';
import 'package:ismart_web/features/sendMoney/models/bank.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class LoanPaymentWidget extends StatefulWidget {
  const LoanPaymentWidget({super.key});

  @override
  State<LoanPaymentWidget> createState() => _LoanPaymentWidgetState();
}

class _LoanPaymentWidgetState extends State<LoanPaymentWidget> {
  Bank? selectedBank;
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _desAccountNoController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? branchId;
  String? branchCode;
  bool _isLoading = false;
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
              buttonCallback: () {
                NavigationService.pop();
              },
              showCancelButton: false,
            );
          }

          if (state is CommonStateSuccess<UtilityResponseData>) {
            final UtilityResponseData _response = state.data;
            if (_response.code == "M0000" ||
                _response.status.toLowerCase() == "success") {
              final UtilityResponseData _res = state.data;
              NavigationService.push(
                target: CommonTransactionSuccessPage(
                  body: Column(
                    children: [
                      KeyValueTile(
                        title: "Branch",
                        value: _branchController.text,
                      ),
                      KeyValueTile(
                        title: "Destination Account",
                        value: _desAccountNoController.text,
                      ),
                      KeyValueTile(
                        title: "Mobile Number",
                        value: _mobileNumberController.text,
                      ),
                      KeyValueTile(
                        title: "Amount",
                        value: _amountController.text,
                      ),
                      KeyValueTile(
                        title: "Remarks",
                        value: _remarksController.text,
                      ),
                    ],
                  ),
                  message: _res.message,
                  serviceName: "Loan Payment",
                  transactionID: _res.transactionIdentifier,
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
          buttonName: "Pay",
          onButtonPressed: () {
            if (_formKey.currentState!.validate()) {
              NavigationService.push(
                target: TransactionPinScreen(
                  onValueCallback: (p0) {
                    NavigationService.pop();
                    context.read<UtilityPaymentCubit>().makePayment(
                      serviceIdentifier: "",
                      accountDetails: {
                        "accountNumber":
                            RepositoryProvider.of<CustomerDetailRepository>(
                              context,
                            ).selectedAccount.value!.accountNumber,
                        "destinationAccountNumber":
                            _desAccountNoController.text,
                        "branchId": branchId,
                        "amount": _amountController.text,
                        "remarks": _remarksController.text,
                        "mobileNumber": _mobileNumberController.text,
                      },
                      body: {},
                      apiEndpoint: "api/loan/payment",
                      mPin: p0,
                    );
                  },
                ),
              );
            }
          },
          title: "Loan Payment",
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  title: "Branch",
                  hintText: "Select Branch",
                  readOnly: true,
                  controller: _branchController,
                  validator:
                      (val) =>
                          FormValidator.validateFieldNotEmpty(val, "Branch"),
                  onTap: () {
                    NavigationService.push(
                      target: CoOperativeBranchPage(
                        onBankSelected: (val) {
                          NavigationService.pop();
                          branchCode = val.branchCode;
                          branchId = val.id.toString();
                          _branchController.text = val.name;
                        },
                      ),
                    );
                  },
                ),
                CustomTextField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  title: "Destination Account",
                  hintText: "Account Number",
                  controller: _desAccountNoController,
                  validator:
                      (val) => FormValidator.validateFieldNotEmpty(
                        val,
                        "Account Number",
                      ),
                ),
                CustomTextField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  title: "Mobile Number",
                  textInputType: TextInputType.number,
                  hintText: "Mobile Number",
                  controller: _mobileNumberController,
                  validator: (val) => FormValidator.validatePhoneNumber(val),
                ),
                CustomTextField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  title: "Amount",
                  textInputType: TextInputType.number,
                  hintText: "NPR",
                  controller: _amountController,
                  validator:
                      (val) =>
                          FormValidator.validateFieldNotEmpty(val, "Amount"),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  title: "Remarks",
                  hintText: "Remarks",
                  controller: _remarksController,
                  validator:
                      (val) =>
                          FormValidator.validateFieldNotEmpty(val, "Remarks"),
                ),
              ],
            ),
          ),
          topbarName: "Loan Payment",
        ),
      ),
    );
  }
}
