import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/custom_cached_network_image.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String description;
  final void Function()? onPressed;
  final bool showBorder;
  final IconData? icon;
  final EdgeInsets? margin;
  final String? imageUrl;
  final Widget? midWidget;
  final Widget? trailing;
  final Color? subtitleTextColor;
  final double horizontalPadding;
  final FontWeight titleFontWeight;
  final bool hideDescription;
  final int maxLines;

  const CustomListTile({
    Key? key,
    required this.title,
    required this.description,
    this.onPressed,
    this.showBorder = true,
    this.icon,
    this.margin,
    this.imageUrl,
    this.midWidget,
    this.trailing,
    this.subtitleTextColor,
    this.horizontalPadding = 0,
    this.maxLines = 1,
    this.titleFontWeight = FontWeight.bold,
    this.hideDescription = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;

    return Container(
      margin: margin,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 18.hp,
              horizontal: horizontalPadding,
            ),
            decoration: BoxDecoration(
              border:
                  showBorder
                      ? Border(
                        bottom: BorderSide(
                          color: CustomTheme.lightTextColor.withOpacity(0.15),
                          width: 1,
                        ),
                      )
                      : null,
            ),
            child: Row(
              children: [
                if (icon != null)
                  Container(
                    decoration: BoxDecoration(
                      color: CustomTheme.lightGray,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.all(6),
                    margin: EdgeInsets.only(right: 12.wp),
                    child: Icon(
                      icon,
                      color: CustomTheme.lightTextColor,
                      size: 18,
                    ),
                  ),
                if (imageUrl != null)
                  Container(
                    margin: EdgeInsets.only(right: 12.wp),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: CustomCachedNetworkImage(
                        url: imageUrl!,
                        fit: BoxFit.cover,
                        height: 45.wp,
                        width: 45.wp,
                      ),
                    ),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: maxLines,
                        overflow: TextOverflow.ellipsis,
                        style: _textTheme.titleLarge!.copyWith(
                          fontWeight: titleFontWeight,
                        ),
                      ),
                      if (description.isNotEmpty && hideDescription == false)
                        SizedBox(height: 4.hp),
                      if (description.isNotEmpty && hideDescription == false)
                        Text(
                          description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w400,
                            height: 1.35,
                            color: subtitleTextColor,
                          ),
                        ),
                    ],
                  ),
                ),
                if (midWidget != null) midWidget!,
                trailing ??
                    const Icon(
                      Icons.arrow_right,
                      color: CustomTheme.lightTextColor,
                      size: 20,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
