import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/utils/responsive.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:pinput/pinput.dart';

class OptWidget extends StatefulWidget {
  final Function(String) onValueCallback;
  const OptWidget({super.key, required this.onValueCallback});

  @override
  State<OptWidget> createState() => _OptWidgetState();
}

class _OptWidgetState extends State<OptWidget> {
  String otpCodeInput = "";
  final GlobalKey<FormState> _otpKey = GlobalKey<FormState>();
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 72,
    textStyle: TextStyle(fontSize: 22, color: CustomTheme.primaryColor),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      border: Border.all(color: CustomTheme.gray),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      showBackButton: true,
      body: Column(
        children: [
          const SizedBox(height: 62),
          Column(
            children: [
              const SizedBox(height: 8),
              const Text(
                'OTP Code',
                style: TextStyle(
                  fontFamily: 'poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: Responsive.isDesktop(context) ? 80 : 24,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.isDesktop(context) ? 280 : 24,
                vertical: 40,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Form(
                key: _otpKey,
                child: Column(
                  children: [
                    const Icon(
                      Icons.verified_user,
                      size: 48,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Please enter your OTP to proceed.',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Enter the OTP code you received',
                      style: TextStyle(fontSize: 13, color: Colors.black45),
                    ),
                    const SizedBox(height: 20),

                    Pinput(
                      length: 6,

                      defaultPinTheme: defaultPinTheme,
                      separatorBuilder: (index) => const SizedBox(width: 8),
                      validator: (val) {
                        if (val == null) {
                          return "Please enter OTP.";
                        }
                        if (val.length < 6) {
                          return "Please enter valid OTP.";
                        }
                        return null;
                      },
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                      onCompleted: (pin) {
                        debugPrint('onCompleted: $pin');
                      },
                      onChanged: (value) {
                        otpCodeInput = value;
                        debugPrint('onChanged: $value');
                      },
                      cursor: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            width: 1,
                            height: 36,
                            color: CustomTheme.gray,
                          ),
                        ],
                      ),
                      focusedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: CustomTheme.primaryColor),
                        ),
                      ),
                      submittedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          color: CustomTheme.gray,
                          borderRadius: BorderRadius.circular(19),
                          border: Border.all(color: CustomTheme.primaryColor),
                        ),
                      ),
                      errorPinTheme: defaultPinTheme.copyBorderWith(
                        border: Border.all(color: Colors.redAccent),
                      ),
                    ),

                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,

                      child: CustomRoundedButtom(
                        title: "Submit",
                        onPressed: () {
                          if (_otpKey.currentState!.validate()) {
                            widget.onValueCallback(otpCodeInput);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Resend',
                        style: TextStyle(color: CustomTheme.primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
