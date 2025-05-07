import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/widget/test_loading_widget.dart';

class CommonLoadingWidget extends StatelessWidget {
  const CommonLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Center(
    //   child: Image.asset(
    //     Assets.loader,
    //     height: 100,
    //     width: 100,
    //   ),
    // );

    return TestLoadingWidget(ringColor: CustomTheme.primaryColor, size: 100);
  }
}
