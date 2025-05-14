import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/utils/size_utils.dart';

class CommonTableWidget extends StatelessWidget {
  final List<List<String>> values;
  const CommonTableWidget({Key? key, required this.values})
    : assert(values.length >= 1),
      super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;

    final titleStyle = _textTheme.labelLarge!.copyWith(
      fontSize: 11,
      fontWeight: FontWeight.bold,
      color: CustomTheme.darkGray,
    );

    final bodyStyle = _textTheme.labelLarge!.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 11,
    );

    final _dataList = values.sublist(1);

    return Table(
      children: [
        TableRow(
          children: List.generate(values.first.length, (index) {
            return Container(
              padding: EdgeInsets.only(bottom: 10.hp),
              child: Text(
                values.first[index],
                textAlign: TextAlign.center,
                textScaleFactor: SizeUtils.textScaleFactor,
                style: titleStyle,
              ),
            );
          }),
        ),
        ...List.generate(_dataList.length, (index) {
          return TableRow(
            children: List.generate(_dataList[index].length, (subIndex) {
              return Container(
                padding: EdgeInsets.only(
                  bottom: index == (values.length - 1) ? 0 : 5.hp,
                ),
                child: Text(
                  _dataList[index][subIndex],
                  textAlign: TextAlign.center,
                  textScaleFactor: SizeUtils.textScaleFactor,
                  style: bodyStyle,
                ),
              );
            }),
          );
        }),
      ],
    );
  }
}
