import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/utils/size_utils.dart';

class LoanKeyValueTile extends StatelessWidget {
  final String title;
  final String value;
  final Axis axis;
  final bool isRedColor;
  final bool useCustomColor;
  final double bottomPadding;
  final CrossAxisAlignment horizontalCrossAxis;
  final FontWeight titleFontWeight;
  const LoanKeyValueTile({
    Key? key,
    required this.title,
    required this.value,
    this.isRedColor = false,
    this.useCustomColor = false,
    this.axis = Axis.horizontal,
    this.bottomPadding = 10,
    this.horizontalCrossAxis = CrossAxisAlignment.start,
    this.titleFontWeight = FontWeight.w400,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(bottom: bottomPadding.hp),
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
