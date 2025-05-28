import 'package:flutter/material.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/features/fundManagement/widgets/fund_management_widget.dart';

class FundmanagemtPage extends StatefulWidget {
  const FundmanagemtPage({super.key});

  @override
  State<FundmanagemtPage> createState() => _FundmanagemtPageState();
}

class _FundmanagemtPageState extends State<FundmanagemtPage> {
  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      showAccountSelection: false,
      showBackBotton: false,
      title: '',
      showRoundBotton: false,
      topbarName: 'Fund Managemt',
      subTitle:
          'Manage your account, send funds to wallet and view your statement',
      body: FundManagementWidget(),
    );
  }
}
