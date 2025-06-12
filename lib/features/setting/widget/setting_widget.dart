import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/shared_pref.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/common_detail_box.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';
import 'package:ismart_web/features/auth/ui/screens/login_page.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingWidget extends StatefulWidget {
  const SettingWidget({Key? key}) : super(key: key);

  @override
  State<SettingWidget> createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  final ValueNotifier<bool> _isBiometricEnabled = ValueNotifier(false);

  // bool switchValue = false;

  @override
  void initState() {
    _checkBiometric();

    super.initState();
  }

  _checkBiometric() async {
    final bool? isLocalBiometricEnabled = await SharedPref.getBiometricLogin();
    if (isLocalBiometricEnabled != null && isLocalBiometricEnabled) {
      _isBiometricEnabled.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageWrapper(
        body: CommonContainer(
          showDetail: false,
          showTitleText: false,
          showRoundBotton: false,
          verticalPadding: 0,
          topbarName: "Setting",
          body: Column(
            children: [
              // // checkBioMetric() == false
              // // ?
              // Row(
              //   children: [
              //     Expanded(
              //       child: CommonDetailBox(
              //         showTrailingIcon: false,
              //         leadingImage: "assets/icons/pin-code-svgrepo-com 1.svg",
              //         onBoxPressed: () {
              //           // NavigationService.push(target: const ChangeMpinPage());
              //         },
              //         title: "Biometric Setup",
              //         detail: "Enable/Disable biometric",
              //       ),
              //     ),
              //     ValueListenableBuilder<bool>(
              //         valueListenable: _isBiometricEnabled,
              //         builder: (context, val, child) {
              //           print("Default Value : Biometrics: $val");
              //           return Switch(
              //             value: val,
              //             onChanged: (value) async {
              //               print("Onchange Value : Biometrics: $value");
              //               if (value) {
              //                 NavigationService.pushReplacement(
              //                   target: BiometricLoginPage(
              //                     onValueCallback: (p0) {
              //                       NavigationService.pop();
              //                       if (p0) {
              //                         _isBiometricEnabled.value = value;
              //                         SharedPref.setBiometricLogin(true);
              //                         SnackBarUtils.showSuccessBar(
              //                           context: context,
              //                           message: "Biometric Enable",
              //                         );
              //                       }
              //                     },
              //                   ),
              //                 );
              //               } else {
              //                 _isBiometricEnabled.value = value;
              //                 SharedPref.setBiometricLogin(false);
              //                 SnackBarUtils.showErrorBar(
              //                   context: context,
              //                   message: "Biometric Disable",
              //                 );
              //               }
              //             },
              //           );
              //         })
              //   ],
              // ),
              // // : Container(),
              // const Divider(thickness: 1),
              // CommonDetailBox(
              //     leadingImage: "assets/icons/pin-code-svgrepo-com 1.svg",
              //     onBoxPressed: () {
              //       NavigationService.push(target: const ChangeMpinPage());
              //     },
              //     detail: "Change mPin frequently to be secure",
              //     title: "Change mPin"),

              // const Divider(thickness: 1),
              const CommonDetailBox(
                leadingImage: "assets/icons/privacy policy.svg",
                onBoxPressed: _launchUrl,
                detail: "View complete privacy policy",
                title: "Privacy Policy",
              ),
              const Divider(thickness: 1),

              CommonDetailBox(
                leadingImage: Assets.resetPinIcon,
                onBoxPressed: () {
                  // NavigationService.push(target:'');
                },
                detail: "Tap to reset your Security Pin.",
                title: "Forget Pin",
              ),

              // const Divider(thickness: 1),
              // CommonDetailBox(
              //     leadingImage: Assets.preference,
              //     onBoxPressed: () {
              //       NavigationService.push(target: const PreferenceWidget());
              //     },
              //     detail: "Tap to set your preferences.",
              //     title: "Preferences"),
              const Divider(thickness: 1),
              CommonDetailBox(
                onBoxPressed: () {
                  showPopUpDialog(
                    context: context,
                    message: "Are you sure you want to logout.",
                    title: "Alert",
                    buttonText: "Logout",
                    buttonCallback: () {
                      RepositoryProvider.of<UserRepository>(context).logout();
                      NavigationService.pushUntil(target: LoginPage());
                    },
                  );
                },
                leadingImage: Assets.logoutIcon,
                title: "Logout",
                detail: "Logout from this application.",
              ),
              const Divider(thickness: 1),
            ],
          ),
        ),
      ),
    );
  }
}

final Uri _url = Uri.parse('https://devanasoft.com.np/PrivacyPolicy.html');
Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
