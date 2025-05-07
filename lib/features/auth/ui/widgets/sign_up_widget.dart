import 'package:flutter/material.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/sign_up_appbar.dart';

class SignUpWidget extends StatelessWidget {
  const SignUpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      appBar: signUpAppBar(),
      useOwnAppBar: true,
      body: Center(
        child: Text(
          "Under construction",
          style: TextStyle(
            fontFamily: 'poppins',
            fontWeight: FontWeight.normal,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
