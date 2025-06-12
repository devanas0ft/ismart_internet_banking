import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/features/more/transactionLimit/transaction_progress_page.dart';

class TransactionLimitWidget extends StatefulWidget {
  const TransactionLimitWidget({super.key});

  @override
  State<TransactionLimitWidget> createState() => _TransactionLimitWidgetState();
}

class _TransactionLimitWidgetState extends State<TransactionLimitWidget> {
  bool showCount = true;
  @override
  Widget build(BuildContext context) {
    return const PageWrapper(
      showBackButton: true,
      body: SingleChildScrollView(
        // child: CommonContainer(
        //     body: Text(
        //       "Working , will be availbale in next update",
        //       style: TextStyle(color: Colors.black),
        //     ),
        //     topbarName: "Transition limit"),
        child: Column(
          children: [
            TransactionProgressPage(
              title: "Internal Fund Transfer ",
              profileType: 'CustomerProfile',
              isOpen: true,
            ),
            TransactionProgressPage(
              title: "Wallet ",
              profileType: 'WalletProfile',
              isOpen: true,
            ),
            TransactionProgressPage(
              title: "Bank Transfer",
              profileType: 'BankTransferProfile',
              isOpen: true,
            ),
            TransactionProgressPage(
              title: "Scan and Pay Profile",
              profileType: 'QRProfile',
              isOpen: true,
            ),
            // TransactionProgressPage(
            //   title: "iBanking",
            //   profileType: 'IBankingProfile',
            //   isOpen: false,
            // ),
          ],
        ),
      ),
    );
  }
}
