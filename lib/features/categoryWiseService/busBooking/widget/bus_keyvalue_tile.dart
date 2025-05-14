import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/utils/size_utils.dart';

class BusKeyValueTile extends StatelessWidget {
  final String title;
  final String value;
  final Axis axis;
  final bool useCustomThemeTitle;
  final bool useCustomThemeValue;
  final TextStyle titleTheme;
  final TextStyle valueTheme;

  final CrossAxisAlignment horizontalCrossAxis;

  const BusKeyValueTile({
    Key? key,
    required this.title,
    required this.value,
    required this.useCustomThemeTitle,
    required this.useCustomThemeValue,
    required this.axis,
    required this.horizontalCrossAxis,
    required this.titleTheme,
    required this.valueTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Container(
      child:
          axis == Axis.horizontal
              ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: _theme.textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: CustomTheme.primaryColor,
                    ),
                  ),
                  SizedBox(width: 20.wp),
                  Expanded(
                    child: Text(
                      value,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: _theme.textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: CustomTheme.darkerBlack,
                      ),
                    ),
                  ),
                ],
              )
              : Column(
                crossAxisAlignment: horizontalCrossAxis,
                children: [
                  Text(
                    title,
                    style: _theme.textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: CustomTheme.primaryColor,
                    ),
                  ),
                  SizedBox(height: 5.hp),
                  Text(
                    value,
                    style: _theme.textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: CustomTheme.darkerBlack,
                    ),
                  ),
                ],
              ),
    );
  }
}
