import 'package:flutter/material.dart';

import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/utils/size_utils.dart';

class NoDataScreen extends StatelessWidget {
  final bool showImage;
  final String title;
  final String details;

  const NoDataScreen({
    Key? key,
    required this.title,
    required this.details,
    this.showImage = true,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final _height = SizeUtils.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showImage) Image.asset(Assets.errorImage, height: _height * 0.4),
        Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: _textTheme.displayLarge!.copyWith(fontSize: 20),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          details,
          textAlign: TextAlign.center,
          style: _textTheme.headlineSmall,
        ),
      ],
    );
  }
}
