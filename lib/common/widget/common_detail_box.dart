import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/utils/size_utils.dart';

class CommonDetailBox extends StatelessWidget {
  final String leadingImage;
  final String trailingIcon;
  final double verticalPadding;
  final double horizontalPadding;
  final bool showTrailingIcon;
  final bool isNetworkImage;
  final String title;
  final String detail;
  final VoidCallback onBoxPressed;

  const CommonDetailBox({
    super.key,
    this.isNetworkImage = false,
    this.leadingImage = Assets.brokerIcon,
    this.verticalPadding = 10.0,
    this.horizontalPadding = 20.0,
    required this.title,
    this.showTrailingIcon = true,
    this.trailingIcon = Assets.forwardButtonIcon,
    this.detail = "",
    required this.onBoxPressed,
  });

  @override
  Widget build(BuildContext context) {
    final _height = SizeUtils.height;
    final _width = SizeUtils.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: InkWell(
        onTap: () {
          onBoxPressed.call();
        },
        child: Row(
          children: [
            Container(
              width: _width * 0.1,
              child:
                  isNetworkImage == false
                      ? SvgPicture.asset(leadingImage, height: _height * 0.04)
                      : SvgPicture.network(
                        leadingImage,
                        placeholderBuilder:
                            (BuildContext context) => Center(
                              child: Image.asset(
                                Assets.logoImage,
                                height: _height * 0.04,
                              ),
                            ),
                        height: _height * 0.04,
                      ),
            ),
            SizedBox(width: _width * 0.05),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (detail.isNotEmpty)
                    Text(detail, style: Theme.of(context).textTheme.titleSmall),
                ],
              ),
            ),
            SizedBox(width: _width * 0.05),
            showTrailingIcon
                ? SvgPicture.asset(
                  trailingIcon,
                  color: CustomTheme.darkerBlack,
                  height: _height * 0.02,
                )
                : Container(),
          ],
        ),
      ),
    );
  }
}
