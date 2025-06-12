import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/shared_pref.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/common_detail_box.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/features/more/dateCalculator/date_calculator_page.dart';
import 'package:ismart_web/features/more/discountCalculator/discount_calculator_page.dart';
import 'package:ismart_web/features/more/emiCalculator/emi_calculator_page.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final ValueNotifier<bool> _isBiometricEnabled = ValueNotifier(false);

  // bool switchValue = false;

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
    return Scaffold(
      body: PageWrapper(
        body: CommonContainer(
          showDetail: false,
          showTitleText: false,
          showRoundBotton: false,
          verticalPadding: 0,
          topbarName: "Calculator",
          body: Column(
            children: [
              CommonDetailBox(
                leadingImage: Assets.discountCalculator,
                onBoxPressed: () {
                  NavigationService.push(
                    target: const DiscountCalculatorPage(),
                  );
                },
                detail: "",
                title: "Discount Calculator",
              ),
              const Divider(thickness: 1),
              CommonDetailBox(
                leadingImage: Assets.emiCalculator,
                onBoxPressed: () {
                  NavigationService.push(target: const EmiCalculatorPage());
                },
                detail: "",
                title: "EMI Calculator",
              ),
              const Divider(thickness: 1),
              CommonDetailBox(
                leadingImage: Assets.calenderIconDark,
                onBoxPressed: () {
                  NavigationService.push(target: const DateCalculatorPage());
                },
                detail: "",
                title: "Date Converter",
              ),
              const Divider(thickness: 1),
            ],
          ),
        ),
      ),
    );
  }
}
