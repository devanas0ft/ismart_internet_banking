import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/common/widget/top_widget.dart';
import 'package:ismart_web/features/auth/ui/actiateAccount/screen/registration_otp_page.dart';
import 'package:ismart_web/features/auth/ui/resetPin/cubit/reset_pin_cubit.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/models/internal_branch.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/screen/select_co_op_branch.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

import '../../../../../common/app/navigation_service.dart';

// ignore: must_be_immutable
class ActivateAccountWidget extends StatelessWidget {
  ActivateAccountWidget({Key? key}) : super(key: key);
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  String? branchCode;
  final _fromKey = GlobalKey<FormState>();
  InternalBranch? internalBranch;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    return PageWrapper(
      showAppBar: false,
      body: SafeArea(
        child: BlocListener<ResetPinCubit, CommonState>(
          listener: (context, state) {
            if (state is CommonLoading && _isLoading == false) {
              _isLoading = true;
              showLoadingDialogBox(context);
            }
            if (state is! CommonLoading && _isLoading) {
              _isLoading = false;
              NavigationService.pop();
            }

            if (state is CommonError) {
              showPopUpDialog(
                context: context,
                message: state.message,
                title: "Exception",
                showCancelButton: false,
                buttonCallback: () {
                  NavigationService.pop();
                },
              );
            }

            if (state is CommonStateSuccess<UtilityResponseData>) {
              showPopUpDialog(
                context: context,
                message: state.data.message,
                title: "Message",
                buttonText: "Proceed",
                showCancelButton: false,
                buttonCallback: () {
                  NavigationService.pushReplacement(
                    target: RegisterOtpPage(
                      accountNumber: _accountNumberController.text,
                      mobileNumber: _mobileNumberController.text,
                    ),
                  );
                },
              );
            }
          },
          child: ListView(
            children: [
              GuthiTopWidget(showSupportIcon: true),
              SizedBox(height: 10.hp),
              Center(
                child: Text(
                  "Activate Your Service",
                  style: _textTheme.displaySmall,
                ),
              ),
              SizedBox(height: 10.hp),
              Center(
                child: Text(
                  "Enter your registered mobile number",
                  style: _textTheme.headlineSmall,
                ),
              ),
              SizedBox(height: 20.hp),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: CustomTheme.white,
                ),
                child: Form(
                  key: _fromKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator:
                            (value) => FormValidator.validatePhoneNumber(value),
                        controller: _mobileNumberController,
                        title: "Mobile Number",
                      ),
                      CustomTextField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator:
                            (value) => FormValidator.validateFieldNotEmpty(
                              value,
                              "Account Number",
                            ),
                        controller: _accountNumberController,
                        title: "Account Number",
                      ),
                      CustomTextField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                branchCode = val.branchCode;
                                _branchController.text = val.name;
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.hp),
              CustomRoundedButtom(
                title: "Sign Up",
                onPressed: () {
                  _fromKey.currentState!.save();
                  if (_fromKey.currentState!.validate()) {
                    context.read<ResetPinCubit>().resetPin(
                      mPin: "",
                      body: {
                        "accountNumber":
                            (branchCode ?? "") + _accountNumberController.text,
                        "mobileNumber": _mobileNumberController.text,
                      },
                      serviceIdentifier: "",
                      accountDetails: {
                        "clientId":
                            RepositoryProvider.of<CoOperative>(
                              context,
                            ).clientCode,

                        // smsReadToken=lhRzE5yu3ng"
                      },
                      apiEndpoint: "/customer/signup",
                    );
                  }
                },
              ),
              SizedBox(height: 10.hp),
              CustomRoundedButtom(
                title: "Cancel",
                onPressed: () {
                  NavigationService.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
