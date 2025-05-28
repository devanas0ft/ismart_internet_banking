import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:ismart_web/common/utils/responsive.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/features/userAccount/widgets/account_detail.dart';
import 'package:ismart_web/features/userAccount/widgets/bank_detail.dart';
import 'package:ismart_web/features/userAccount/widgets/personal_detail.dart';

class UserAccountWidget extends StatefulWidget {
  const UserAccountWidget({super.key});

  @override
  State<UserAccountWidget> createState() => _UserAccountWidgetState();
}

class _UserAccountWidgetState extends State<UserAccountWidget> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    return CommonContainer(
      topbarName: "User Account",
      subTitle: "Manage and view your account",
      showBackBotton: false,
      showRoundBotton: false,

      body: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildTab('PERSONAL DETAILS', 0, screenWidth),
                  SizedBox(width: screenWidth * 0.1),
                  buildTab('BANK DETAILS', 1, screenWidth),
                  SizedBox(width: screenWidth * 0.1),
                  buildTab('ACCOUNT DETAILS', 2, screenWidth),
                ],
              ),
            ),
            SizedBox(height: 20),

            if (activeIndex == 0) ...[
              PersonalDetail(),
            ] else if (activeIndex == 1) ...[
              BankDetail(),
            ] else if (activeIndex == 2) ...[
              AccountDetail()
            ],
          ],
        ),
      ),
    );
  }

  Widget buildTab(String title, int index, double screenWidth) {
    return GestureDetector(
      onTap: () {
        setState(() {
          activeIndex = index;
        });
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              color: activeIndex == index ? Color(0xff010c80) : Colors.black,
            ),
          ),
          SizedBox(height: 4),
          Container(
            height: 2,
            width: screenWidth * 0.1,
            color: activeIndex == index ? Color(0xff010c80) : Colors.grey,
          ),
        ],
      ),
    );
  }


  
}
