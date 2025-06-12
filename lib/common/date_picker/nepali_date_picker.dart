import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ismart_web/common/date_picker/date_picker_list_widget.dart';
import 'package:ismart_web/common/date_picker/date_picker_utils.dart';
import 'package:nepali_utils/nepali_utils.dart';

class NepaliDatePicker extends StatefulWidget {
  final NepaliDateTime currentDate;
  final ValueChanged<NepaliDateTime> onChanged;
  final NepaliDateTime? maxDate;
  final NepaliDateTime? minDate;

  const NepaliDatePicker({
    Key? key,
    required this.currentDate,
    required this.onChanged,
    this.maxDate,
    this.minDate,
  }) : super(key: key);

  @override
  _NepaliDatePickerState createState() => _NepaliDatePickerState();
}

class _NepaliDatePickerState extends State<NepaliDatePicker> {
  int currentYear = 2078;
  String currentMonth = DatePickerUtils.nepaliMonths.first;
  int currentDay = 1;

  late FixedExtentScrollController _yearController;

  late FixedExtentScrollController _monthController;

  late FixedExtentScrollController _dayController;

  List<String> _days = [];

  List<String> _months = [];

  _updateDays(int year, String month) {
    setState(() {
      _days = DatePickerUtils.nepaliDaysBetweenDates(
        currentYear: currentYear,
        currentMonth: currentMonth,
        maxDate: widget.maxDate,
        minDate: widget.minDate,
      );
      final _index = _days.indexOf(currentDay.toString());
      if (_index == -1) {
        currentDay = 1;
      }
      _dayController.jumpToItem(_index == -1 ? 0 : _index);
    });
  }

  _updateMonths(int year) {
    setState(() {
      _months = DatePickerUtils.nepaliMonthBetweenDates(
        currentYear: year,
        maxDate: widget.maxDate,
        minDate: widget.minDate,
      );
      final _index = _months.indexWhere((e) => e == currentMonth);

      if (_index == -1) {
        currentMonth = _months.first;
      }
      _monthController.jumpToItem(_index == -1 ? 0 : _index);
    });
  }

  onChanged(int year, String month, int day) {
    final int m = DatePickerUtils.nepaliMonths.indexWhere(
      (e) => e.toLowerCase() == month.toLowerCase(),
    );
    widget.onChanged(NepaliDateTime(year, m + 1, day));
  }

  @override
  void initState() {
    super.initState();

    currentYear = widget.currentDate.year;
    currentMonth = DatePickerUtils.nepaliMonths[widget.currentDate.month - 1];
    currentDay = widget.currentDate.day;

    final int _yearIndex = DatePickerUtils.nepaliYearsBetweenDates(
      maxDate: widget.maxDate,
      minDate: widget.minDate,
    ).indexOf(currentYear.toString());
    _yearController = FixedExtentScrollController(
      initialItem: _yearIndex == -1 ? 0 : _yearIndex,
    );

    _months = DatePickerUtils.nepaliMonthBetweenDates(
      currentYear: currentYear,
      maxDate: widget.maxDate,
      minDate: widget.minDate,
    );
    final int _monthIndex = _months.indexOf(currentMonth);
    _monthController = FixedExtentScrollController(
      initialItem: _monthIndex == -1 ? 0 : _monthIndex,
    );

    _days = DatePickerUtils.nepaliDaysBetweenDates(
      currentYear: currentYear,
      currentMonth: currentMonth,
      maxDate: widget.maxDate,
      minDate: widget.minDate,
    );

    final int _dayIndex = _days.indexOf(currentDay.toString());
    _dayController = FixedExtentScrollController(
      initialItem: _dayIndex == -1 ? 0 : _dayIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: DatePickerListWidget(
              items: _months,
              currentValue: currentMonth,
              controller: _monthController,
              onChanged: (val) {
                currentMonth = val;
                _updateDays(currentYear, val);
                onChanged(currentYear, val, currentDay);
              },
            ),
          ),
          Expanded(
            child: DatePickerListWidget(
              items: _days,
              currentValue: currentDay.toString(),
              controller: _dayController,
              onChanged: (val) {
                currentDay = int.parse(val);
                onChanged(currentYear, currentMonth, currentDay);
              },
            ),
          ),
          Expanded(
            child: DatePickerListWidget(
              items: DatePickerUtils.nepaliYearsBetweenDates(
                maxDate: widget.maxDate,
                minDate: widget.minDate,
              ),
              currentValue: currentYear.toString(),
              controller: _yearController,
              onChanged: (val) {
                currentYear = int.parse(val);
                _updateMonths(currentYear);
                _updateDays(currentYear, currentMonth);
                onChanged(currentYear, currentMonth, currentDay);
              },
            ),
          ),
        ],
      ),
    );
  }
}
