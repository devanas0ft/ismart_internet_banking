import 'package:flutter/material.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';

class DiscountCalculatorPage extends StatefulWidget {
  const DiscountCalculatorPage({Key? key}) : super(key: key);

  @override
  State<DiscountCalculatorPage> createState() => _DiscountCalculatorPageState();
}

class _DiscountCalculatorPageState extends State<DiscountCalculatorPage> {
  double originalPrice = 0.0;
  double discountPercentage = 0.0;
  double discountedPrice = 0.0;
  double savings = 0.0;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final _height = SizeUtils.height;
    return PageWrapper(
      body: CommonContainer(
        topbarName: "Discount Calculator",
        showDetail: true,
        title: "Discount Calculator",
        detail: "Calculate Discount by providing the details below",
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
                        Text("Total Savings", style: _textTheme.titleSmall),
                        Text(
                          "NPR ${savings.toStringAsFixed(2)}",
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
                          "Amount After Discount",
                          style: _textTheme.titleSmall,
                        ),
                        Text(
                          "NPR ${discountedPrice.toStringAsFixed(2)}",
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
                    originalPrice = double.parse(value);
                  });
                },
                title: "Enter Total Amount",
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
                    discountPercentage = double.parse(value);
                  });
                },
                title: "Enter Disount Percentage (%)",
                hintText: "%",
              ),
            ],
          ),
        ),
        buttonName: "Calculate",
        onButtonPressed: () {
          if (_formKey.currentState!.validate()) {
            calculateDiscount();
          }
        },
      ),
    );
  }

  void calculateDiscount() {
    setState(() {
      discountedPrice =
          originalPrice - (originalPrice * discountPercentage / 100);
      savings = originalPrice - discountedPrice;
    });
  }
}
