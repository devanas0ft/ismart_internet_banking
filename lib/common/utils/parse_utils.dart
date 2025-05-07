import 'package:ismart_web/common/models/key_value.dart';

class ParseUtils {
  static List<KeyValue> parseKeyValue<T>(T json) {
    List<KeyValue> _temp = [];
    if (json is List) {
      print("isList");
      _temp = [KeyValue(title: "data", value: json)];
      return _temp;
    } else if (json is Map<String, dynamic>) {
      for (MapEntry<String, dynamic> item in json.entries.toList()) {
        if (item.value is String) {
          _temp.add(KeyValue<String>(title: item.key, value: item.value));
        } else if (item.value is int) {
          _temp.add(KeyValue<int>(title: item.key, value: item.value as int));
        } else if (item.value is double) {
          _temp.add(
            KeyValue<double>(title: item.key, value: item.value as double),
          );
        } else if (item.value is bool) {
          _temp.add(KeyValue<bool>(title: item.key, value: item.value as bool));
        } else if (item.value is List) {
          _temp.add(KeyValue<List>(title: item.key, value: item.value as List));
        } else if (item.value is Map) {
          _temp.add(KeyValue<Map>(title: item.key, value: item.value as Map));
        } else {
          _temp.add(
            KeyValue<String>(title: item.key, value: item.value.toString()),
          );
        }
      }
    }
    return _temp;
  }

  // T? findValue<T>({required List<KeyValue> properties, required String name}) {
  //   final _index = properties.indexWhere(
  //       (e) => e.title == name && (T is dynamic ? true : e.value is T));
  //   if (_index == -1) {
  //     return null;
  //   } else {
  //     return  [_index].value;
  //   }
  // }

  String findValueString(
    String name, {
    required List<KeyValue> properties,
    String emptyString = "-",
  }) {
    final _index = properties.indexWhere((e) => e.title == name);
    if (_index == -1) {
      return emptyString;
    } else {
      return properties[_index].value.toString();
    }
  }

  // static List<Steps> generateSteps(Map<String, dynamic> json) {
  //   final List<Map<String, dynamic>> response = List.from(
  //       json["response_object"] is Map ? [] : (json["response_object"] ?? []));
  //   final List<Map<String, dynamic>> requests = List.from(
  //       json["request_object"] is Map ? [] : (json["request_object"] ?? []));

  //   final _tempSteps = [...response, ...requests]
  //       .fold<List<Map<String, dynamic>>>(
  //         [],
  //         (pv, nv) {
  //           bool _isResponse = nv.keys.contains("response_fields");

  //           final _oldValue = pv.firstWhere((e) => e["step_name"] == nv["step"],
  //               orElse: () => {});

  //           return [
  //             ...pv.where((e) => e["step_name"] != nv["step"]),
  //             {
  //               "step_name": nv["step"],
  //               "response": _isResponse ? nv : _oldValue["response"],
  //               "request": _isResponse ? _oldValue["request"] : nv,
  //             }
  //           ];
  //         },
  //       )
  //       .map((e) => Steps.fromJson(e))
  //       .toList();

  //   return _tempSteps;
  // }

  static String parseDouble(double number) {
    String formattedAmount = number.toString();
    if (formattedAmount.endsWith('.00')) {
      return formattedAmount.substring(0, formattedAmount.length - 3);
    }
    return formattedAmount;
  }
}
