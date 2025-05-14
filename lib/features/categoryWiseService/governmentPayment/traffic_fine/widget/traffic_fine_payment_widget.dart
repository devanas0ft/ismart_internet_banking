import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/widget/common_bill_details_screen.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/key_value_tile.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/governmentPayment/ui/screen/gov_place_page.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

import 'possible_date_traffic_widget.dart';

class TrafficFinePaymentWidget extends StatefulWidget {
  final ServiceList service;

  const TrafficFinePaymentWidget({Key? key, required this.service})
    : super(key: key);

  @override
  State<TrafficFinePaymentWidget> createState() =>
      _TrafficFinePaymentWidgetState();
}

class _TrafficFinePaymentWidgetState extends State<TrafficFinePaymentWidget> {
  final TextEditingController _selectedProvinceNameController =
      TextEditingController();
  final TextEditingController _selectedDistrictController =
      TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? selectedDateValue;

  final TextEditingController chitNumberController = TextEditingController();
  String? selectedDistrictValue;
  String? selectedProvinceValue;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      body: BlocListener<UtilityPaymentCubit, CommonState>(
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
            // final myAmount = _response
            //     .findValue(
            //         primaryKey: "hashResponse",
            //         secondaryKey: "formattedFinalAmount")
            //     .toString();

            final serviceCharge =
                _response
                    .findValue(
                      primaryKey: "hashResponse",
                      secondaryKey: "charge",
                    )
                    .toString();

            if (_response.code == "M0000") {
              NavigationService.push(
                target: CommonBillDetailPage(
                  serviceName: widget.service.service,
                  service: widget.service,
                  serviceIdentifier: widget.service.uniqueIdentifier,
                  apiEndpoint: "/api/governmentpayment/pay",
                  apiBody: {
                    "hashCharge":
                        _response
                            .findValue(
                              primaryKey: "hashResponse",
                              secondaryKey: "hashCharge",
                            )
                            .toString(),
                    "voucherCode": chitNumberController.text,
                    "billerCode":
                        _response
                            .findValue(
                              primaryKey: "hashResponse",
                              secondaryKey: "billerCode",
                            )
                            .toString(),
                    "serviceCharge": serviceCharge,
                    "fiscalYear": dateController.text,
                    "chitNumber": chitNumberController.text,
                    "province": selectedProvinceValue,
                    "district":
                        _selectedProvinceNameController.text
                                    .toString()
                                    .toLowerCase() ==
                                'Kathmandu Valley'.toLowerCase()
                            ? "000"
                            : selectedDistrictValue,
                    // "isDistrict": false,
                  },
                  accountDetails: {
                    "amount":
                        _response
                            .findValue(
                              primaryKey: "hashResponse",
                              secondaryKey: "amount",
                            )
                            .toString(),
                    "account_number":
                        RepositoryProvider.of<CustomerDetailRepository>(
                          context,
                        ).selectedAccount.value!.accountNumber.toString(),

                    //"amount": myAmount.replaceAll("NPR ", ""),
                  },
                  body: Column(
                    children: [
                      KeyValueTile(
                        title: "Biller Code",
                        value:
                            _response
                                .findValue(
                                  primaryKey: "hashResponse",
                                  secondaryKey: "billerCode",
                                )
                                .toString(),
                      ),
                      KeyValueTile(
                        title: "Name",
                        value:
                            _response
                                .findValue(
                                  primaryKey: "hashResponse",
                                  secondaryKey: "customerName",
                                )
                                .toString(),
                      ),
                      KeyValueTile(
                        title: "Amount",
                        value:
                            _response
                                .findValue(
                                  primaryKey: "hashResponse",
                                  secondaryKey: "formattedFinalAmount",
                                )
                                .toString(),
                      ),
                      KeyValueTile(
                        title: "Charge",
                        value:
                            _response
                                .findValue(
                                  primaryKey: "hashResponse",
                                  secondaryKey: "charge",
                                )
                                .toString(),
                      ),
                      KeyValueTile(
                        title: "Remarks",
                        value:
                            _response
                                .findValue(
                                  primaryKey: "hashResponse",
                                  secondaryKey: "remarks",
                                )
                                .toString(),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              showPopUpDialog(
                context: context,
                message: _response.message,
                title: "Error",
                buttonCallback: () {
                  NavigationService.pop();
                },
                showCancelButton: false,
              );
            }
          }
        },
        child: CommonContainer(
          showRecentTransaction: true,
          associatedId: widget.service.id.toString(),
          showAccountSelection: true,
          buttonName: "Show Bill",
          title: widget.service.service,
          detail: widget.service.instructions,
          showDetail: true,
          topbarName: "Payment",
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  hintText: "Select",
                  title: "Select Province",
                  readOnly: true,
                  controller: _selectedProvinceNameController,
                  validator: (value) {
                    if (selectedProvinceValue != null) {
                      return null;
                    } else {
                      return "Please select Province.";
                    }
                  },
                  onTap: () {
                    NavigationService.push(
                      target: GovPlacePage(
                        isProvince: true,
                        accountDetails: const {},
                        apiEndpoint: "/api/governmentpayment/getProvance",
                        serviceIdentifier: "",
                        onBankSelected: ({required value, required name}) {
                          NavigationService.pop();
                          _selectedProvinceNameController.text = name;
                          selectedProvinceValue = value;

                          setState(() {});
                        },
                      ),
                    );
                  },
                ),
                _selectedProvinceNameController.text.isEmpty
                    ? Container()
                    : _selectedProvinceNameController.text
                            .toString()
                            .toLowerCase() ==
                        'Kathmandu Valley'.toLowerCase()
                    ? Container()
                    : CustomTextField(
                      hintText: "Select",
                      title: "Select District",
                      readOnly: true,
                      controller: _selectedDistrictController,
                      onTap: () {
                        NavigationService.push(
                          target: GovPlacePage(
                            isProvince: false,
                            accountDetails: {
                              "provinceId": selectedProvinceValue,
                            },
                            apiEndpoint: "/api/governmentpayment/getDistrict",
                            serviceIdentifier: widget.service.uniqueIdentifier,
                            onBankSelected: ({required value, required name}) {
                              NavigationService.pop();
                              _selectedDistrictController.text = name;
                              selectedDistrictValue = value;
                              setState(() {});
                            },
                          ),
                        );
                      },
                      validator: (value) {
                        if (selectedDistrictValue != null) {
                          return null;
                        } else {
                          return "Please select District.";
                        }
                      },
                    ),
                CustomTextField(
                  controller: dateController,
                  readOnly: true,
                  onTap: () {
                    NavigationService.push(
                      target: PossibleDatetrafficPage(
                        service: widget.service,
                        onChanged: (val) {
                          dateController.text = val.title;
                          selectedDateValue = val.id;
                          // selectedBank = val;
                          setState(() {});
                        },
                      ),
                    );
                  },
                  title: "Date",
                  hintText: "2079/80",
                  validator:
                      (value) =>
                          FormValidator.validateFieldNotEmpty(value, "Date"),
                ),
                // CustomTextField(
                //   controller: dateController,
                //   title: "Date",
                //   hintText: "2079/80",
                //   validator: (value) =>
                //       FormValidator.validateFieldNotEmpty(value, "Date"),
                // ),
                CustomTextField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  title: "Chit No.",
                  textInputType: TextInputType.number,
                  hintText: "XXXXXXXXX",
                  controller: chitNumberController,
                  validator:
                      (value) => FormValidator.validateFieldNotEmpty(
                        value,
                        "Chit Number",
                      ),
                ),
              ],
            ),
          ),
          onButtonPressed: () {
            // context.read<UtilityPaymentCubit>().fetchDetails(
            //       serviceIdentifier: widget.service.uniqueIdentifier,
            //       accountDetails: {
            //         "chitNumber": "34600",//742397
            //         "fiscalYear": "2077/78",
            //         "provinceId": "000",
            //         "districtId": "002",
            //       },
            //       apiEndpoint: "api/governmentpayment/trafficFineDetail",
            //     );
            if (_formKey.currentState!.validate()) {
              context.read<UtilityPaymentCubit>().fetchDetails(
                serviceIdentifier: widget.service.uniqueIdentifier,
                accountDetails: {
                  "chitNumber": chitNumberController.text,
                  "fiscalYear": dateController.text,
                  "provinceId": selectedProvinceValue,
                  "districtId":
                      _selectedProvinceNameController.text
                                  .toString()
                                  .toLowerCase() ==
                              'Kathmandu Valley'.toLowerCase()
                          ? "000"
                          : selectedDistrictValue,
                  // "isDistrict": false,
                },
                apiEndpoint: "api/governmentpayment/trafficFineDetail",
              );
            }
          },
        ),
      ),
    );
  }
}
