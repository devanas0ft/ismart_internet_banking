import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/common/widget/top_widget.dart';
import 'package:ismart_web/features/auth/ui/resetPin/cubit/reset_pin_cubit.dart';
import 'package:ismart_web/features/auth/ui/screens/login_screen.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

// ignore: must_be_immutable
class InputNewPinWidget extends StatelessWidget {
  final String otp;
  final String mobileNumber;
  InputNewPinWidget({Key? key, required this.otp, required this.mobileNumber})
    : super(key: key);
  final _pinController = TextEditingController();
  final _pinConfirmController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      showAppBar: false,
      body: BlocListener<ResetPinCubit, CommonState>(
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
            final UtilityResponseData _response = state.data;
            if (_response.status.toLowerCase() == "success".toLowerCase()) {
              showPopUpDialog(
                context: context,
                message: _response.message,
                title: _response.status,
                showCancelButton: false,
                buttonCallback: () {
                  NavigationService.pushUntil(target: LoginScreen());
                },
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

              NavigationService.pop();
            }
          }
          print("state is $state");
        },
        child: Column(
          children: [
            Container(
              height: 70.hp,
              child: const GuthiTopWidget(showSupportIcon: true),
            ),
            Expanded(
              child: CommonContainer(
                onButtonPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<ResetPinCubit>().resetPin(
                      serviceIdentifier: "",
                      accountDetails: {
                        "mobileNumber": mobileNumber,
                        "otp": otp,
                        "mPin": _pinController.text,

                        //001001-001-101-0001091
                        "clientId":
                            RepositoryProvider.of<CoOperative>(
                              context,
                            ).clientCode,

                        // "smsReadToken"
                      },
                      body: {},
                      apiEndpoint: "/customer/reset/setPin",
                      mPin: "",
                    );
                  }
                },
                buttonName: "Proceed",
                title: "Reset Pin",
                showDetail: false,
                body: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        textInputType: TextInputType.number,
                        controller: _pinController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        title: "New Pin",
                        validator: (value) {
                          if (value!.length != 5) {
                            return "Enter 5 digits pin.";
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        textInputType: TextInputType.number,
                        controller: _pinConfirmController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        title: "Confirm Pin",
                        validator: (value) {
                          if (value != _pinController.text) {
                            return "Confirm Pin doesnot match.";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                topbarName: "Reset Pin",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
