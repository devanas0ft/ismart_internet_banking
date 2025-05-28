import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ismart_web/common/utils/responsive.dart';
import 'package:ismart_web/features/userAccount/widgets/account_table.dart';
import 'package:ismart_web/features/userAccount/widgets/each_bank_helper.dart';

class AccountDetail extends StatefulWidget {
  const AccountDetail({super.key});

  @override
  State<AccountDetail> createState() => _AccountDetailState();
}

class _AccountDetailState extends State<AccountDetail> {
  String selectedValue = 'Select Bank Account';

  final List<String> items = [
    'Select Bank Account',
    'Opening Balance',
    'Closing Balance',
  ];

  DateTime? fromDate;
  DateTime? toDate;
  String getFromDate() {
    if (fromDate == null) return 'dd/mm/yy';
    return DateFormat('dd/MM/yy').format(fromDate!);
  }

  String getToDate() {
    if (toDate == null) return 'dd/mm/yy';
    return DateFormat('dd/MM/yy').format(toDate!);
  }

  Future<void> _pickFromDate(BuildContext context) async {
    final DateTime? fromdatePicked = await showDatePicker(
      context: context,
      initialDate: fromDate ?? toDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: toDate ?? DateTime.now(),
    );

    if (fromdatePicked != null) {
      setState(() {
        fromDate = fromdatePicked;
      });
    }
  }

  Future<void> _pickToDate(BuildContext context) async {
    final DateTime? todatePicked = await showDatePicker(
      context: context,
      initialDate: toDate ?? (fromDate ?? DateTime.now()),
      firstDate: fromDate ?? DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (todatePicked != null) {
      setState(() {
        toDate = todatePicked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: screenWidth * 0.1,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                  if (Responsive.isMobile(context))
                    EachBankHelper(
                      'assets/icons/user_account/bank_details/interest accured.svg',
                      'Interest Accrued',
                      Text(
                        'xxxx',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                ],
              ),
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
                    'Primary Account No.',
                    Text(
                      'xxxx',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              if (Responsive.isDesktop(context) || Responsive.isTablet(context))
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    EachBankHelper(
                      'assets/icons/user_account/bank_details/interest accured.svg',
                      'Interest Accrued',
                      Text(
                        'xxxx',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        SizedBox(height: 30),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                color: Colors.grey[200],
                child: DropdownButton<String>(
                  value: selectedValue,
                  icon: Icon(Icons.keyboard_arrow_down),
                  elevation: 16,
                  style: TextStyle(color: Colors.grey[600], fontSize: 18),
                  underline: Container(height: 2, color: Colors.grey[200]),
                  dropdownColor: Colors.grey[200],
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
                  items:
                      items.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(fontSize: 14)),
                        );
                      }).toList(),
                ),
              ),
              SizedBox(width: 60),
              Text('From'),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () => _pickFromDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.transparent),
                  ),
                  child: Text(
                    getFromDate(),
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ),
              ),
              SizedBox(width: 20),
              Text('To'),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () => _pickToDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.transparent),
                  ),
                  child: Text(
                    getToDate(),
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ),
              ),
              SizedBox(width: 50),
              Text('Show Per Page'),
              SizedBox(width: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.transparent),
                ),
                child: Text(
                  10.toString(),
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ),
              SizedBox(width: 50),
              Text('Sort By'),
              SizedBox(width: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.transparent),
                ),
                child: Text(
                  'Date',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        AccountTable(),
      ],
    );
  }
}
