import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/date_picker/date_picker_model.dart';
import 'package:ismart_web/common/date_picker/english_date_picker.dart';
import 'package:ismart_web/common/date_picker/nepali_date_picker.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:nepali_utils/nepali_utils.dart';

class DateCalculatorPage extends StatefulWidget {
  const DateCalculatorPage({Key? key}) : super(key: key);

  @override
  State<DateCalculatorPage> createState() => _DateCalculatorPageState();
}

class _DateCalculatorPageState extends State<DateCalculatorPage> {
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

  DateType currentMode = DateType.BS;

  final todayDate = DateTime.now();
  DateTime dateTime = DateTime.now();
  String? convertedDate;
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;

    return PageWrapper(
      body: CommonContainer(
        showRoundBotton: false,
        topbarName: "Date Converter",
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Date Type",
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold),
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
                      )
                      : NepaliDatePicker(
                        currentDate: currentDate.value.toNepaliDateTime(),
                        onChanged: (val) {
                          currentDate.value = val.toDateTime();
                        },
                      ),
            ),
            const SizedBox(height: 20),
            Text(
              "Date: " +
                  (currentMode == DateType.BS
                          ? currentDate.value
                          : currentDate.value.toNepaliDateTime())
                      .toString()
                      .substring(0, 10),
              style: _textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            CustomRoundedButtom(
              onPressed: () {
                DatePicker(
                  choosenType: currentMode,
                  dateInAD: currentDate.value,
                  dateInBS: currentDate.value.toNepaliDateTime(),
                );
                setState(() {});
              },
              title: "Convert",
            ),
          ],
        ),
      ),
    );
  }
}
