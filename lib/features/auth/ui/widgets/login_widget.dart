import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_box.dart';
import 'package:ismart_web/common/widget/custom_password_field.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/top_widget.dart';
import 'package:ismart_web/features/auth/ui/widgets/opt_widget.dart';
import 'package:ismart_web/features/auth/ui/widgets/sign_up_widget.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool showCountyCode = false;
  bool rememberMe = false;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    // final _theme = Theme.of(context);
    // final config = ConfigService().config;
    return PageWrapper(
      showAppBar: false,
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          SizedBox(height: height * 0.04),
          GuthiTopWidget(showSupportIcon: true),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.hp),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.01),
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 26,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  SizedBox(height: height * 0.01),
                  CustomTextField(
                    controller: phoneController,
                    title: "Mobile Number",
                    hintText: "Mobile Number",
                  ),
                  SizedBox(height: height * 0.01),
                  CustomPasswordField(
                    controller: passwordController,
                    textInputType: TextInputType.number,
                    title: "Security Pin",
                    hintText: "Security Pin",
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        activeColor: Colors.blue,
                        onChanged: null,
                      ),
                      const Text("Remember Me"),
                    ],
                  ),
                  CustomRoundedButtom(
                    title: "Login",
                    onPressed: () {
                      NavigationService.push(target: OptWidget());
                    },
                  ),
                  SizedBox(height: height * 0.01),

                  SizedBox(height: height * 0.014),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(
                        2,
                        (index) => CommonBox(
                          onContainerPress: onTapFunction[index],
                          containerImage: imageList[index],
                          title: nameList[index],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  final List nameList = ["Reset Pin", "Sign Up"];
  final List imageList = [
    "assets/icons/Reset password.svg",
    "assets/icons/activate account.svg",
  ];
  List<VoidCallback> onTapFunction = [
    () {},
    () {
      NavigationService.push(target: SignUpWidget());
    },
  ];
}
