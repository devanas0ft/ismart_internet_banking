import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/service/config_service.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/notification_count_widget.dart';

AppBar myAppbar({bool showBackButton = false, bool showChatBot = false}) {
  final height = SizeUtils.height;
  final config = ConfigService().config;
  return AppBar(
    backgroundColor:
        Theme.of(NavigationService.context).scaffoldBackgroundColor,
    elevation: 0,
    iconTheme: const IconThemeData(color: Colors.black),
    automaticallyImplyLeading: false,
    centerTitle: true,
    leading:
        showBackButton
            ? IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => NavigationService.pop(),
            )
            : null,
    title: Padding(
      padding: const EdgeInsets.all(0),
      child: Image.asset(config.bannerImage, height: 50),
    ),
    actions: [
      NotificationCountIcon(),
      InkWell(
        onTap: () {
          // Logout logic here if needed
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: SvgPicture.asset(
            '',
            color: CustomTheme.primaryColor,
            height: height * 0.025,
          ),
        ),
      ),
    ],
  );
}
