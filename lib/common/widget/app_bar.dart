import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/service/config_service.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/notification_count_widget.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';
import 'package:ismart_web/features/auth/ui/screens/login_page.dart';

AppBar myAppbar({bool showBackButton = false, bool showChatBot = false}) {
  final _height = SizeUtils.height;
  final config = ConfigService().config;

  return AppBar(
    backgroundColor:
        Theme.of(NavigationService.context).scaffoldBackgroundColor,
    elevation: 0,
    toolbarHeight: 8.h,
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
    title: Container(
      width: 300.w,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Image.asset(config.bannerImage, height: 50),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              NotificationCountIcon(),
              SizedBox(width: 4.w),
              InkWell(
                onTap: () {
                  showPopUpDialog(
                    context: NavigationService.context,
                    message: "Are you sure you want to logout.",
                    title: "Alert",
                    buttonText: "Logout",
                    buttonCallback: () {
                      RepositoryProvider.of<UserRepository>(
                        NavigationService.context,
                      ).logout();
                      NavigationService.pushUntil(target: const LoginPage());
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: SvgPicture.asset(
                    Assets.logoutIcon,
                    color: CustomTheme.darkGray,
                    height: _height * 0.025,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    actions: [], // Empty since we included actions in the title
  );
}
