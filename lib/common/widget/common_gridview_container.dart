import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/utils/size_utils.dart';

class CommonGridViewContainer extends StatelessWidget {
  final bool isNetworkImage;
  final String containerImage;
  final String title;
  final Function()? onContainerPress;
  final EdgeInsets? margin;
  final double? height;
  final double? width;

  const CommonGridViewContainer({
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
    final _height = SizeUtils.height;

    return InkWell(
      onTap: onContainerPress,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: _theme.primaryColor.withOpacity(0.05),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: width,
              padding: const EdgeInsets.all(12),
              height: height,
              child:
                  isNetworkImage == true
                      ? SvgPicture.network(
                        containerImage,
                        height: 50,
                        width: 50,
                        color: _theme.primaryColor,
                      )
                      : SvgPicture.asset(
                        containerImage,
                        color: _theme.primaryColor,
                        height: 50,
                        width: 50,
                      ),
            ),
            SizedBox(height: _height * 0.01),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CustomTheme.darkerBlack.withOpacity(0.6),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
