import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PersonalDetail extends StatefulWidget {
  PersonalDetail({super.key});

  @override
  State<PersonalDetail> createState() => _PersonalDetailState();
}

class _PersonalDetailState extends State<PersonalDetail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isEdit = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
}
