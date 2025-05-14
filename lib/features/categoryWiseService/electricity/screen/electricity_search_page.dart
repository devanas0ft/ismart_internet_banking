import 'package:flutter/material.dart';
import 'package:ismart_web/common/enum/counters_fetch_enum.dart';
import 'package:ismart_web/common/models/key_value.dart';
import 'package:ismart_web/features/categoryWiseService/electricity/widget/nea_search_widget.dart';

class CounterSearchPage extends StatelessWidget {
  final CountersEnums counterType;
  const CounterSearchPage({
    Key? key,
    required this.onChanged,
    required this.counterType,
  }) : super(key: key);

  final Function(KeyValue?) onChanged;
  @override
  Widget build(BuildContext context) {
    return CountersSearchWidget(
      onChanged: onChanged,
      countersEnums: counterType,
    );
  }
}
