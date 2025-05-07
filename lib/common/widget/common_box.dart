import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/utils/size_utils.dart';

class CommonBox extends StatelessWidget {
  final bool isNetworkImage;
  final String containerImage;
  final String title;
  final Function()? onContainerPress;
  final EdgeInsets? margin;
  final double? height;
  final double? width;

  const CommonBox({
    super.key,
    required this.containerImage,
    this.isNetworkImage = false,
    this.margin = const EdgeInsets.all(8),
    required this.title,
    this.onContainerPress,
    this.height,
    this.width,
  });
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return InkWell(
      onTap: onContainerPress,
      child: Container(
        height: 90.hp,
        width: 90.wp,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _theme.primaryColor.withOpacity(0.05),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 30,
              child:
                  isNetworkImage == true
                      ? SvgPicture.network(
                        containerImage,
                        color: _theme.primaryColor,
                      )
                      : SvgPicture.asset(
                        containerImage,
                        height: 20,
                        color: _theme.primaryColor,
                      ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CustomTheme.darkerBlack.withAlpha(150),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
