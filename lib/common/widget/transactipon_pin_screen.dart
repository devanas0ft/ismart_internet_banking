import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/shared_pref.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/custom_pin_field.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';

class TransactionPinScreen extends StatefulWidget {
  final Function(String) onValueCallback;
  final bool showBiometric;

  const TransactionPinScreen({
    super.key,
    required this.onValueCallback,
    this.showBiometric = true,
  });
  @override
  State<TransactionPinScreen> createState() => _TransactionPinScreenState();
}

class _TransactionPinScreenState extends State<TransactionPinScreen> {
  String pinValue = "";

  final ValueNotifier<bool> _isBiometricEnabled = ValueNotifier(false);

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _pinCodeController = TextEditingController();
  @override
  void initState() {
    _checkBiometric();
    super.initState();
  }

  _checkBiometric() async {
    final bool? isLocalBiometricEnabled = await SharedPref.getBiometricLogin();
    if (isLocalBiometricEnabled != null && isLocalBiometricEnabled) {
      _isBiometricEnabled.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _height = SizeUtils.height;

    final width = SizeUtils.width;
    final height = SizeUtils.height;
    final _theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: _height * 0.03),
                Container(
                  padding: const EdgeInsets.all(30),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: CustomTheme.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        Assets.verify,
                        color: const Color(0xff4E4E4E),
                        height: _height * 0.05,
                      ),
                      SizedBox(height: _height * 0.02),
                      Text(
                        "Enter your Security Pin",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(height: _height * 0.01),
                      Text(
                        "Please enter your Security Pin to proceed.",
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: _height * 0.04),
                      //TODO need to remove condition ,using just for test
                      CustomPinCodeField(
                        // length: 5,
                        controller: _pinCodeController,

                        length:
                            RepositoryProvider.of<CustomerDetailRepository>(
                                      context,
                                    ).customerDetailModel.value?.mobileNumber ==
                                    "9813894737"
                                ? 6
                                : 5,
                        onChanged: (p0) {
                          pinValue = p0;
                        },
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "PIN Code field cannot be empty";
                          } else if (val.length < 5) {
                            return "PIN code cannot be less than 5 characters.";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: _height * 0.05),
                      CustomRoundedButtom(
                        title: "Proceed",
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            widget.onValueCallback(pinValue);
                          }
                        },
                      ),
                      SizedBox(height: _height * 0.01),
                      SizedBox(height: size.height * 0.01),
                      SizedBox(height: height * 0.014),
                      if (widget.showBiometric == true)
                        ValueListenableBuilder<bool>(
                          valueListenable: _isBiometricEnabled,
                          builder: (context, val, _) {
                            if (val) {
                              return InkWell(
                                onTap: () async {
                                  // final bool authenticated =
                                  //     await FingerPrintUtils
                                  //         .verifyFingerPrint(
                                  //   context: NavigationService.context,
                                  // );
                                  // if (authenticated) {
                                  //   final String password =
                                  //       await SecureStorageService
                                  //           .appPassword;

                                  //   if (password.isNotEmpty) {
                                  //     widget.onValueCallback(password);
                                  //   }
                                  // }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.fingerprint, size: 35),
                                    SizedBox(width: width * 0.03),
                                    Text(
                                      "User Biometric ",
                                      style: _theme.textTheme.labelMedium,
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      TextButton(
                        onPressed: () {
                          NavigationService.pop();
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
