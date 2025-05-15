import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ismart_web/common/app/theme.dart';
// import 'package:newa_guthi/common/app/theme.dart';
import 'package:ismart_web/common/utils/size_utils.dart';

class NotificationCountIcon extends StatefulWidget {
  const NotificationCountIcon({Key? key}) : super(key: key);

  @override
  State<NotificationCountIcon> createState() => _NotificationCountIconState();
}

class _NotificationCountIconState extends State<NotificationCountIcon> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    // final _textTheme = _theme.textTheme;
    final _width = SizeUtils.width;
    final _height = SizeUtils.height;
    return Container(
      width: _width * 0.09,
      child: Stack(
        children: [
          // Positioned(
          //   right: 0,
          //   top: _height * 0.006,
          //   child: CircleAvatar(
          //     backgroundColor: CustomTheme.googleColor,
          //     radius: _height * 0.01,
          //     child: Center(
          //       child: Text(
          //         "",
          //         style: _textTheme.titleSmall!.copyWith(
          //           color: CustomTheme.white,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Center(
            child: SvgPicture.asset(
              'assets/icons/Notification.svg',
              height: _height * 0.025,
              color: CustomTheme.darkGray,
            ),
          ),
        ],
      ),
    );
  }
}
