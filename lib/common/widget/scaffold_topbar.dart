import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/models/coop_config.dart';

class ScaffoldTopBar extends StatelessWidget {
  final String name;
  final bool showBackButton;
  final VoidCallback onBackPressed;
  final String subTitle;

  const ScaffoldTopBar({
    super.key,
    required this.name,
    this.showBackButton = true,
    required this.onBackPressed,
    this.subTitle = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        color: CustomTheme.white,
        // image: DecorationImage(
        //   image: AssetImage(
        //     RepositoryProvider.of<CoOperative>(context).backgroundImage,
        //   ),
        //   fit: BoxFit.cover,
        // ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              showBackButton
                  ? IconButton(
                    onPressed: onBackPressed,
                    icon: const Icon(
                      Icons.arrow_back,
                      color: CustomTheme.darkGray,
                    ),
                  )
                  : Container(),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 36, top: 16),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            name,
                            style: const TextStyle(
                              color: CustomTheme.darkGray,
                              fontFamily: "popinsemibold",
                              fontSize: 23,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(subTitle),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          Divider(color: CustomTheme.gray),
        ],
      ),
    );
  }
}
