import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/shared_pref.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/utils/snack_bar_utils.dart';
import 'package:ismart_web/common/widget/common_box.dart';
import 'package:ismart_web/common/widget/custom_password_field.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/top_widget.dart';
import 'package:ismart_web/features/Dahboard/widgets/dashboard_widget.dart';
import 'package:ismart_web/features/appServiceManagement/model/app_service_management_model.dart';
import 'package:ismart_web/features/appServiceManagement/resource/app_service_repository.dart';
import 'package:ismart_web/features/auth/cubit/login_cubit.dart';
import 'package:ismart_web/features/auth/cubit/validate_co_op_cubit.dart';
import 'package:ismart_web/features/auth/enum/login_response_value.dart';
import 'package:ismart_web/features/auth/ui/widgets/opt_widget.dart';
import 'package:ismart_web/features/auth/ui/widgets/sign_up_widget.dart';
import 'package:uuid/uuid.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool showCountyCode = false;
  bool rememberMe = false;
  String _currentUUID = "";
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  List<AppServiceManagementModel> appService = [];
  bool _isLoading = false;
  String _existingPhoneNumber = "";
  Future<String> _getDeviceUUID() async {
    String? _deviceUUID = await SharedPref.getDeviceUUID();
    if (_deviceUUID == null || _deviceUUID.isEmpty) {
      _deviceUUID = const Uuid().v4();
      SharedPref.setDeviceUUID(_deviceUUID);
    }
    _currentUUID = _deviceUUID;
    return _deviceUUID;
  }

  String _getPhoneNumber() {
    if (phoneController.text.isNotEmpty) return phoneController.text;
    return _existingPhoneNumber;
  }

  getAppService() async {
    final appServiceRepo = RepositoryProvider.of<AppServiceRepository>(context);
    // final response = await appServiceRepo.getAppService();
    setState(() {
      appService = appServiceRepo.appService;
    });
  }

  @override
  void initState() {
    getAppService();
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
      body: BlocListener<LoginCubit, CommonState>(
        listener: (context, state) async {
          if (state is CommonLoading && _isLoading == false) {
            _isLoading = true;
            showLoadingDialogBox(context);
          } else if (state is! CommonLoading && _isLoading) {
            _isLoading = false;
            NavigationService.pop();
          }

          if (state is CommonStateSuccess<LoginResponseValue>) {
            await SharedPref.setDeviceUUID(_currentUUID);
            if (state.data == LoginResponseValue.Success) {
              NavigationService.pushReplacement(
                target: const DashboardWidget(),
              );
            }
            // else if (state.data == LoginResponseValue.OTPVerification) {
            //   NavigationService.push(
            //     target: OTPWidget(
            //       onValueCallback: (val) async {
            //         context.read<LoginCubit>().loginUser(
            //               username: _getPhoneNumber(),
            //               password: passwordController.text,
            //               otpCode: val,
            //               deviceUUID: await _getDeviceUUID(),
            //             );
            //       },
            //     ),
            //   );
            // }
          } else if (state is CommonError) {
            SnackBarUtils.showErrorBar(
              context: context,
              message: state.message,
            );
          }
        },
        child: ListView(
          children: [
            SizedBox(height: height * 0.04),
            GuthiTopWidget(showSupportIcon: true),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.hp),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _loginFormKey,
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
                      validator: (value) {
                        FormValidator.validateFieldNotEmpty(
                          value,
                          "Phone Number",
                        );
                        return null;
                      },
                      title: "Mobile Number",
                      hintText: "Mobile Number",
                    ),
                    SizedBox(height: height * 0.01),
                    CustomPasswordField(
                      controller: passwordController,
                      textInputType: TextInputType.number,
                      title: "Security Pin",
                      hintText: "Security Pin",
                      validator:
                          (value) => FormValidator.validateFieldNotEmpty(
                            value,
                            "MPIN",
                          ),
                      onTap: () async {
                        final CoOperative currentCoop =
                            RepositoryProvider.of<CoOperative>(context);
                        if (currentCoop.shouldValidateCooperative) {
                          await context
                              .read<ValidateCoOpCubit>()
                              .validateCoOperative(
                                username: phoneController.text,
                                channelPartner: currentCoop.channelPartner,
                              );
                          Future.delayed(const Duration(seconds: 3)).then((
                            value,
                          ) {
                            setState(() {});
                          });
                        }
                      },
                    ),
                    // Row(
                    //   children: [
                    //     Checkbox(
                    //       value: rememberMe,
                    //       activeColor: Colors.blue,
                    //       onChanged: null,
                    //     ),
                    //     const Text("Remember Me"),
                    //   ],
                    // ),
                    CustomRoundedButtom(
                      title: "Login",
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (_loginFormKey.currentState!.validate()) {
                          context.read<LoginCubit>().loginUser(
                            username: _getPhoneNumber(),
                            password: passwordController.text,
                            deviceUUID: await _getDeviceUUID(),
                          );
                        }
                        // NavigationService.push(target: OptWidget());
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
