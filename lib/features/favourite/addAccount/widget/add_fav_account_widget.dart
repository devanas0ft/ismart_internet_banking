import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/Dahboard/widgets/dashboard_widget.dart';
import 'package:ismart_web/features/sendMoney/anyBank/screen/bank_list_page.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/cubits/coop_list_cubit.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/models/internal_branch.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/resources/internal_transfer_repository.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/screen/select_co_op_branch.dart';
import 'package:ismart_web/features/sendMoney/models/bank.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class AddFavAccountWidget extends StatefulWidget {
  final String? accountNumber;
  final String? accountName;
  final String? bankCode;
  final String? bankName;
  final String? branchCodeQr;

  const AddFavAccountWidget({
    super.key,
    this.accountNumber,
    this.accountName,
    this.bankCode,
    this.bankName,
    this.branchCodeQr,
  });

  @override
  State<AddFavAccountWidget> createState() => _AddFavAccountWidgetState();
}

class _AddFavAccountWidgetState extends State<AddFavAccountWidget> {
  String? branchId;
  String? branchCode;
  InternalBranch? selectedIDFromQr;

  final TextEditingController _bankNameController = TextEditingController();
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
  bool isBankTransfer = true;
  @override
  Widget build(BuildContext context) {
    final bool readOnly = widget.bankCode == null ? false : true;
    // isBankTransfer = widget.branchCode == null ? true : false;
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
          buttonName: "Add Account",
          onButtonPressed: () {
            if (_formKey.currentState!.validate()) {
              if (isBankTransfer == false) {
                context.read<UtilityPaymentCubit>().makePayment(
                  serviceIdentifier: "",
                  accountDetails: {},
                  body: {
                    "reminderType": "OneTime",
                    "serviceInfoType": "Fund_Transfer", // for bank tarsfer,

                    "data": {
                      "destinationAccountNumber":
                          _coopAccountNumberController.text,
                      "destinationAccountName": _coopAccountNameController.text,
                      "destinationBankName": _branchController.text,
                      "destinationBankCode": branchId,
                      "destinationBranchCode": branchCode,
                    },
                  },
                  apiEndpoint: "api/saveuserpayment",
                  mPin: "",
                );
              } else {
                context.read<UtilityPaymentCubit>().makePayment(
                  serviceIdentifier: "",
                  accountDetails: {},
                  body: {
                    "reminderType": "OneTime",
                    "serviceInfoType": "CONNECT_IPS", // for bank tarsfer,
                    "data": {
                      "destinationAccountNumber": _accountNumberController.text,
                      "destinationBankName":
                          selectedBank?.bankName ?? widget.bankName,
                      "destinationAccountName": _accountNameController.text,
                      "destinationBankCode":
                          selectedBank?.bankId ?? widget.bankCode,
                    },
                  },
                  apiEndpoint: "api/saveuserpayment",
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
                Row(
                  children: [
                    Expanded(
                      child: CustomRoundedButtom(
                        title: "Bank Transfer",
                        onPressed: () {
                          setState(() {
                            isBankTransfer = true;
                          });
                        },
                        color:
                            isBankTransfer
                                ? CustomTheme.primaryColor
                                : CustomTheme.primaryColor.withOpacity(0.6),
                      ),
                    ),
                    SizedBox(width: 10.wp),
                    Expanded(
                      child: CustomRoundedButtom(
                        title: "Coop Transfer",
                        onPressed: () {
                          setState(() {});
                          isBankTransfer = false;
                        },
                        color:
                            isBankTransfer
                                ? CustomTheme.primaryColor.withOpacity(0.6)
                                : CustomTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.hp),
                if (isBankTransfer == true)
                  widget.bankName == null
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
                        readOnly: true,
                        title: "Bank Name",
                        controller:
                            _bankNameController..text = widget.bankName ?? "",
                        validator:
                            (value) => FormValidator.validateFieldNotEmpty(
                              value,
                              "Bank Name",
                            ),
                      ),
                if (isBankTransfer == false)
                  widget.branchCodeQr == null
                      ? CustomTextField(
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
                      )
                      : BlocProvider(
                        lazy: false,
                        create:
                            (context) => CoopListCubit(
                              internalTransferRepository: RepositoryProvider.of<
                                InternalTransferRepository
                              >(context),
                            )..fetchBanksList(),
                        child: BlocConsumer<CoopListCubit, CommonState>(
                          builder: (context, state) {
                            print("state of state is $state");
                            if (state
                                is CommonDataFetchSuccess<InternalBranch>) {
                              selectedIDFromQr = state.data.firstWhere(
                                (element) =>
                                    element.branchCode == widget.branchCodeQr,
                              );
                              return CustomTextField(
                                readOnly: true,
                                title: "Branch ",
                                customHintTextStyle: true,
                                hintText: selectedIDFromQr?.name ?? "",
                              );
                            } else {
                              return Container();
                            }
                          },
                          listener: (context, state) {},
                        ),
                      ),
                CustomTextField(
                  readOnly: readOnly,
                  title: "Account Number",
                  controller:
                      isBankTransfer == true
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
                  readOnly: readOnly,
                  title: "Account Holder Name",
                  controller:
                      isBankTransfer == true
                            ? _accountNameController
                            : _coopAccountNameController
                        ..text = widget.accountName ?? "",
                  validator:
                      (value) => FormValidator.validateFieldNotEmpty(
                        value,
                        "Account Holder Name",
                      ),
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
