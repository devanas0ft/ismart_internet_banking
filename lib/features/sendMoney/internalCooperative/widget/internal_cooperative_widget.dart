import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/utils/responsive.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/key_value_tile.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/primary_account_box.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/cubits/coop_list_cubit.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/models/internal_branch.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/resources/internal_transfer_repository.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/screen/select_co_op_branch.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/widget/internal_coop_bill_widget.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class InternalCooperativeWidget extends StatefulWidget {
  final String? accountNumber;
  final bool? isFavAccount;
  final String? branchName;
  final String branchId;
  final String? accountName;
  final String? branchCodeQr;
  final String? remarks;

  const InternalCooperativeWidget({
    Key? key,
    this.accountNumber,
    this.accountName,
    this.branchCodeQr,
    this.remarks,
    this.isFavAccount = false,
    this.branchName,
    required this.branchId,
  }) : super(key: key);

  @override
  State<InternalCooperativeWidget> createState() =>
      _InternalCooperativeWidgetState();
}

class _InternalCooperativeWidgetState extends State<InternalCooperativeWidget> {
  String? branchId;
  String? branchCode;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  String _currentAmount = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  InternalBranch? branchFromQr;
  bool _isLoading = false;
  InternalBranch? selectedIDFromQr;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _toggleBottomSheet() {
    // showModalBottomSheet(
    //   context: context,
    //   backgroundColor: Colors.transparent,
    //   shape: const RoundedRectangleBorder(
    //     borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    //   ),
    //   builder: (context) => Container(
    //     height: 500,
    //     decoration: const BoxDecoration(
    //       color: CustomTheme.white,
    //       borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    //     ),
    //     child: const TransactionProgressPage(
    //       persistOpen: true,
    //       title: "Internal Fund Transfer ",
    //       profileType: 'CustomerProfile',
    //       isOpen: true,
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Responsive.isDesktop(context) ? 96 : 0,
      ),
      child: BlocListener<UtilityPaymentCubit, CommonState>(
        listener: (context, state) {
          if (state is CommonLoading && _isLoading == false) {
            _isLoading = true;
            showLoadingDialogBox(context);
          } else if (state is! CommonLoading && _isLoading) {
            _isLoading = false;
            NavigationService.pop();
          }

          if (state is CommonStateSuccess<UtilityResponseData>) {
            final UtilityResponseData _response = state.data;
            if (_response.code == "M0000" ||
                _response.status.toLowerCase() == "success") {
              final finalBranchCode =
                  widget.branchId.isEmpty
                      ? branchCode ?? selectedIDFromQr?.branchCode ?? ""
                      : widget.branchCodeQr;
              final finalAccountNumber =
                  widget.branchId.isEmpty
                      ? _accountNumberController.text
                      : widget.accountNumber;

              NavigationService.pushReplacement(
                target: InternalCoopBillDetailPage(
                  message: _response.message,
                  body: Column(
                    children: [
                      KeyValueTile(
                        title: "From Account",
                        value:
                            RepositoryProvider.of<CustomerDetailRepository>(
                              context,
                            ).selectedAccount.value!.accountNumber,
                      ),
                      KeyValueTile(
                        title: "To Account",
                        value: _accountNumberController.text,
                      ),
                      KeyValueTile(
                        title: "Account Holder Name",
                        value: _accountNameController.text,
                      ),
                      KeyValueTile(
                        title: "Branch Code",
                        value: branchId ?? widget.branchCodeQr.toString(),
                      ),
                      KeyValueTile(
                        title: "Remarks",
                        value: _remarksController.text,
                      ),
                      KeyValueTile(
                        title: "Total Amount",
                        value: _amountController.text,
                      ),
                    ],
                  ),
                  accountName: _accountNameController.text,
                  accountNumber: "$finalBranchCode$finalAccountNumber",
                  // accountNumber: widget.isFavAccount == true
                  //     ? (widget.branchCodeQr.toString() +
                  //         widget.accountNumber.toString())
                  //     : (selectedIDFromQr?.bankCode ?? branchCode.toString()) +
                  //         _accountNumberController.text,
                  amount: _amountController.text,
                  branchCode: finalBranchCode.toString(),
                  remarks: _remarksController.text,
                ),
              );
            } else {
              showPopUpDialog(
                context: context,
                message: _response.message,
                showCancelButton: false,
                title: _response.status,
                buttonCallback: () {
                  NavigationService.pop();
                },
              );
            }
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Account',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  // color: Color(0xFF666666),
                ),
              ),
              PrimaryAccountBox(validateMobileBankingStatus: true),
              widget.isFavAccount == true
                  ? CustomTextField(
                    readOnly: true,
                    title: "Branch ${widget.branchCodeQr}",
                    controller:
                        _branchController..text = widget.branchName ?? "",
                  )
                  : widget.branchCodeQr == null
                  ? CustomTextField(
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
                  )
                  : BlocProvider(
                    lazy: false,
                    create:
                        (context) => CoopListCubit(
                          internalTransferRepository:
                              RepositoryProvider.of<InternalTransferRepository>(
                                context,
                              ),
                        )..fetchBanksList(),
                    child: BlocConsumer<CoopListCubit, CommonState>(
                      builder: (context, state) {
                        print("state of state is $state");
                        if (state is CommonDataFetchSuccess<InternalBranch>) {
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
                title: "Destination Account",
                hintText: "Account Number",
                controller:
                    _accountNumberController..text = widget.accountNumber ?? "",
                validator:
                    (val) => FormValidator.validateFieldNotEmpty(
                      val,
                      "Account Number",
                    ),
              ),
              CustomTextField(
                hintText: "Account Holder Name",
                controller:
                    _accountNameController..text = widget.accountName ?? "",
                validator:
                    (val) => FormValidator.validateFieldNotEmpty(
                      val,
                      "Account Name",
                    ),
              ),
              CustomTextField(
                // showTransLimit: true,
                // transLimitFunc: _toggleBottomSheet,
                title: "Amount",
                textInputType: TextInputType.number,
                hintText: "NPR",
                onChanged: (value) {
                  setState(() {
                    _currentAmount = value;
                  });
                },
                controller: _amountController,
                validator:
                    (val) => FormValidator.validateFieldNotEmpty(val, "Amount"),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                title: "Remarks",
                hintText: "Remarks",
                controller: _remarksController..text = widget.remarks ?? "",
                validator:
                    (val) =>
                        FormValidator.validateFieldNotEmpty(val, "Remarks"),
              ),
              CustomRoundedButtom(
                title: 'Proceed',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<UtilityPaymentCubit>().fetchDetails(
                      serviceIdentifier: "",
                      accountDetails: {
                        "destinationAccountNumber":
                            _accountNumberController.text,
                        "destinationAccountName": _accountNameController.text,
                        "destinationBranchId":
                            widget.isFavAccount == true
                                ? widget.branchId
                                : branchId ??
                                    selectedIDFromQr?.id.toString() ??
                                    "",
                      },
                      apiEndpoint: "/api/account/validation",
                    );
                  }
                },
              ),
            ],
          ),
        ),
        // child: CommonContainer(
        //   verificationAmount: _currentAmount,
        //   body:
        //   topbarName: "Fund Transfer",
        //   showDetail: true,
        // onButtonPressed: () {
        //   if (_formKey.currentState!.validate()) {
        //     context.read<UtilityPaymentCubit>().fetchDetails(
        //       serviceIdentifier: "",
        //       accountDetails: {
        //         "destinationAccountNumber": _accountNumberController.text,
        //         "destinationAccountName": _accountNameController.text,
        //         "destinationBranchId":
        //             widget.isFavAccount == true
        //                 ? widget.branchId
        //                 : branchId ?? selectedIDFromQr?.id.toString() ?? "",
        //       },
        //       apiEndpoint: "/api/account/validation",
        //     );
        //   }
        // },
        //   showAccountSelection: true,
        //   buttonName: "Proceed",
        //   title: "Internal Cooperative",
        //   detail: "Send Money to account maintained at same Coop.",
        // ),
      ),
    );
  }
}
