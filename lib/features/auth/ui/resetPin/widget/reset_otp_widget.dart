import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/common/widget/top_widget.dart';
import 'package:ismart_web/features/auth/ui/resetPin/cubit/reset_pin_cubit.dart';
import 'package:ismart_web/features/auth/ui/resetPin/screen/input_new_pin_page.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class ResetOTPWidget extends StatefulWidget {
  final String mobileNumber;

  const ResetOTPWidget({super.key, required this.mobileNumber});
  @override
  State<ResetOTPWidget> createState() => _ResetOTPWidgetState();
}

class _ResetOTPWidgetState extends State<ResetOTPWidget> {
  String otpCodeInput = "";
  bool _isLoading = false;
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<FormState> _otpKey = GlobalKey<FormState>();
  final _height = SizeUtils.height;
  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      showAppBar: false,
      body: SafeArea(
        child: BlocListener<ResetPinCubit, CommonState>(
          listener: (context, state) {
            if (state is CommonLoading && _isLoading == false) {
              _isLoading = true;
              showLoadingDialogBox(context);
            } else if (state is! CommonLoading && _isLoading) {
              _isLoading = false;
              NavigationService.pop();
            }

            if (state is CommonStateSuccess) {
              final UtilityResponseData _response = state.data;
              if (_response.status.toLowerCase() == "success".toLowerCase()) {
                NavigationService.push(
                  target: InputNewPinPage(
                    mobileNumber: widget.mobileNumber,
                    otp: otpCodeInput,
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
            } else if (state is CommonError) {
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
            print("state is $state ");
          },
          child: ListView(
            children: [
              const GuthiTopWidget(),
              SizedBox(height: _height * 0.03),
              Container(
                padding: const EdgeInsets.all(30),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: CustomTheme.backgroundColor,
                ),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/verify your number.svg",
                      // colorFilter: const ColorFilter.mode(
                      //     Color(0XFF4E4E4E), BlendMode.srcIn),
                      height: _height * 0.05,
                    ),
                    SizedBox(height: _height * 0.02),
                    Text(
                      "Enter your OTP",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: _height * 0.02),
                    Text(
                      "Please enter your OTP to proceed.",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: _height * 0.04),
                    Form(
                      key: _otpKey,
                      // child: CustomPinCodeField(
                      //   length: 6,
                      //   fieldHeight: 50,
                      //   fieldWidth: 45,
                      //   controller: _textController,
                      //   validator: (val) {
                      //     if (val == null) {
                      //       return "Please enter OTP.";
                      //     }
                      //     if (val.length < 6) {
                      //       return "Please enter valid OTP.";
                      //     }
                      //     return null;
                      //   },
                      //   onChanged: (val) {
                      //     otpCodeInput = val;
                      //   },
                      // ),
                      child: Container(),
                    ),
                    SizedBox(height: _height * 0.03),
                    CustomRoundedButtom(
                      title: "Proceed",
                      onPressed: () {
                        if (_otpKey.currentState!.validate()) {
                          context.read<ResetPinCubit>().resetPin(
                            serviceIdentifier: "",
                            accountDetails: {
                              "mobileNumber": widget.mobileNumber,
                              "otp":
                                  otpCodeInput.isNotEmpty
                                      ? otpCodeInput
                                      : _textController.text,
                              "clientId":
                                  RepositoryProvider.of<CoOperative>(
                                    context,
                                  ).clientCode,
                            },
                            body: {},
                            apiEndpoint: "/customer/reset/verify/",
                            mPin: "",
                          );
                        }
                        // Get.to(() => const SetupMpin());
                      },
                    ),
                    SizedBox(height: _height * 0.03),
                    TextButton(
                      onPressed: () {
                        // Get.offAll(() => const MainScreen());
                        // TODOResend OTP Logic
                      },
                      child: Text(
                        "Resend",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
