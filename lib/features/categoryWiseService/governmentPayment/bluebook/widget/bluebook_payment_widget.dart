import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/common_loading_widget.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/governmentPayment/bluebook/screen/bluebook_details_page.dart';
import 'package:ismart_web/features/categoryWiseService/governmentPayment/bluebook/widget/bluebook_bottomsheet_widget.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class BlueBookRenewalWidget extends StatefulWidget {
  final ServiceList service;
  const BlueBookRenewalWidget({Key? key, required this.service})
    : super(key: key);

  @override
  State<BlueBookRenewalWidget> createState() => _BlueBookRenewalWidgetState();
}

class _BlueBookRenewalWidgetState extends State<BlueBookRenewalWidget> {
  final _formKey = GlobalKey<FormState>();
  bool _isProvince = true;
  final provinceController = TextEditingController();
  final zoneController = TextEditingController();
  final vehicleTypeController = TextEditingController();
  final symbolController = TextEditingController();
  final officeController = TextEditingController();
  final officeCodeController = TextEditingController();
  final vehicleNumberController = TextEditingController();
  final lotNumberController = TextEditingController();
  final mobileNumberController = TextEditingController();

  String? provincevalue;
  String? officevalue;
  String? officeCodevalue;
  String? zoneValue;
  String? symbolvalue;
  String? vehicleTypevalue;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      body: BlocConsumer<UtilityPaymentCubit, CommonState>(
        builder: (context, state) {
          if (state is CommonStateSuccess<UtilityResponseData>) {
            final List provincesList = state.data.findValue(
              primaryKey: "provinces",
            );
            final List officesList = state.data.findValue(
              primaryKey: "offices",
            );
            final List symbolsList = state.data.findValue(
              primaryKey: "symbols",
            );
            final List zonesList = state.data.findValue(primaryKey: "zones");
            final List vehicleTypesList = state.data.findValue(
              primaryKey: "vehicleTypes",
            );

            return CommonContainer(
              onButtonPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<UtilityPaymentCubit>().makePayment(
                    serviceIdentifier: "",
                    accountDetails: {},
                    body: {
                      "licenseType": _isProvince ? "PROVINCE" : "ZONAL",
                      "officeCode": officeCodevalue,
                      "provinceId": provincevalue,
                      if (!_isProvince) "zone": zoneValue,
                      "vehicleSymbol": symbolvalue,
                      "lotNo": lotNumberController.text,
                      "vehicleNumber": vehicleNumberController.text,
                      "vehicleType": vehicleTypevalue,
                      "mobileNumber": mobileNumberController.text,
                      "taxOffice": officevalue,
                    },
                    apiEndpoint: "api/vehicle/registration/vehicle/details",
                    mPin: "",
                  );
                }
              },
              showDetail: true,
              buttonName: "Proceed",
              topbarName: widget.service.serviceCategoryName,
              title: widget.service.service,
              detail: widget.service.instructions,
              body: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomRoundedButtom(
                            title: "PROVINCE",
                            onPressed: () {
                              setState(() {
                                _isProvince = true;
                                print(_isProvince);
                              });
                            },
                            color:
                                _isProvince
                                    ? CustomTheme.primaryColor
                                    : CustomTheme.primaryColor.withOpacity(0.6),
                          ),
                        ),
                        SizedBox(width: 10.wp),
                        Expanded(
                          child: CustomRoundedButtom(
                            title: "Zone",
                            onPressed: () {
                              setState(() {});
                              _isProvince = false;
                              print(_isProvince);
                            },
                            color:
                                _isProvince
                                    ? CustomTheme.primaryColor.withOpacity(0.6)
                                    : CustomTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.hp),
                    CustomTextField(
                      onTap: () {
                        showBottomSheet(
                          context: context,
                          builder:
                              (context) => Container(
                                child: BlueBookBottomSheet(
                                  onPress: (name, id) {
                                    setState(() {
                                      provinceController.text = name;
                                      provincevalue = id;
                                    });
                                  },
                                  showCancelButton: true,
                                  showTopDivider: true,
                                  title: "Province",
                                  items: provincesList,
                                ),
                              ),
                        );
                      },
                      validator:
                          (value) => FormValidator.validateFieldNotEmpty(
                            value,
                            "Province",
                          ),
                      readOnly: true,
                      title: "Province",
                      controller: provinceController,
                      hintText: "Select From List",
                    ),
                    _isProvince
                        ? CustomTextField(
                          validator:
                              (value) => FormValidator.validateFieldNotEmpty(
                                value,
                                "Office Code",
                              ),
                          onTap: () {
                            showBottomSheet(
                              context: context,
                              builder:
                                  (context) => Container(
                                    child: BlueBookBottomSheet(
                                      isOfficeCode: true,
                                      onPress: (name, id) {
                                        setState(() {
                                          officeCodeController.text = name;
                                          officeCodevalue = id;
                                        });
                                      },
                                      showCancelButton: true,
                                      showTopDivider: true,
                                      title: "Office Code",
                                      items: officesList,
                                    ),
                                  ),
                            );
                          },
                          readOnly: true,
                          title: "Office Code",
                          controller: officeCodeController,
                          hintText: "Select From List",
                        )
                        : CustomTextField(
                          validator:
                              (value) => FormValidator.validateFieldNotEmpty(
                                value,
                                "Zone",
                              ),
                          onTap: () {
                            showBottomSheet(
                              context: context,
                              builder:
                                  (context) => Container(
                                    child: BlueBookBottomSheet(
                                      isOfficeCode: true,
                                      onPress: (name, id) {
                                        setState(() {
                                          zoneController.text = name;
                                          zoneValue = id;
                                        });
                                      },
                                      showCancelButton: true,
                                      showTopDivider: true,
                                      title: "Zone",
                                      items: zonesList,
                                    ),
                                  ),
                            );
                          },
                          readOnly: true,
                          title: "Zone",
                          controller: zoneController,
                          hintText: "Select From List",
                        ),
                    CustomTextField(
                      controller: lotNumberController,
                      validator:
                          (value) => FormValidator.validateFieldNotEmpty(
                            value,
                            "Lot no",
                          ),
                      title: "Lot No",
                      hintText: "Lot no.",
                    ),
                    CustomTextField(
                      validator:
                          (value) => FormValidator.validateFieldNotEmpty(
                            value,
                            "Symbol",
                          ),
                      onTap: () {
                        showBottomSheet(
                          context: context,
                          builder:
                              (context) => Container(
                                child: BlueBookBottomSheet(
                                  isSymbol: true,
                                  onPress: (name, id) {
                                    setState(() {
                                      symbolController.text = name;
                                      symbolvalue = id;
                                    });
                                  },
                                  showCancelButton: true,
                                  showTopDivider: true,
                                  title: "Vehicle Symbol",
                                  items: symbolsList,
                                ),
                              ),
                        );
                      },
                      readOnly: true,
                      title: "Vehicle Symbols",
                      controller: symbolController,
                      hintText: "Select From List",
                    ),
                    CustomTextField(
                      controller: vehicleNumberController,
                      validator:
                          (value) => FormValidator.validateFieldNotEmpty(
                            value,
                            "Vehicle Number",
                          ),
                      title: "Vehicle No",
                      hintText: "vehicle No",
                    ),
                    CustomTextField(
                      validator:
                          (value) => FormValidator.validateFieldNotEmpty(
                            value,
                            "Vehicles Type",
                          ),
                      onTap: () {
                        showBottomSheet(
                          context: context,
                          builder:
                              (context) => Container(
                                child: BlueBookBottomSheet(
                                  onPress: (name, id) {
                                    setState(() {
                                      vehicleTypeController.text = name;
                                      vehicleTypevalue = id;
                                    });
                                  },
                                  showCancelButton: true,
                                  showTopDivider: true,
                                  title: "Vehicle Type",
                                  items: vehicleTypesList,
                                ),
                              ),
                        );
                      },
                      readOnly: true,
                      title: "Vehicle Type",
                      controller: vehicleTypeController,
                      hintText: "Select From List",
                    ),
                    CustomTextField(
                      controller: mobileNumberController,
                      validator:
                          (value) => FormValidator.validatePhoneNumber(value),
                      title: "Mobile Number",
                      hintText: "9866######",
                    ),
                    CustomTextField(
                      validator:
                          (value) => FormValidator.validateFieldNotEmpty(
                            value,
                            "Tax Office",
                          ),
                      onTap: () {
                        showBottomSheet(
                          context: context,
                          builder:
                              (context) => Container(
                                child: BlueBookBottomSheet(
                                  onPress: (name, id) {
                                    setState(() {
                                      officeController.text = name;
                                      officevalue = id;
                                    });
                                  },
                                  showCancelButton: true,
                                  showTopDivider: true,
                                  title: "Tax Payment Office",
                                  items: officesList,
                                ),
                              ),
                        );
                      },
                      readOnly: true,
                      title: "Tax Payment Office",
                      controller: officeController,
                      hintText: "Select From List",
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is CommonLoading) {
            return const CommonLoadingWidget();
          } else {
            return Container();
          }
        },
        listener: (context, state) {
          if (state is CommonLoading && _isLoading == false) {
            _isLoading = true;
            showLoadingDialogBox(context);
          } else if (state is! CommonLoading && _isLoading) {
            _isLoading = false;
            NavigationService.pop();
          }
          if (state is CommonError) {
            showPopUpDialog(
              context: context,
              message: state.message,
              title: "Error",
              showCancelButton: false,
              buttonCallback: () {
                NavigationService.pop();
              },
            );
          }

          if (state is CommonStateSuccess<UtilityResponseData>) {
            final UtilityResponseData _response = state.data;
            if (_response.code == "M0000" &&
                _response.status.toLowerCase() == "success") {
              NavigationService.push(
                target: BlueBookDetailsPage(response: _response),
              );
            } else {
              showPopUpDialog(
                context: context,
                message: _response.message,
                title: _response.status,
                showCancelButton: false,
                buttonCallback: () {
                  NavigationService.pop();
                },
              );
            }
          }
        },
      ),
    );
  }
}
