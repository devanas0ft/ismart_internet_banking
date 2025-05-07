import 'package:ismart_web/common/models/key_value.dart';
import 'package:ismart_web/common/utils/parse_utils.dart';

class UtilityResponseData {
  final String status;
  final String code;
  final String message;
  final String transactionIdentifier;
  final List<KeyValue> details;
  final dynamic detail;

  UtilityResponseData({
    required this.status,
    required this.code,
    required this.message,
    required this.transactionIdentifier,
    required this.details,
    required this.detail,
  });

  factory UtilityResponseData.fromJson(Map<String, dynamic> json) {
    dynamic detailData;

    if (json['detail'] is String) {
      detailData = json['detail'];
    } else if (json['detail'] is Map<String, dynamic>) {
      detailData = json['detail'];
    }
    return UtilityResponseData(
      status: json["status"] ?? "",
      code: json["code"] ?? "",
      message: json["message"] ?? "",
      transactionIdentifier: json["transactionIdentifier"] ?? "",
      details: ParseUtils.parseKeyValue(json['details'] ?? json['detail']),
      detail: detailData ?? "",
    );
  }

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

  String getStatusString() {
    if (status == "M0000") {
      return "Completed";
    }
    return "Failed";
  }

  bool isSuccessTransaction() {
    if (status == "M0000") {
      return true;
    }
    return false;
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "message": message,
    "details": details,
  };
}
