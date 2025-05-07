import 'package:ismart_web/common/utils/text_utils.dart';

class KeyValue<T> {
  final String title;
  final T value;
  final String id;

  KeyValue({required this.title, required this.value, this.id = ""});

  factory KeyValue.fromJson(Map<String, dynamic> json) {
    return KeyValue<T>(
      title: json.keys.first.toString(),
      value: json.values.first as T,
    );
  }

  String get formatedName {
    return TextUtils.replaceSpecialCharecterWithSpace(title);
  }

  Map<String, dynamic> tojson() {
    return {title: value};
  }
}
