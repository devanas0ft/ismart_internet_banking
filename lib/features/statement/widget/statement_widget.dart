import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/common_gridview_container.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';

class StatementWidget extends StatelessWidget {
  const StatementWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _height = SizeUtils.height;
    return PageWrapper(
      body: CommonContainer(
        showDetail: false,
        topbarName: "Statement",
        detail: "Select the type of statement you want to  view",
        showRoundBotton: false,
        body: Column(
          children: [
            Container(
              height: _height * 0.19,
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: CommonGridViewContainer(
                      onContainerPress: () {
                        NavigationService.pushNamed(routeName: '');
                      },
                      containerImage: Assets.miniStatement,
                      title: "Mini Statement",
                    ),
                  ),
                  Expanded(
                    child: CommonGridViewContainer(
                      containerImage: Assets.miniStatement,
                      title: "Full Statement",
                      onContainerPress: () {
                        NavigationService.pushNamed(routeName: '');
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: _height * 0.1),
          ],
        ),
      ),
    );
  }
}
