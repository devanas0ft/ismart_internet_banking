import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';

class EmiCalculatorPage extends StatefulWidget {
  const EmiCalculatorPage({Key? key}) : super(key: key);

  @override
  State<EmiCalculatorPage> createState() => _EmiCalculatorPageState();
}

class _EmiCalculatorPageState extends State<EmiCalculatorPage> {
  double? loanAmount;
  double? annualInterestRate;
  double? loanTenure;
  double monthlyEMI = 0.0;
  double totalInterestPayable = 0.0;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final _height = SizeUtils.height;
    return PageWrapper(
      body: CommonContainer(
        topbarName: "Emi Calculator",
        showDetail: true,
        title: "EMI Calculator",
        detail: "Calculate EMI by providing the details below",
        body: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                height: _height * 0.1,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: _theme.scaffoldBackgroundColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Monthly Payment(EMI)",
                          style: _textTheme.titleSmall,
                        ),
                        Text(
                          "NPR ${monthlyEMI.toStringAsFixed(2)}",
                          style: _textTheme.labelLarge!.copyWith(
                            color: _theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Interest Payable",
                          style: _textTheme.titleSmall,
                        ),
                        Text(
                          "NPR ${totalInterestPayable.toStringAsFixed(2)}",
                          style: _textTheme.labelLarge!.copyWith(
                            color: _theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: _height * 0.02),
              CustomTextField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "required *";
                  }
                  return null;
                },
                textInputType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    loanAmount = double.parse(value);
                  });
                },
                title: "Enter Loan Amount",
                hintText: "NPR XXXXXXX",
              ),
              CustomTextField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "required *";
                  }
                  return null;
                },
                textInputType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    annualInterestRate = double.parse(value);
                  });
                },
                title: "Enter Annual Interest (%)",
                hintText: "%",
              ),
              CustomTextField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "required *";
                  }
                  return null;
                },
                textInputType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    loanTenure = double.parse(value);
                  });
                },
                title: "Enter Time Period (In Year)",
                hintText: "Interest",
              ),
            ],
          ),
        ),
        buttonName: "Calculate",
        onButtonPressed: () {
          if (_formKey.currentState!.validate()) {
            calculateEMI();
          }
        },
      ),
    );
  }

  void calculateEMI() {
    setState(() {
      final double monthlyInterestRate = annualInterestRate! / 12 / 100;
      final double numberOfMonths = loanTenure! * 12;

      monthlyEMI =
          (loanAmount! *
              monthlyInterestRate *
              (pow(1 + monthlyInterestRate, numberOfMonths))) /
          ((pow(1 + monthlyInterestRate, numberOfMonths)) - 1);

      totalInterestPayable = (monthlyEMI * numberOfMonths) - loanAmount!;
    });
  }
}
