import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/custom_pin_field.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/top_widget.dart';

// ignore: must_be_immutable
class BankTransferOTPWidget extends StatelessWidget {
  final String otpAmountLimit;

  BankTransferOTPWidget({
    required this.onValueCallback,
    required this.otpAmountLimit,
  });

  final Function(String) onValueCallback;

  String otpCodeInput = "";

  final TextEditingController _textController = TextEditingController();

  final GlobalKey<FormState> _otpKey = GlobalKey<FormState>();

  final _height = SizeUtils.height;

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      showAppBar: false,
      body: SafeArea(
        child: ListView(
          children: [
            GuthiTopWidget(),
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
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.headlineSmall,
                      children: [
                        TextSpan(
                          text: "You are doing transaction more than ",
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(color: CustomTheme.googleColor),
                        ),
                        TextSpan(
                          text: "$otpAmountLimit . ",
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            color: CustomTheme.googleColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text:
                              "\nPlease enter your OTP to proceed the transaction.",
                        ),
                      ],
                    ),
                  ),
                  // Text(
                  //   "You are doing transction more than $otpAmountLimit .Please enter your OTP to proceed the transaction.",
                  //   style: Theme.of(context).textTheme.headlineSmall,
                  //   textAlign: TextAlign.center,
                  // ),
                  SizedBox(height: _height * 0.04),
                  Form(
                    key: _otpKey,
                    child: CustomPinCodeField(
                      length: 6,
                      fieldHeight: 50,
                      fieldWidth: 45,
                      controller: _textController,
                      validator: (val) {
                        if (val == null) {
                          return "Please enter OTP.";
                        }
                        if (val.length < 6) {
                          return "Please enter valid OTP.";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        otpCodeInput = val;
                      },
                    ),
                  ),
                  SizedBox(height: _height * 0.03),
                  CustomRoundedButtom(
                    title: "Proceed",
                    onPressed: () {
                      if (_otpKey.currentState!.validate()) {
                        onValueCallback(otpCodeInput);
                      }
                      // Get.to(() => const SetupMpin());
                    },
                  ),
                  SizedBox(height: _height * 0.03),
                  TextButton(
                    onPressed: () {
                      NavigationService.pop();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
