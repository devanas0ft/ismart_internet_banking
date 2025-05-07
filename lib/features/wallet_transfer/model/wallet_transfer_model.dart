import 'package:ismart_web/common/models/key_value.dart';
import 'package:ismart_web/common/utils/parse_utils.dart';

class WalletTransferModel {
  final String status;
  final String code;
  final String message;
  // final Details details;
  final List<KeyValue> details;

  WalletTransferModel({
    required this.status,
    required this.code,
    required this.message,
    // required this.details,
    required this.details,
  });

  factory WalletTransferModel.fromJson(Map<String, dynamic> json) =>
      WalletTransferModel(
        status: json["status"] ?? "",
        code: json["code"] ?? "",
        message: json["message"] ?? "",
        // details: Details.fromJson(json["details"]),
        details: ParseUtils.parseKeyValue(json['details']),
      );
  T? findValue<T>({required String primaryKey, String? secondaryKey}) {
    final _index = details.indexWhere(
      // ignore: unnecessary_type_check
      (e) => e.title == primaryKey && (T is dynamic ? true : e.value is T),
    );
    if (_index == -1) {
      return null;
    } else {
      if (secondaryKey != null) {
        return details[_index].value[secondaryKey] ?? "";
      }
      return details[_index].value;
    }
  }

  String findValueString(String primaryKey, {String emptyString = "-"}) {
    final _index = details.indexWhere((e) => e.title == primaryKey);
    if (_index == -1) {
      return emptyString;
    } else {
      return details[_index].value.toString();
    }
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "message": message,
    // "details": details.toJson(),
    "details": details,
  };
}
