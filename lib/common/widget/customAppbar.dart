import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/utils/size_utils.dart';

class CustomAppbar extends StatelessWidget {
  final bool showBackButton;
  const CustomAppbar({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.hp,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: InkWell(
                  onTap: () => NavigationService.pop(),
                  child:
                      showBackButton
                          ? const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black87,
                          )
                          : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(
                    CustomTheme.mainLogo,
                    width: 100,
                    height: CustomTheme.logoSize,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
