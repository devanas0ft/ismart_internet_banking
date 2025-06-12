import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/Dahboard/widgets/dashboard_widget.dart';
import 'package:ismart_web/features/sendMoney/anyBank/screen/bank_list_page.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/models/internal_branch.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/screen/select_co_op_branch.dart';
import 'package:ismart_web/features/sendMoney/models/bank.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class UpdateFavAccountWidget extends StatefulWidget {
  final String? accountNumber;
  final String? accountName;
  final String? bankCode;
  final String? bankName;
  // final String? branchCodeQr;
  final bool isBankTransfer;
  final String id;
  final String remainderType;
  final String serviceInfoType;

  const UpdateFavAccountWidget({
    super.key,
    this.accountNumber,
    this.accountName,
    this.bankCode,
    this.bankName,
    // this.branchCodeQr,
    required this.isBankTransfer,
    required this.id,
    required this.remainderType,
    required this.serviceInfoType,
  });

  @override
  State<UpdateFavAccountWidget> createState() => _UpdateFavAccountWidgetState();
}

class _UpdateFavAccountWidgetState extends State<UpdateFavAccountWidget> {
  String? branchId;
  String? branchCode;
  InternalBranch? selectedIDFromQr;

  // final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _selectedBankController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _coopAccountNumberController =
      TextEditingController();
  final TextEditingController _coopAccountNameController =
      TextEditingController();
  final TextEditingController _branchController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  Bank? selectedBank;

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
              showCancelButton: false,
              buttonCallback: () {
                NavigationService.pop();
              },
            );
          }
          if (state is CommonStateSuccess<UtilityResponseData>) {
            final UtilityResponseData _res = state.data;
            if (_res.code == "M0000" ||
                _res.status.toLowerCase() == "success") {
              showPopUpDialog(
                context: context,
                message: _res.message,
                title: _res.status,
                showCancelButton: false,
                buttonCallback: () {
                  NavigationService.pushReplacement(target: DashboardWidget());
                },
              );
            } else {
              showPopUpDialog(
                context: context,
                message: _res.message,
                title: _res.status,
                showCancelButton: false,
                buttonCallback: () {
                  NavigationService.pop();
                },
              );
            }
          }
        },
        child: CommonContainer(
          verticalPadding: 0,
          buttonName: "Update",
          onButtonPressed: () {
            if (_formKey.currentState!.validate()) {
              if (widget.isBankTransfer == false) {
                context.read<UtilityPaymentCubit>().makePayment(
                  serviceIdentifier: "",
                  accountDetails: {},
                  body: {
                    "reminderType": widget.remainderType,
                    "serviceInfoType":
                        widget.serviceInfoType, // for coop tarsfer,

                    "data": {
                      "destinationAccountNumber":
                          _coopAccountNumberController.text,
                      "destinationAccountName": _coopAccountNameController.text,
                      "destinationBankName": _branchController.text,
                      "destinationBankCode": branchId,
                      "destinationBranchCode": branchCode,
                    },
                  },
                  apiEndpoint: "api/updatesavedpayment/${widget.id}",
                  mPin: "",
                );
              } else {
                context.read<UtilityPaymentCubit>().makePayment(
                  serviceIdentifier: "",
                  accountDetails: {},
                  body: {
                    "reminderType": widget.remainderType,
                    "serviceInfoType":
                        widget.serviceInfoType, // for bank tarsfer,
                    "data": {
                      "destinationAccountNumber": _accountNumberController.text,
                      "destinationBankName":
                          selectedBank?.bankName ?? widget.bankName,
                      "destinationAccountName": _accountNameController.text,
                      "destinationBankCode":
                          selectedBank?.bankId ?? widget.bankCode,
                    },
                  },
                  apiEndpoint: "api/updatesavedpayment/${widget.id}",
                  mPin: "",
                );
              }
            }
          },
          showDetail: false,
          showTitleText: false,
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                widget.isBankTransfer == true
                    ? CustomTextField(
                      hintText: "Select Bank",
                      title: "Select Bank",
                      readOnly: true,
                      controller: _selectedBankController,
                      onTap: () {
                        NavigationService.push(
                          target: BankListPage(
                            onBankSelected: (val) {
                              NavigationService.pop();
                              _selectedBankController.text = val.bankName;
                              selectedBank = val;
                              setState(() {});
                            },
                          ),
                        );
                      },
                      // : null,
                      validator:
                          (value) => FormValidator.validateFieldNotEmpty(
                            value,
                            "Destination bank.",
                          ),
                    )
                    : CustomTextField(
                      title: "Branch",
                      hintText: "Select Branch",
                      readOnly: true,
                      controller: _branchController,
                      validator:
                          (val) => FormValidator.validateFieldNotEmpty(
                            val,
                            "Branch",
                          ),
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
                  title: "Account Number",
                  controller:
                      widget.isBankTransfer == true
                            ? _accountNumberController
                            : _coopAccountNumberController
                        ..text = widget.accountNumber ?? "",
                  validator:
                      (value) => FormValidator.validateFieldNotEmpty(
                        value,
                        "Account Number",
                      ),
                ),
                CustomTextField(
                  title: "Account Holder Name",
                  controller:
                      widget.isBankTransfer == true
                            ? _accountNameController
                            : _coopAccountNameController
                        ..text = widget.accountName ?? "",
                  validator:
                      (value) => FormValidator.validateFieldNotEmpty(
                        value,
                        "Account Holder Name",
                      ),
                ),
                CustomRoundedButtom(
                  title: "Delete",
                  onPressed: () {
                    showPopUpDialog(
                      context: NavigationService.context,
                      message: "Are you sure you want to Delete?.",
                      title: "Alert",
                      buttonText: "Delete",
                      buttonCallback: () {
                        context.read<UtilityPaymentCubit>().deleteReq(
                          serviceIdentifier: "",
                          accountDetails: {},
                          apiEndpoint: "api/deletesavedpayment/${widget.id}",
                          mPin: "",
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          topbarName: "Favorite",
        ),
      ),
    );
  }
}
