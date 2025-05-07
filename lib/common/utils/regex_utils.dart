import 'package:ismart_web/features/utility_payment/enums/topup_type.dart';

class RegexUtils {
  static TopupType checkPhoneNumberType(String number) {
    final ntcPostpaid = RegExp("^[9][8][5][0-9]{7}\$");
    final ntc = RegExp("([9][7-9][4-6][0-9]{7})");
    final ncell = RegExp("([9][7-8][0-2][0-9]{7})");
    final smartCell = RegExp("([9][6][0-9]{8}|[9][8][8][0-9]{7})");
    if (ntcPostpaid.hasMatch(number)) {
      return TopupType.NTCPostpaid;
    } else if (ntc.hasMatch(number)) {
      return TopupType.NTCPrepaid;
    } else if (ncell.hasMatch(number)) {
      return TopupType.Ncell;
    } else if (smartCell.hasMatch(number)) {
      return TopupType.SmartCell;
    } else {
      return TopupType.None;
    }
  }

  static String get scNumber =>
      "([a-zA-Z0-9]{3}[.][a-zA-Z0-9]{2}[.][a-zA-Z0-9\-\ ]+)";

  static String get customerId => "([0-9]+)";

  static String khanepaniCustomerCode = "([a-zA-Z0-9_\-]+)";

  static String vianetUserName = "([a-zA-Z0-9_]+)";

  static String subisuUserName = "([a-zA-Z0-9_]+)";

  static String clearTvSubcriptionID = "([a-zA-Z0-9_]+)";

  static String simTvCustomerId = "([0-9]{10,11})";

  static String dishHomeCasId = "([a-zA-Z0-9]{4,11})";
  static String ntcNumber = "([9][7-8][4-6][0-9]{7})";
  static String ncellNumber = "([9][8][0-2][0-9]{7})";
  static String smartCellNumber = "([9][6][0-9]{8}|[9][8][8][0-9]{7})";
}
