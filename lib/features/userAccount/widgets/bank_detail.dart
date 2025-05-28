import 'package:flutter/material.dart';
import 'package:ismart_web/common/utils/responsive.dart';
import 'package:ismart_web/features/userAccount/widgets/each_bank_helper.dart';

class BankDetail extends StatefulWidget {
  BankDetail({super.key});

  @override
  State<BankDetail> createState() => _BankDetailState();
}

class _BankDetailState extends State<BankDetail> {
  bool moBank = false;
  bool isSMS = false;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EachBankHelper(
                'assets/icons/user_account/bank_details/bank name.svg',
                'Bank Name',
                Text(
                  'xxxx',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              EachBankHelper(
                'assets/icons/user_account/bank_details/bank code.svg',
                'Bank Code',
                Text(
                  'xxxx',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              EachBankHelper(
                'assets/icons/user_account/bank_details/branch name.svg',
                'Branch Name',
                Text(
                  'xxxx',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              EachBankHelper(
                'assets/icons/user_account/bank_details/branch code.svg',
                'Branch Code',
                Text(
                  'xxxx',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              EachBankHelper(
                'assets/icons/user_account/bank_details/account no.svg',
                'Account Number',
                Text(
                  'xxxxxxxxxxxx',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              if (Responsive.isTablet(context) ||
                  Responsive.isMobile(context)) ...[
                EachBankHelper(
                  'assets/icons/user_account/bank_details/interest accured.svg',
                  'Interest Accrued',
                  Text(
                    'xxxxx',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                EachBankHelper(
                  'assets/icons/user_account/bank_details/mobank.svg',
                  'Mobile Banking Service',
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: moBank,
                      onChanged: (bool value) {
                        setState(() {
                          moBank = value;
                        });
                      },
                      activeColor: Color(0xff010c80),
                      activeTrackColor: Colors.grey[300],
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(width: screenWidth * 0.1),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EachBankHelper(
                'assets/icons/user_account/bank_details/account type.svg',
                'Account Type',
                Text(
                  'xxxx',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              EachBankHelper(
                'assets/icons/user_account/bank_details/primary account.svg',
                'Primary Account Number',
                Text(
                  'xxxx',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              EachBankHelper(
                'assets/icons/user_account/bank_details/actual balance.svg',
                'Actual Balance',
                Text(
                  'xxxxx.xx',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              EachBankHelper(
                'assets/icons/user_account/bank_details/available balance.svg',
                'Available Balance',
                Text(
                  'xxxxx.xx',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              EachBankHelper(
                'assets/icons/user_account/bank_details/available balance.svg',
                'Minimum Balance Must Be',
                Text(
                  'xxxx.xx',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              if (Responsive.isTablet(context) ||
                  Responsive.isMobile(context)) ...[
                EachBankHelper(
                  'assets/icons/user_account/bank_details/interest rate.svg',
                  'Interest Rate',
                  Text(
                    'xx%',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                EachBankHelper(
                  'assets/icons/user_account/bank_details/sms.svg',
                  'SMS Banking Service',
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: isSMS,
                      onChanged: (bool value) {
                        setState(() {
                          isSMS = value;
                        });
                      },
                      activeColor: Color(0xff010c80),
                      activeTrackColor: Colors.grey[300],
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(width: screenWidth * 0.1),
          if (Responsive.isDesktop(context))
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EachBankHelper(
                  'assets/icons/user_account/bank_details/interest accured.svg',
                  'Interest Accrued',
                  Text(
                    'xxxxx',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                EachBankHelper(
                  'assets/icons/user_account/bank_details/interest rate.svg',
                  'Interest Rate',
                  Text(
                    'xx%',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                EachBankHelper(
                  'assets/icons/user_account/bank_details/mobank.svg',
                  'Mobile Banking Service',
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: moBank,
                      onChanged: (bool value) {
                        setState(() {
                          moBank = value;
                        });
                      },
                      activeColor: Color(0xff010c80),
                      activeTrackColor: Colors.grey[300],
                    ),
                  ),
                ),
                EachBankHelper(
                  'assets/icons/user_account/bank_details/sms.svg',
                  'SMS Banking Service',
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: isSMS,
                      onChanged: (bool value) {
                        setState(() {
                          isSMS = value;
                        });
                      },
                      activeColor: Color(0xff010c80),
                      activeTrackColor: Colors.grey[300],
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
