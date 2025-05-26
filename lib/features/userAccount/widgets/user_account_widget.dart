import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:ismart_web/common/utils/responsive.dart';
import 'package:ismart_web/common/widget/common_container.dart';

class UserAccountWidget extends StatefulWidget {
  const UserAccountWidget({super.key});

  @override
  State<UserAccountWidget> createState() => _UserAccountWidgetState();
}

class _UserAccountWidgetState extends State<UserAccountWidget> {
  int activeIndex = 0;
  bool isEdit = true;
  bool moBank = false;
  bool isSMS = false;
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
      initialDate: fromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
              personalDetailsSection(screenWidth, screenHeight),
            ] else if (activeIndex == 1) ...[
              bankDetailsSection(screenWidth, screenHeight),
            ] else if (activeIndex == 2) ...[
              accountDetailsSection(screenWidth, screenHeight),
            ],
          ],
        ),
      ),
    );
  }

  Widget personalDetailsSection(double screenWidth, double screenHeight) {
    return Form(
      key: _formKey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 50,
                  runSpacing: 10,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'assets/images/profile.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                    // SizedBox(width: screenWidth * 0.1),
                    SizedBox(
                      height: screenHeight * 0.05,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          if (isEdit) {
                            setState(() {
                              isEdit = !isEdit;
                            });
                          }
                        },
                        child:
                            isEdit
                                ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: Color(0xff010c80),
                                      size: 15,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Edit Details',
                                      style: TextStyle(
                                        color: Color(0xff010c80),
                                      ),
                                    ),
                                  ],
                                )
                                : Text(
                                  'Change Photo',
                                  style: TextStyle(color: Color(0xff010c80)),
                                ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                buildPersonalDetail(
                  'assets/icons/user_account/personal/name.svg',
                  'Full Name',
                  'xxxx',
                  screenWidth,
                ),
                SizedBox(height: screenHeight * 0.02),
                buildPersonalDetail(
                  'assets/icons/user_account/personal/mail.svg',
                  'Email',
                  'xxxxx.com',
                  screenWidth,
                ),
                SizedBox(height: screenHeight * 0.02),
                buildPersonalDetail(
                  'assets/icons/user_account/personal/mobile.svg',
                  'Mobile Number',
                  'xxxx',
                  screenWidth,
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                buildPersonalDetail(
                  'assets/icons/user_account/personal/location.svg',
                  'Province',
                  'xxxx',
                  screenWidth,
                ),
                SizedBox(height: screenHeight * 0.02),
                buildPersonalDetail(
                  'assets/icons/user_account/personal/city.svg',
                  'City',
                  'xxxx',
                  screenWidth,
                ),
                SizedBox(height: screenHeight * 0.02),
                buildPersonalDetail(
                  'assets/icons/user_account/personal/ward.svg',
                  'Ward No.',
                  'xxxx',
                  screenWidth,
                ),
                if (!isEdit) SizedBox(height: 40),

                !isEdit
                    ? Wrap(
                      spacing: 20,
                      runSpacing: 10,
                      children: [
                        SizedBox(
                          height: 43,
                          width: 100,
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                isEdit = !isEdit;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.transparent),
                              backgroundColor: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        // SizedBox(width: 35),
                        SizedBox(
                          width: 100,
                          height: 43,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.transparent),
                              backgroundColor: Color(0xff010c80),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                    : buildPersonalDetail(
                      'assets/icons/user_account/personal/municipality.svg',
                      'Municipality',
                      'xxxx',
                      screenWidth,
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget bankDetailsSection(double screenWidth, double screenHeight) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // spacing: screenWidth * 0.1,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildEachBankDetail(
                'assets/icons/user_account/bank_details/bank name.svg',
                'Bank Name',
                Text(
                  'xxxx',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              buildEachBankDetail(
                'assets/icons/user_account/bank_details/bank code.svg',
                'Bank Code',
                Text(
                  'xxxx',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              buildEachBankDetail(
                'assets/icons/user_account/bank_details/branch name.svg',
                'Branch Name',
                Text(
                  'xxxx',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              buildEachBankDetail(
                'assets/icons/user_account/bank_details/branch code.svg',
                'Branch Code',
                Text(
                  'xxxx',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              buildEachBankDetail(
                'assets/icons/user_account/bank_details/account no.svg',
                'Account Number',
                Text(
                  'xxxxxxxxxxxx',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              if (Responsive.isTablet(context) ||
                  Responsive.isMobile(context)) ...[
                buildEachBankDetail(
                  'assets/icons/user_account/bank_details/interest accured.svg',
                  'Interest Accrued',
                  Text(
                    'xxxxx',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                buildEachBankDetail(
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
              buildEachBankDetail(
                'assets/icons/user_account/bank_details/account type.svg',
                'Account Type',
                Text(
                  'xxxx',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              buildEachBankDetail(
                'assets/icons/user_account/bank_details/primary account.svg',
                'Primary Account Number',
                Text(
                  'xxxx',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              buildEachBankDetail(
                'assets/icons/user_account/bank_details/actual balance.svg',
                'Actual Balance',
                Text(
                  'xxxxx.xx',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              buildEachBankDetail(
                'assets/icons/user_account/bank_details/available balance.svg',
                'Available Balance',
                Text(
                  'xxxxx.xx',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              buildEachBankDetail(
                'assets/icons/user_account/bank_details/available balance.svg',
                'Minimum Balance Must Be',
                Text(
                  'xxxx.xx',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              if (Responsive.isTablet(context) ||
                  Responsive.isMobile(context)) ...[
                buildEachBankDetail(
                  'assets/icons/user_account/bank_details/interest rate.svg',
                  'Interest Rate',
                  Text(
                    'xx%',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                buildEachBankDetail(
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
                buildEachBankDetail(
                  'assets/icons/user_account/bank_details/interest accured.svg',
                  'Interest Accrued',
                  Text(
                    'xxxxx',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                buildEachBankDetail(
                  'assets/icons/user_account/bank_details/interest rate.svg',
                  'Interest Rate',
                  Text(
                    'xx%',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                buildEachBankDetail(
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
                buildEachBankDetail(
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

  Widget accountDetailsSection(double screenWidth, double screenHeight) {
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
                  buildEachBankDetail(
                    'assets/icons/user_account/bank_details/bank name.svg',
                    'Bank Name',
                    Text(
                      'xxxx',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  buildEachBankDetail(
                    'assets/icons/user_account/bank_details/bank code.svg',
                    'Bank Code',
                    Text(
                      'xxxx',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  if (Responsive.isMobile(context))
                    buildEachBankDetail(
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
                  buildEachBankDetail(
                    'assets/icons/user_account/bank_details/account type.svg',
                    'Account Type',
                    Text(
                      'xxxx',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  buildEachBankDetail(
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
                    buildEachBankDetail(
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
                          child: Text(value),
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
        buildTable(),
      ],
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

  Widget buildPersonalDetail(
    String img,
    String title,
    String body,
    double screenWidth,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon(icon, color: Color(0xff010c80)),
              if (isEdit) ...[
                SvgPicture.asset(
                  img,
                  width: 20,
                  height: 20,
                  color: Color(0xff010c80),
                ),
                SizedBox(width: 10),
              ],
              Text(title, style: TextStyle(fontSize: 16)),
              SizedBox(width: 10),
            ],
          ),
          SizedBox(height: 10),
          isEdit
              ? Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Text(
                  'xxxx',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              : SizedBox(
                width: screenWidth * 0.2,
                child: CustomTextField('xxxx'),
              ),
          // Padding(
          //   isEdit?
          //   padding: const EdgeInsets.only(left: 0.0),
          //   :
          //   padding: const EdgeInsets.only(left: 30.0),
          //   child: isEdit ? Text('xxxx') : CustomTextField('xxxx'),
          // ),
        ],
      ),
    );
  }

  Widget CustomTextField(String hintText) {
    return isEdit
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(hintText, style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 20),
          ],
        )
        : TextFormField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            hintText: hintText,
          ),
        );
  }

  Widget buildEachBankDetail(String img, String title, Widget body) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon(icon, color: Color(0xff010c80)),
              SvgPicture.asset(
                img,
                width: 20,
                height: 20,
                color: Color(0xff010c80),
              ),
              SizedBox(width: 10),
              Text(title, style: TextStyle(fontSize: 16)),
              SizedBox(width: 10),
            ],
          ),

          Padding(padding: const EdgeInsets.only(left: 30.0), child: body),
        ],
      ),
    );
  }

  Widget buildTable() {
    return Table(
      border: TableBorder(
        top: BorderSide(width: 1, color: Colors.grey[200]!),
        bottom: BorderSide(width: 1, color: Colors.grey[200]!),
        horizontalInside: BorderSide(width: 1, color: Colors.grey[200]!),
      ),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[200]),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.check_box_outline_blank,
                    color: Color(0xff010c80),
                    size: 12,
                  ),
                  SizedBox(width: 5),
                  Expanded(child: Text('Transaction Date')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Description'),
            ),
            Padding(padding: const EdgeInsets.all(8.0), child: Text('Debit')),
            Padding(padding: const EdgeInsets.all(8.0), child: Text('Credit')),
            Padding(padding: const EdgeInsets.all(8.0), child: Text('Balance')),
          ],
        ),
        //* use listview from data here
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.check_box_outline_blank,
                    color: Color(0xff010c80),
                    size: 12,
                  ),
                  SizedBox(width: 5),
                  Expanded(child: Text('01/01/2023')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Opening Balance'),
            ),
            Padding(padding: const EdgeInsets.all(8.0), child: Text('0.00')),
            Padding(padding: const EdgeInsets.all(8.0), child: Text('1000.00')),
            Padding(padding: const EdgeInsets.all(8.0), child: Text('1000.00')),
          ],
        ),
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.check_box_outline_blank,
                    color: Color(0xff010c80),
                    size: 12,
                  ),
                  SizedBox(width: 5),
                  Expanded(child: Text('01/01/2023')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Closing Balance'),
            ),
            Padding(padding: const EdgeInsets.all(8.0), child: Text('0.00')),
            Padding(padding: const EdgeInsets.all(8.0), child: Text('1000.00')),
            Padding(padding: const EdgeInsets.all(8.0), child: Text('1000.00')),
          ],
        ),
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.circle_outlined,
                    color: Color(0xff010c80),
                    size: 12,
                  ),
                  SizedBox(width: 5),
                  Expanded(child: Text('Prev')),
                ],
              ),
            ),
            Text(''),
            // SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '1 2 3 ... 8 9 10',
                style: TextStyle(letterSpacing: 5),
              ),
            ),
            Text(''),
            // SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('Next'),
                  SizedBox(width: 5),
                  Icon(
                    Icons.circle_outlined,
                    color: Color(0xff010c80),
                    size: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
