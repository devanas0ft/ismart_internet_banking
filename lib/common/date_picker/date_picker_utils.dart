import 'package:nepali_utils/nepali_utils.dart';

class DatePickerUtils {
  static final List<String> englishYears =
      List.generate(100, (index) => (1943 + index).toString());

  static final _englishMinDate = DateTime(1943, 1, 1);
  static final _englishMaxDate = DateTime(2043, 12, 31);

  static final _nepaliMinDate = NepaliDateTime(2000, 1, 1);
  static final _nepaliMaxDate = NepaliDateTime(2100, 12, 30);

  static List<String> englishYearsBetweenDates(
      {DateTime? minDate, DateTime? maxDate}) {
    if (minDate != null && maxDate != null) {
      final int temp = maxDate.year - minDate.year;
      return List.generate(
          temp + 1, (index) => (minDate.year + index).toString());
    } else if (minDate != null && maxDate == null) {
      final int temp = 2043 - minDate.year;
      return List.generate(
          temp + 1, (index) => (minDate.year + index).toString());
    } else if (minDate == null && maxDate != null) {
      final int temp = maxDate.year - 1943;
      return List.generate(temp + 1, (index) => (1943 + index).toString());
    } else {
      return List.generate(100, (index) => (1943 + index).toString());
    }
  }

  static final List<String> nepaliYears =
      List.generate(100, (index) => (2000 + index).toString());

  static List<String> nepaliYearsBetweenDates(
      {NepaliDateTime? minDate, NepaliDateTime? maxDate}) {
    if (minDate != null && maxDate != null) {
      final int temp = maxDate.year - minDate.year;
      return List.generate(
          temp + 1, (index) => (minDate.year + index).toString());
    } else if (minDate != null && maxDate == null) {
      final int temp = 2100 - minDate.year;
      return List.generate(
          temp + 1, (index) => (minDate.year + index).toString());
    } else if (minDate == null && maxDate != null) {
      final int temp = maxDate.year - 2000;
      return List.generate(temp + 1, (index) => (2000 + index).toString());
    } else {
      return List.generate(100, (index) => (2000 + index).toString());
    }
  }

  static List<String> englishMonthsBetweenDates({
    DateTime? minDate,
    DateTime? maxDate,
    required int currentYear,
  }) {
    minDate ??= _englishMinDate;
    maxDate ??= _englishMaxDate;
    if (minDate.year == currentYear && currentYear == maxDate.year) {
      if (minDate.month == maxDate.month) {
        return [englishMonths[minDate.month - 1]];
      } else {
        return englishMonths.sublist(minDate.month - 1, maxDate.month);
      }
    } else if (currentYear <= minDate.year) {
      return englishMonths.sublist(minDate.month - 1, 12);
    } else if (currentYear >= maxDate.year) {
      return englishMonths.sublist(0, maxDate.month);
    } else {
      return englishMonths;
    }
  }

  static List<String> nepaliMonthBetweenDates({
    NepaliDateTime? minDate,
    NepaliDateTime? maxDate,
    required int currentYear,
  }) {
    minDate ??= _nepaliMinDate;
    maxDate ??= _nepaliMaxDate;
    if (minDate.year == currentYear && currentYear == maxDate.year) {
      if (minDate.month == maxDate.month) {
        return [nepaliMonths[minDate.month - 1]];
      } else {
        return nepaliMonths.sublist(minDate.month - 1, maxDate.month);
      }
    } else if (currentYear <= minDate.year) {
      return nepaliMonths.sublist(minDate.month - 1, 12);
    } else if (currentYear >= maxDate.year) {
      return nepaliMonths.sublist(0, maxDate.month);
    } else {
      return nepaliMonths;
    }
  }

  static List<String> englishDaysBetweenDates({
    DateTime? minDate,
    DateTime? maxDate,
    required int currentYear,
    required String currentMonth,
  }) {
    minDate ??= _englishMinDate;
    maxDate ??= _englishMaxDate;
    final int maxDay = findEnglishLastDate(currentYear, currentMonth);
    final _monthInt = _englishMonthIndex(currentMonth) + 1;
    if (minDate.year == currentYear &&
        currentYear == maxDate.year &&
        minDate.month == _monthInt &&
        maxDate.month == _monthInt) {
      if (minDate.day == maxDate.day) {
        return [minDate.day.toString()];
      } else {
        return List.generate(maxDate.day - minDate.day,
            (index) => (minDate!.day + index + 1).toString());
      }
    } else if (currentYear <= minDate.year && _monthInt <= minDate.month) {
      return List.generate((maxDay - minDate.day) + 1,
          (index) => (minDate!.day + index).toString());
    } else if (currentYear >= maxDate.year && _monthInt >= maxDate.month) {
      return List.generate(maxDate.day, (index) => (index + 1).toString());
    } else {
      return List.generate(maxDay, (index) => (index + 1).toString());
    }
  }

  static List<String> nepaliDaysBetweenDates({
    NepaliDateTime? minDate,
    NepaliDateTime? maxDate,
    required int currentYear,
    required String currentMonth,
  }) {
    minDate ??= _nepaliMinDate;
    maxDate ??= _nepaliMaxDate;
    final int maxDay = findNepaliLastDate(currentYear, currentMonth);
    final _monthInt = _nepaliMonthIndex(currentMonth) + 1;
    if (minDate.year == currentYear &&
        currentYear == maxDate.year &&
        minDate.month == _monthInt &&
        maxDate.month == _monthInt) {
      if (minDate.day == maxDate.day) {
        return [minDate.day.toString()];
      } else {
        return List.generate(maxDate.day - minDate.day,
            (index) => (minDate!.day + index + 1).toString());
      }
    } else if (currentYear <= minDate.year && _monthInt <= minDate.month) {
      return List.generate((maxDay - minDate.day) + 1,
          (index) => (minDate!.day + index).toString());
    } else if (currentYear >= maxDate.year && _monthInt >= maxDate.month) {
      return List.generate(maxDate.day, (index) => (index + 1).toString());
    } else {
      return List.generate(maxDay, (index) => (index + 1).toString());
    }
  }

  static final List<String> englishMonths = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  static final List<String> nepaliMonths = [
    "Baishakh",
    "Jestha",
    "Asar",
    "Shrawan",
    "Bhadau",
    "Aswin",
    "Kartik",
    "Mansir",
    "Poush",
    "Magh",
    "Falgun",
    "Chaitra",
  ];

  static final _nepaliYearsMonthMapping = [
    [30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
    [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    [31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
    [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    [30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
    [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    [31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
    [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    [31, 31, 31, 32, 31, 31, 29, 30, 30, 29, 29, 31],
    [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    [31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
    [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    [31, 31, 31, 32, 31, 31, 29, 30, 30, 29, 30, 30],
    [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    [31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
    [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    [31, 31, 31, 32, 31, 31, 29, 30, 30, 29, 30, 30],
    [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    [31, 32, 31, 32, 31, 30, 30, 29, 30, 29, 30, 30],
    [31, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
    [31, 31, 31, 32, 31, 31, 30, 29, 30, 29, 30, 30],
    [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 30],
    [31, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
    [31, 31, 31, 32, 31, 31, 30, 29, 30, 29, 30, 30],
    [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    [30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
    [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    [31, 31, 32, 31, 32, 30, 30, 29, 30, 29, 30, 30],
    [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    [30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
    [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    [31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
    [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    [30, 32, 31, 32, 31, 31, 29, 30, 30, 29, 29, 31],
    [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    [31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
    [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    [31, 31, 31, 32, 31, 31, 29, 30, 30, 29, 30, 30],
    [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    [31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
    [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    [31, 31, 31, 32, 31, 31, 29, 30, 30, 29, 30, 30],
    [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    [31, 32, 31, 32, 31, 30, 30, 29, 30, 29, 30, 30],
    [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    [31, 31, 31, 32, 31, 31, 30, 29, 30, 29, 30, 30],
    [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 30],
    [31, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
    [31, 31, 31, 32, 31, 31, 30, 29, 30, 29, 30, 30],
    [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 30],
    [31, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
    [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    [31, 31, 32, 31, 32, 30, 30, 29, 30, 29, 30, 30],
    [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    [30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
    [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    [31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
    [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    [30, 32, 31, 32, 31, 31, 29, 30, 29, 30, 29, 31],
    [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    [31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
    [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    [31, 31, 31, 32, 31, 31, 29, 30, 30, 29, 29, 31],
    [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    [31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
    [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    [31, 31, 31, 32, 31, 31, 29, 30, 30, 29, 30, 30],
    [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    [31, 32, 31, 32, 31, 30, 30, 29, 30, 29, 30, 30],
    [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    [31, 31, 31, 32, 31, 31, 30, 29, 30, 29, 30, 30],
    [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 30],
    [31, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
    [31, 31, 31, 32, 31, 31, 30, 29, 30, 29, 30, 30],
    [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 30],
    [31, 31, 32, 32, 31, 30, 30, 30, 29, 30, 30, 30],
    [30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 30, 30],
    [31, 31, 32, 31, 31, 30, 30, 30, 29, 30, 30, 30],
    [31, 31, 32, 31, 31, 30, 30, 30, 29, 30, 30, 30],
    [31, 32, 31, 32, 30, 31, 30, 30, 29, 30, 30, 30],
    [30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 30, 30],
    [31, 31, 32, 31, 31, 31, 30, 30, 29, 30, 30, 30],
    [30, 31, 32, 32, 30, 31, 30, 30, 29, 30, 30, 30],
    [30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 30, 30],
    [30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 30, 30]
  ];

  static int _englishMonthIndex(String month) {
    return DatePickerUtils.englishMonths
        .indexWhere((e) => e.toLowerCase() == month.toLowerCase());
  }

  static int _nepaliMonthIndex(String month) {
    return DatePickerUtils.nepaliMonths
        .indexWhere((e) => e.toLowerCase() == month.toLowerCase());
  }

  static int findEnglishLastDate(int year, String month) {
    final monthIndex = _englishMonthIndex(month);
    final _date = DateTime(year, monthIndex + 2, 0);
    return _date.day;
  }

  static int findNepaliLastDate(int year, String month) {
    final intYear = year - 2000;
    final monthIndex = _nepaliMonthIndex(month);
    if (intYear < 0 || intYear > 90 || monthIndex == -1) {
      return 30;
    }
    return _nepaliYearsMonthMapping[intYear][monthIndex];
  }
}
