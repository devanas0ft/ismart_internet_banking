import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/date_picker/date_picker_model.dart';
import 'package:ismart_web/common/date_picker/english_date_picker.dart';
import 'package:ismart_web/common/date_picker/nepali_date_picker.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/wrapper/bottom_sheet_wrapper.dart';
import 'package:nepali_utils/nepali_utils.dart';

showDatePickerBottomSheet({
  required BuildContext context,
  required ValueChanged<DatePicker> onChanged,
  DateTime? maxDate,
  DateTime? minDate,
  required DateTime currentDate,
  final String? title,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(36),
        topRight: Radius.circular(36),
      ),
    ),
    builder: (context) {
      return DatePickerBottomSheet(
        onChanged: onChanged,
        maxDate: maxDate,
        minDate: minDate,
        currentDate: currentDate,
        title: title,
      );
    },
  );
}

class DatePickerBottomSheet extends StatefulWidget {
  final ValueChanged<DatePicker> onChanged;
  final DateTime? maxDate;
  final DateTime? minDate;
  final DateTime currentDate;
  final String? title;

  const DatePickerBottomSheet({
    Key? key,
    required this.onChanged,
    this.maxDate,
    this.minDate,
    required this.currentDate,
    this.title,
  }) : super(key: key);

  @override
  _DatePickerBottomSheetState createState() => _DatePickerBottomSheetState();
}

class _DatePickerBottomSheetState extends State<DatePickerBottomSheet> {
  DateType currentMode = DateType.BS;

  ValueNotifier<DateTime> currentDate = ValueNotifier(DateTime.now());

  _buildSelectableButton({
    required Function()? onPressed,
    required String title,
    required ThemeData theme,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.hp, vertical: 4.hp),
        margin: EdgeInsets.symmetric(horizontal: 4.hp),
        child: Text(
          title,
          textScaleFactor: SizeUtils.textScaleFactor,
          style: theme.textTheme.titleLarge!.copyWith(
            color: isSelected ? theme.primaryColor : (CustomTheme.gray),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  _buildButton({
    required Function()? onPressed,
    required String title,
    required ThemeData theme,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Text(
          title,
          textScaleFactor: SizeUtils.textScaleFactor,
          style: theme.textTheme.titleLarge!.copyWith(
            color: CustomTheme.primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    currentDate.value = widget.currentDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;

    return BottomSheetWrapper(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title ?? "Select DOB",
                textScaleFactor: SizeUtils.textScaleFactor,
                style: _textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                children: [
                  _buildSelectableButton(
                    onPressed: () {
                      setState(() {
                        currentMode = DateType.BS;
                      });
                    },
                    title: "BS",
                    theme: _theme,
                    isSelected: currentMode == DateType.BS,
                  ),
                  _buildSelectableButton(
                    onPressed: () {
                      setState(() {
                        currentMode = DateType.AD;
                      });
                    },
                    title: "AD",
                    theme: _theme,
                    isSelected: currentMode == DateType.AD,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child:
                currentMode == DateType.AD
                    ? EnglishDatePicker(
                      currentDate: currentDate.value,
                      onChanged: (date) {
                        currentDate.value = date;
                      },
                      maxDate: widget.maxDate,
                      minDate: widget.minDate,
                    )
                    : NepaliDatePicker(
                      currentDate: currentDate.value.toNepaliDateTime(),
                      onChanged: (val) {
                        currentDate.value = val.toDateTime();
                      },
                      maxDate: widget.maxDate?.toNepaliDateTime(),
                      minDate: widget.minDate?.toNepaliDateTime(),
                    ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildButton(
                onPressed: () {
                  NavigationService.pop();
                },
                title: "Cancel",
                theme: _theme,
              ),
              _buildButton(
                onPressed: () {
                  widget.onChanged(
                    DatePicker(
                      choosenType: currentMode,
                      dateInAD: currentDate.value,
                      dateInBS: currentDate.value.toNepaliDateTime(),
                    ),
                  );
                  // NavigationService.pop();
                },
                title: "Save",
                theme: _theme,
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
