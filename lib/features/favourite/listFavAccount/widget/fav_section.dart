import 'package:flutter/material.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/features/favourite/listFavAccount/screen/list_fav_account_page.dart';

class FavSection extends StatelessWidget {
  const FavSection({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      topbarName: 'Fav Section',
      subTitle: "You can find and add the fav transactions here!",
      showBackBotton: false,
      showRoundBotton: false,
      body: ListFavAccountPage(),
    );
  }
}
