import 'package:flutter/material.dart';
import 'package:ismart_web/common/utils/responsive.dart';
import 'package:ismart_web/features/auth/ui/widgets/login_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: LoginWidget()),
        if (Responsive.isTablet(context) || Responsive.isDesktop(context))
          Expanded(
            flex: 2,
            child: Image.asset(
              'assets/images/bg-image.png',
              fit: BoxFit.cover,
              height: double.infinity,
            ),
          ),
      ],
    );
  }
}
