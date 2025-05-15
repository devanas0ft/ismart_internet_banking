import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/features/banking/cheque/screen/cheque_block_page.dart';
import 'package:ismart_web/features/banking/cheque/screen/cheque_request_page.dart';

class ChequeWidget extends StatelessWidget {
  const ChequeWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _height = SizeUtils.height;
    return PageWrapper(
      body: CommonContainer(
        showDetail: false,
        body: SizedBox(
          height: _height * 0.6,
          child: DefaultTabController(
            initialIndex: 0,
            length: 2,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: _theme.scaffoldBackgroundColor,
                  ),
                  child: TabBar(
                    unselectedLabelStyle: _theme.textTheme.displaySmall!
                        .copyWith(fontWeight: FontWeight.w700, fontSize: 14),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: _theme.primaryColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelStyle: _theme.textTheme.displaySmall!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: CustomTheme.white,
                      fontSize: 14,
                    ),
                    unselectedLabelColor: CustomTheme.darkGray,
                    tabs: const [
                      Tab(text: "Cheque Request"),
                      Tab(text: "Cheque Stop"),
                    ],
                  ),
                ),
                const Expanded(
                  child: TabBarView(
                    children: [ChequeRequestScreen(), ChequeBlocKScreen()],
                  ),
                ),
              ],
            ),
          ),
        ),
        topbarName: "Banking",
        showTitleText: false,
        showRoundBotton: false,
      ),
    );
  }
}
