import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/utils/size_utils.dart';

class BlueBookBottomSheet extends StatelessWidget {
  final Function(String name, String id) onPress;
  final String title;
  final bool isSymbol;
  final bool? isOfficeCode;
  final List items;
  final bool showCancelButton;
  final EdgeInsets? padding;
  final double? topPadding;
  final Color backgroundColor;
  final bool showTopDivider;
  final int titleTopPadding;
  final int titleBottomPadding;
  const BlueBookBottomSheet({
    this.padding,
    this.showCancelButton = false,
    this.backgroundColor = CustomTheme.backgroundColor,
    this.topPadding,
    this.showTopDivider = true,
    this.titleTopPadding = 16,
    this.titleBottomPadding = 20,
    this.title = "",
    required this.items,
    required this.onPress,
    this.isOfficeCode = false,
    this.isSymbol = false,
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
                        const Icon(
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
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              // shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if (isSymbol == true) {
                      onPress(items[index], items[index]);
                    } else {
                      if (isOfficeCode == true)
                        onPress(
                          "${items[index]["code"]} ${items[index]["name"]}",
                          items[index]["id"] ?? items[index]["code"],
                        );
                      else {
                        onPress(items[index]["name"], items[index]["id"]);
                      }
                    }
                    NavigationService.pop();
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _theme.primaryColor.withOpacity(0.05),
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                    ),
                    child: Center(
                      child: Text(
                        isSymbol == true
                            ? items[index]
                            : (isOfficeCode == true
                                ? (items[index]["code"] +
                                    " " +
                                    items[index]["name"])
                                : items[index]["name"]),
                        style: _textTheme.titleLarge,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
