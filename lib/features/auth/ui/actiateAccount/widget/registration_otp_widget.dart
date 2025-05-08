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
import 'package:ismart_web/features/auth/ui/actiateAccount/cubit/reset_otp_register_cubit.dart';
import 'package:ismart_web/features/auth/ui/actiateAccount/resources/reset_otp_register_repository.dart';
import 'package:ismart_web/features/auth/ui/actiateAccount/screen/registration_mpin_page.dart';
import 'package:ismart_web/features/auth/ui/resetPin/cubit/reset_pin_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class RegisterOtpWidget extends StatefulWidget {
  final String mobileNumber;
  final String accountNumber;

  const RegisterOtpWidget({
    super.key,
    required this.mobileNumber,
    required this.accountNumber,
  });
  @override
  State<RegisterOtpWidget> createState() => _RegisterOtpWidgetState();
}

class _RegisterOtpWidgetState extends State<RegisterOtpWidget> {
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
                print("navigating to screen");
                print("navigating to screen 2");

                NavigationService.pushReplacement(
                  target: RegisterMpinPage(
                    mobileNumber: widget.mobileNumber,
                    accountNumber: widget.mobileNumber,
                    otp:
                        otpCodeInput.isNotEmpty
                            ? otpCodeInput
                            : _textController.text,
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
                              "otp":
                                  otpCodeInput.isNotEmpty
                                      ? otpCodeInput
                                      : _textController.text,
                              "clientId":
                                  RepositoryProvider.of<CoOperative>(
                                    context,
                                  ).clientCode,
                            },
                            body: {
                              "mobileNumber": widget.mobileNumber,
                              "accountNumber": widget.accountNumber,
                            },
                            apiEndpoint: "customer/signup/otp",
                            mPin: "",
                          );
                        }
                        // Get.to(() => const SetupMpin());
                      },
                    ),
                    SizedBox(height: _height * 0.03),
                    BlocProvider(
                      create:
                          (context) => ResetOtpRegistrationCubit(
                            resetOtpRegisterRepository: RepositoryProvider.of<
                              ResetOtpRegisterRepository
                            >(context),
                          ),
                      child: BlocListener<
                        ResetOtpRegistrationCubit,
                        CommonState
                      >(
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

                            showPopUpDialog(
                              context: context,
                              message: _response.message,
                              title: _response.status,
                              showCancelButton: false,
                              buttonCallback: () {
                                NavigationService.pop();
                              },
                            );
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
                        },
                        child: TextButton(
                          onPressed: () {
                            context.read<ResetOtpRegistrationCubit>().resetOtp(
                              serviceIdentifier: "",
                              accountDetails: {
                                "clientId":
                                    RepositoryProvider.of<CoOperative>(
                                      context,
                                    ).clientCode,
                              },
                              body: {
                                "accountNumber": widget.accountNumber,
                                "mobileNumber": widget.mobileNumber,
                              },
                              apiEndpoint: "customer/signup/otp/resend",
                              mPin: "",
                            );
                          },
                          child: Text(
                            "Resend OTP",
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
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
