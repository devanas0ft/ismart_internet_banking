import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/enum/text_field_type.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CustomPinCodeField extends StatelessWidget {
  final TextEditingController? controller;
  final int length;
  final void Function(String) onChanged;
  final bool isObscureText;
  final double? fieldHeight;
  final double? fieldWidth;
  final String? Function(String?)? validator;
  final TextFieldType type;
  final MainAxisAlignment mainAxisAlignment;
  const CustomPinCodeField({
    Key? key,
    this.controller,
    this.length = 4,
    required this.onChanged,
    this.isObscureText = true,
    this.fieldHeight,
    this.fieldWidth,
    this.validator,
    this.type = TextFieldType.Filled,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      child: PinCodeTextField(
        obscureText: isObscureText,
        appContext: context,
        length: length,
        blinkWhenObscuring: true,
        blinkDuration: const Duration(milliseconds: 450),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        errorTextMargin: const EdgeInsets.only(bottom: 5, top: 5),
        controller: controller,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: fieldHeight ?? 60,
          fieldWidth: fieldWidth ?? SizeUtils.width * 0.12,
          borderWidth: 1,
          errorBorderColor: Colors.red,
          fieldOuterPadding:
              mainAxisAlignment == MainAxisAlignment.start
                  ? const EdgeInsets.only(right: 10)
                  : EdgeInsets.zero,
          activeColor: theme.primaryColor,
          activeFillColor:
              type == TextFieldType.Filled
                  ? CustomTheme.gray
                  : Colors.transparent,
          selectedColor: theme.primaryColor,
          selectedFillColor:
              type == TextFieldType.Filled
                  ? CustomTheme.gray
                  : Colors.transparent,
          inactiveFillColor:
              type == TextFieldType.Filled
                  ? CustomTheme.gray
                  : Colors.transparent,
          inactiveColor:
              type == TextFieldType.Filled ? CustomTheme.gray : Colors.grey,
        ),
        mainAxisAlignment: mainAxisAlignment,
        animationType: AnimationType.fade,
        enableActiveFill: true,
        autovalidateMode: AutovalidateMode.disabled,
        cursorColor: theme.primaryColor,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
