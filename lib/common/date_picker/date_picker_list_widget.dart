import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/utils/size_utils.dart';

class DatePickerListWidget extends StatelessWidget {
  final List<String> items;
  final ValueChanged<String> onChanged;
  final String currentValue;
  final FixedExtentScrollController controller;

  const DatePickerListWidget({
    Key? key,
    required this.items,
    required this.currentValue,
    required this.onChanged,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Container(
      height: 170,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: CupertinoPicker.builder(
        itemExtent: 45,
        childCount: items.length,
        selectionOverlay: Container(
          height: 45,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: CustomTheme.lightGray.withOpacity(0.4),
                width: 1.7,
              ),
              bottom: BorderSide(
                color: CustomTheme.lightGray.withOpacity(0.4),
                width: 1.7,
              ),
            ),
          ),
        ),
        scrollController: controller,
        diameterRatio: 1.1,
        squeeze: 1,
        itemBuilder: (context, index) {
          return Container(
            height: 45,
            alignment: Alignment.center,
            child: Text(
              items[index],
              textScaleFactor: SizeUtils.textScaleFactor,
              style: _theme.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        },
        onSelectedItemChanged: (value) {
          onChanged(items[value]);
        },
      ),
    );
  }
}
