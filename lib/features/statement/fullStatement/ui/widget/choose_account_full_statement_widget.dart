import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';

class ChooseAccountFullStatementWidget extends StatefulWidget {
  const ChooseAccountFullStatementWidget({Key? key}) : super(key: key);

  @override
  State<ChooseAccountFullStatementWidget> createState() =>
      _ChooseAccountFullStatementWidgetState();
}

class _ChooseAccountFullStatementWidgetState
    extends State<ChooseAccountFullStatementWidget> {
  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      body: CommonContainer(
        validateMobileBankingStatus: false,
        showDetail: true,
        showAccountSelection: true,
        topbarName: "Full Statement",
        detail: "Select the Account you want to view statement of",
        buttonName: "View",
        onButtonPressed: () {
          NavigationService.pushNamed(routeName: '');
        },
        body: const Column(),
      ),
    );
  }
}
