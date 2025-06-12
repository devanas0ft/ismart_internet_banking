import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/constants/fonts.dart';
import 'package:ismart_web/common/shared_pref.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/utils/snack_bar_utils.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_pin_field.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';
import 'package:ismart_web/features/splash/loader_screen.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class ChangeMpinWidget extends StatefulWidget {
  final String oldMpin;

  const ChangeMpinWidget({super.key, required this.oldMpin});
  @override
  State<ChangeMpinWidget> createState() => _ChangeMpinWidgetState();
}

class _ChangeMpinWidgetState extends State<ChangeMpinWidget> {
  TextEditingController newPinController = TextEditingController();

  TextEditingController confirmPinController = TextEditingController();
  bool _isLoading = false;
  final PageController _pageController = PageController();

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      body: CommonContainer(
        title: "",
        detail: "Change your Pin frequently to be more secure.",
        topbarName: "Change Security Pin",
        showRoundBotton: false,
        onButtonPressed: () {},
        body: BlocListener<UtilityPaymentCubit, CommonState>(
          listener: (context, state) {
            if (state is CommonLoading && _isLoading == false) {
              _isLoading = true;
              showLoadingDialogBox(context);
            } else if (state is! CommonLoading && _isLoading) {
              _isLoading = false;
              NavigationService.pop();
            }

            if (state is CommonStateSuccess<UtilityResponseData>) {
              showPopUpDialog(
                context: context,
                message: state.data.message,
                title: "Success",
                showCancelButton: false,
                buttonCallback: () {
                  SharedPref.removeBiometricLogin();
                  RepositoryProvider.of<UserRepository>(context).logout();
                  NavigationService.pushUntil(target: LoaderScreen());
                },
              );
            } else if (state is CommonError) {
              String _message = state.message;
              if (_message.toLowerCase().contains("validation")) {
                _message =
                    "The old PIN you entered is wrong. Please check and re-submit.";
              }
              showPopUpDialog(
                context: context,
                message: _message,
                title: state.message,
                showCancelButton: false,
                buttonCallback: () {
                  NavigationService.pop();
                },
              );
            }
          },
          child: Form(
            key: _formKey,
            child: Container(
              height: 500.hp,
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.hp),
                      const Text(
                        "New Security Pin",
                        style: TextStyle(
                          fontFamily: Fonts.poppin,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: CustomTheme.lightTextColor,
                        ),
                      ),
                      SizedBox(height: 10.hp),
                      Row(
                        children: [
                          Expanded(
                            child: CustomPinCodeField(
                              controller: newPinController,
                              length: 5,
                              onChanged: (p0) {},
                              // validator: (val) {
                              //   if (val == null || val.isEmpty) {
                              //     return "PIN Code field cannot be empty";
                              //   } else if (val.length < 5) {
                              //     return "PIN code cannot be less than 5 characters.";
                              //   }
                              //   return null;
                              // },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.hp),
                      CustomRoundedButtom(
                        title: "Next",
                        onPressed: () {
                          if (newPinController.text.length == 5) {
                            _goToPage(1);
                          } else {
                            SnackBarUtils.showErrorBar(
                              context: context,
                              message: "Pin must be 5 digits.",
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.hp),
                      const Text(
                        "Confirm Security Pin",
                        style: TextStyle(
                          fontFamily: Fonts.poppin,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: CustomTheme.lightTextColor,
                        ),
                      ),
                      SizedBox(height: 10.hp),
                      Row(
                        children: [
                          Expanded(
                            child: CustomPinCodeField(
                              controller: confirmPinController,
                              length: 5,
                              onChanged: (p0) {},
                              // validator: (val) {
                              //   if (val!.length != 5) {
                              //     return "Invalid MPin";
                              //   }
                              //   if (newPinController.text != val) {
                              //     return "Confirm Pin doesnot match.";
                              //   }
                              //   return null;
                              // },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.hp),
                      CustomRoundedButtom(
                        title: "Proceed",
                        onPressed: () {
                          // if (_formKey.currentState!.validate()) {
                          if (newPinController.text ==
                              confirmPinController.text) {
                            context.read<UtilityPaymentCubit>().makePayment(
                              mPin: widget.oldMpin,
                              serviceIdentifier: "",
                              apiEndpoint: "/api/changepin",
                              body: {},
                              accountDetails: {
                                "oldmPin": widget.oldMpin,
                                "newmPin": newPinController.text,
                                "remPin": confirmPinController.text,
                              },
                            );
                          } else {
                            SnackBarUtils.showErrorBar(
                              context: context,
                              message: "Confirm Pin doesnot match.",
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildmPinBox({
    required String title,
    required TextEditingController controller,
    required bool obscureText,
    String? Function(String?)? validator,
    required Function onIconPress,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.hp),
        Text(
          title,
          style: const TextStyle(
            fontFamily: Fonts.poppin,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: CustomTheme.lightTextColor,
          ),
        ),
        SizedBox(height: 10.hp),
        Row(
          children: [
            Expanded(
              child: CustomPinCodeField(
                // isObscureText: oldPinVisibility,
                isObscureText: obscureText,
                controller: controller,
                length: 5,
                onChanged: (p0) {},
                validator: validator,
                // validator: (val) {

                // },
              ),
            ),
            // IconButton(
            //     onPressed: () {
            //       onIconPress.call();
            //     },
            //     icon:
            //         Icon(obscureText ? Icons.visibility_off : Icons.visibility))
          ],
        ),
        SizedBox(height: 10.hp),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ismart/app/theme.dart';
// import 'package:ismart/common/common/data_state.dart';
// import 'package:ismart/common/constant/fonts.dart';
// import 'package:ismart/common/navigation/navigation_service.dart';
// import 'package:ismart/common/route/routes.dart';
// import 'package:ismart/common/shared_pref/shared_pref.dart';
// import 'package:ismart/common/util/size_utils.dart';
// import 'package:ismart/common/widget/common_container.dart';
// import 'package:ismart/common/widget/custom_pin_field.dart';
// import 'package:ismart/common/widget/page_wrapper.dart';
// import 'package:ismart/common/widget/show_loading_dialog.dart';
// import 'package:ismart/common/widget/show_pop_up_dialog.dart';
// import 'package:ismart/feature/authentication/resource/user_repository.dart';
// import 'package:ismart/feature/utility_payment/cubit/utility_payment_cubit.dart';
// import 'package:ismart/feature/utility_payment/models/utility_response_data.dart';

// // ignore: must_be_immutable
// class ChangeMpinWidget extends StatefulWidget {
//   @override
//   State<ChangeMpinWidget> createState() => _ChangeMpinWidgetState();
// }

// class _ChangeMpinWidgetState extends State<ChangeMpinWidget> {
//   TextEditingController oldPinController = TextEditingController();

//   bool oldPinVisibility = true;

//   bool newPinVisibility = true;

//   bool confirmPinVisibility = true;

//   TextEditingController newPinController = TextEditingController();

//   TextEditingController confirmPinController = TextEditingController();

//   bool _isLoading = false;

//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     final _height = SizeUtils.height;
//     return PageWrapper(
//       body: CommonContainer(
//         title: "",
//         detail: "Change your Pin frequently to be more secure.",
//         topbarName: "Change mPin",
//         buttonName: "Proceed",
//         onButtonPressed: () {
//           if (_formKey.currentState!.validate()) {
//             context.read<UtilityPaymentCubit>().makePayment(
//               mPin: oldPinController.text,
//               serviceIdentifier: "",
//               apiEndpoint: "/api/changepin",
//               body: {},
//               accountDetails: {
//                 "oldmPin": oldPinController.text,
//                 "newmPin": newPinController.text,
//                 "remPin": confirmPinController.text,
//               },
//             );
//           }
//         },
//         body: BlocListener<UtilityPaymentCubit, CommonState>(
//           listener: (context, state) {
//             if (state is CommonLoading && _isLoading == false) {
//               _isLoading = true;
//               showLoadingDialogBox(context);
//             } else if (state is! CommonLoading && _isLoading) {
//               _isLoading = false;
//               NavigationService.pop();
//             }

//             if (state is CommonStateSuccess<UtilityResponseData>) {
//               showPopUpDialog(
//                 context: context,
//                 message: state.data.message,
//                 title: "Success",
//                 showCancelButton: false,
//                 buttonCallback: () {
//                   SharedPref.removeBiometricLogin();
//                   RepositoryProvider.of<UserRepository>(context).logout();
//                   NavigationService.pushNamedAndRemoveUntil(
//                       routeName: Routes.loginPage);
//                 },
//               );
//             } else if (state is CommonError) {
//               String _message = state.message;
//               if (_message.toLowerCase().contains("validation")) {
//                 _message =
//                     "The old PIN you entered is wrong. Please check and re-submit.";
//               }
//               showPopUpDialog(
//                 context: context,
//                 message: _message,
//                 title: state.message,
//                 showCancelButton: false,
//                 buttonCallback: () {
//                   NavigationService.pop();
//                 },
//               );
//             }
//           },
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 buildmPinBox(
//                     controller: oldPinController,
//                     obscureText: oldPinVisibility,
//                     title: "Old mPin",
//                     validator: (val) {
//                       if (val == null || val.isEmpty) {
//                         return "PIN Code field cannot be empty";
//                       } else if (val.length < 5) {
//                         return "PIN code cannot be less than 5 characters.";
//                       }
//                       return null;
//                     },
//                     onIconPress: () {
//                       setState(() {
//                         oldPinVisibility = !oldPinVisibility;
//                       });
//                     }),
//                 buildmPinBox(
//                     controller: newPinController,
//                     obscureText: newPinVisibility,
//                     title: "New mPin",
//                     validator: (val) {
//                       if (val == null || val.isEmpty) {
//                         return "PIN Code field cannot be empty";
//                       } else if (val.length < 5) {
//                         return "PIN code cannot be less than 5 characters.";
//                       }
//                       return null;
//                     },
//                     onIconPress: () {
//                       setState(() {
//                         newPinVisibility = !newPinVisibility;
//                       });
//                     }),
//                 buildmPinBox(
//                     controller: confirmPinController,
//                     obscureText: confirmPinVisibility,
//                     title: "Confirm mPin",
//                     validator: (val) {
//                       if (val!.length != 5) {
//                         return "Invalid MPin";
//                       }
//                       if (newPinController.text != val) {
//                         return "Confirm Pin doesnot match.";
//                       }
//                       return null;
//                     },
//                     onIconPress: () {
//                       setState(() {
//                         confirmPinVisibility = !confirmPinVisibility;
//                       });
//                     }),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   buildmPinBox({
//     required String title,
//     required TextEditingController controller,
//     required bool obscureText,
//     String? Function(String?)? validator,
//     required Function onIconPress,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(height: 10.hp),
//         Text(
//           title,
//           style: const TextStyle(
//             fontFamily: Fonts.poppin,
//             fontWeight: FontWeight.w600,
//             fontSize: 14,
//             color: CustomTheme.lightTextColor,
//           ),
//         ),
//         SizedBox(height: 10.hp),
//         Row(
//           children: [
//             Expanded(
//               child: CustomPinCodeField(
//                 // isObscureText: oldPinVisibility,
//                 isObscureText: obscureText,
//                 controller: controller,
//                 fieldHeight: 40.hp,
//                 fieldWidth: 40.wp,
//                 length: 5,
//                 onChanged: (p0) {},
//                 validator: validator,
//                 // validator: (val) {

//                 // },
//               ),
//             ),
//             IconButton(
//                 onPressed: () {
//                   onIconPress.call();
//                 },
//                 icon:
//                     Icon(obscureText ? Icons.visibility_off : Icons.visibility))
//           ],
//         ),
//         SizedBox(height: 10.hp),
//       ],
//     );
//   }
// }
