import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/utils/size_utils.dart';

class BottomSheetWrapper extends StatelessWidget {
  final bool showCancelButton;
  final EdgeInsets? padding;
  final double? topPadding;
  final Widget child;
  final Color backgroundColor;
  final bool showTopDivider;
  final int titleTopPadding;
  final int titleBottomPadding;
  final String title;
  const BottomSheetWrapper({
    this.padding,
    this.showCancelButton = false,
    this.backgroundColor = CustomTheme.backgroundColor,
    this.topPadding,
    this.showTopDivider = true,
    this.titleTopPadding = 16,
    this.titleBottomPadding = 20,
    required this.child,
    this.title = "",
  });

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;

    return Container(
      padding:
          padding ??
          EdgeInsets.only(
            left: CustomTheme.symmetricHozPadding.wp,
            right: CustomTheme.symmetricHozPadding.wp,
            top: topPadding ?? 24.hp,
            bottom: 5.hp,
          ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showTopDivider)
            Container(
              height: 4,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: CustomTheme.gray,
              ),
            ),
          Container(
            padding: EdgeInsets.only(
              top: titleTopPadding.hp,
              bottom: titleBottomPadding.hp,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: _textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (showCancelButton)
                  InkWell(
                    onTap: () {
                      NavigationService.pop();
                    },
                    child: Row(
                      children: [
                        Text(
                          "Close",
                          style: _textTheme.titleSmall!.copyWith(
                            color: CustomTheme.googleColor,
                          ),
                        ),
                        Icon(
                          Icons.cancel_outlined,
                          size: 20,
                          color: CustomTheme.googleColor,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}
