import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/service/config_service.dart';
import 'package:ismart_web/common/utils/size_utils.dart';

class GuthiTopWidget extends StatelessWidget {
  final Function()? supportAction;
  final bool showSupportIcon;
  const GuthiTopWidget({
    Key? key,
    this.showSupportIcon = false,
    this.supportAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _height = SizeUtils.height;
    final config = ConfigService().config;
     
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (true)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              // child: Image.asset("assets/Newa_banner.png", height: 60.hp),
              // child: Image.asset(config.bannerImage, height: 60.hp),
              child: Image.network(
                config!.bannerImage, // dynamic url
                height: 60.hp,
                errorBuilder: (_, __, ___) {
                  return Image.asset(
                    'assets/default_banner.png',
                    height: 60.hp,
                  );
                },
              ),
            ),
          ),

        if (showSupportIcon)
          Container(
            child: Row(
              children: [
                SizedBox(width: 15.hp),
                InkWell(
                  onTap: supportSheet,
                  // UrlLauncher.launchPhone(
                  //     context: NavigationService.context,
                  //     phone: "9801132218");
                  child: SvgPicture.asset(
                    'assets/icons/Contact us.svg',
                    height: _height * 0.03,
                  ),
                ),
              ],
            ),
          ),
        SizedBox(width: 15.hp),
      ],
    );
  }

  supportSheet() {
    final _textTheme = Theme.of(NavigationService.context).textTheme;
    final List contactList = ['9812724405'];
    final config = ConfigService().config;

    showModalBottomSheet(
      context: NavigationService.context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.hp),
          topRight: Radius.circular(30.hp),
        ),
      ),
      builder:
          (context) => Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 24, bottom: 24),
                  height: 4,
                  width: 55,
                  decoration: BoxDecoration(
                    color: CustomTheme.lightGray.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Text(
                  "Choose Option",
                  style: _textTheme.labelLarge!.copyWith(
                    color: CustomTheme.darkerBlack,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const Divider(height: 40),
                ...List.generate(contactList.length, (index) {
                  return InkWell(
                    onTap: () {
                      NavigationService.pop();
                      // UrlLauncher.launchPhone(
                      //   context: NavigationService.context,
                      //   phone: contactList[index],
                      // );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.hp,
                        vertical: 15.hp,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Call Support",
                                    style: _textTheme.bodyLarge!.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: CustomTheme.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    contactList[index],
                                    style: _textTheme.bodyLarge!.copyWith(
                                      color: CustomTheme.darkGray,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                // color: config.primaryColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 30),
              ],
            ),
          ),
    );
  }
}
