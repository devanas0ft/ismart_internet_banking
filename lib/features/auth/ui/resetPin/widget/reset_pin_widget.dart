import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/common/widget/top_widget.dart';
import 'package:ismart_web/features/auth/ui/resetPin/cubit/reset_pin_cubit.dart';
import 'package:ismart_web/features/auth/ui/resetPin/screen/reset_otp_page.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/models/internal_branch.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/screen/select_co_op_branch.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

// ignore: must_be_immutable
class ResetPinWidget extends StatelessWidget {
  ResetPinWidget({Key? key}) : super(key: key);
  final _accountNumberController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  InternalBranch? internalBranch;

  bool _isLoading = false;
  final _fromKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      showAppBar: true,
      useOwnAppBar: true,
      body: SafeArea(
        child: Container(
          child: BlocListener<ResetPinCubit, CommonState>(
            listener: (context, state) {
              if (state is CommonLoading && _isLoading == false) {
                _isLoading = true;
                showLoadingDialogBox(context);
              } else if (state is! CommonLoading && _isLoading) {
                _isLoading = false;
                NavigationService.pop();
              }
              if (state is CommonError) {
                // if (state.message.toLowerCase().contains("OTP".toLowerCase())) {
                //   NavigationService.push(target: OTPWidget(onValueCallback: (p0) {
                //     NavigationService.pop();
                //     context.read<ResetPinCubit>().makePayment(
                //         serviceIdentifier: "",
                //         accountDetails: {
                //           "mobileNumber": _mobileNumberController.text,
                //           "otp": p0,
                //           "clientId": RepositoryProvider.of<CoOperative>(context)
                //               .clientCode,
                //         },
                //         body: {},
                //         apiEndpoint: "/customer/reset/verify/",
                //         mPin: "");
                //   }));
                // }
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
                final UtilityResponseData _response = state.data;
                if (_response.status.toLowerCase() == "success".toLowerCase()) {
                  NavigationService.push(
                    target: ResetOTPPage(
                      mobileNumber: _mobileNumberController.text,
                    ),
                  );
                } else {
                  showPopUpDialog(
                    context: context,
                    message: _response.message,
                    title: _response.status,
                    showCancelButton: false,
                    buttonCallback: () {
                      NavigationService.pop();
                    },
                  );
                }
              }
              print("state is $state");
            },
            child: Column(
              children: [
                const GuthiTopWidget(),
                Expanded(
                  child: Container(
                    child: CommonContainer(
                      onButtonPressed: () {
                        if (_fromKey.currentState!.validate()) {
                          context.read<ResetPinCubit>().resetPin(
                            serviceIdentifier: "",
                            accountDetails: {
                              "mobileNumber": _mobileNumberController.text,
                              "accountNumber":
                                  "${internalBranch?.branchCode ?? ""}${_accountNumberController.text}",
                              //001001-001-101-0001091
                              "clientId":
                                  RepositoryProvider.of<CoOperative>(
                                    context,
                                  ).clientCode,
                              // "smsReadToken"
                            },
                            body: {},
                            apiEndpoint: "/customer/reset/send",
                            mPin: "",
                          );
                        }
                      },
                      buttonName: "Proceed",
                      title: "Reset Pin",
                      showDetail: false,
                      body: Form(
                        key: _fromKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: _mobileNumberController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              title: "Mobile Number",
                              validator:
                                  (value) =>
                                      FormValidator.validateFieldNotEmpty(
                                        value,
                                        "Mobile Number",
                                      ),
                            ),
                            CustomTextField(
                              controller: _accountNumberController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              title: "Account Number",
                              validator:
                                  (value) =>
                                      FormValidator.validateFieldNotEmpty(
                                        value,
                                        "Account Number",
                                      ),
                            ),
                            CustomTextField(
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
                                      internalBranch = val;
                                      _branchController.text = val.name;
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      topbarName: "Reset Pin",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
