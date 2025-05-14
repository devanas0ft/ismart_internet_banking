import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_bill_details_screen.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_cached_network_image.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/key_value_tile.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';

class MobileTopUpWidget extends StatefulWidget {
  final CategoryList categoryList;

  const MobileTopUpWidget({super.key, required this.categoryList});
  @override
  State<MobileTopUpWidget> createState() => _MobileTopUpWidgetState();
}

class _MobileTopUpWidgetState extends State<MobileTopUpWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String currentAmount = '';
  List<ServiceList> selectedService = [];
  List<ServiceList> getTopupType(String phoneNumber) {
    if (phoneNumber.startsWith("+977")) {
      phoneNumber = phoneNumber.substring(4);
    }

    final String firstThreeDigits = phoneNumber.substring(0, 3);

    final List<ServiceList> services = widget.categoryList.services;

    final List<ServiceList> filteredServices =
        services.where((service) {
          final List<String> prefixes = service.labelPrefix.split(',');
          return prefixes.any((prefix) => prefix == firstThreeDigits);
        }).toList();
    selectedService = filteredServices;
    return filteredServices;
  }

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final _height = SizeUtils.height;

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
        },
        child: CommonContainer(
          onRecentTransactionPressed: (p0) {
            //  NavigationService.pop();
            _amountController.text = p0.amount.toString();
            _mobileNumberController.text = p0.serviceTo;
            setState(() {});
          },
          showRecentTransaction: true,
          showDetail: true,
          verificationAmount: currentAmount,
          showAccountSelection: true,
          accountTitle: "From Account",
          buttonName: "Proceed",
          topbarName: "Top Up",
          title: "Mobile Top Up",
          detail: "Topup your mobile number.",
          serviceCategoryId: widget.categoryList.id.toString(),
          body: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        suffixImage: "assets/icons/Contact from phone.svg",
                        title: "Mobile Number",
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        hintText: "xxxxxxxxxx",
                        validator: (value) {
                          if (value!.startsWith("+977")) {
                            final newValue = value.substring(4);
                            return FormValidator.validatePhoneNumber(newValue);
                          } else {
                            return FormValidator.validatePhoneNumber(value);
                          }
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            final String newText = newValue.text
                                .replaceAll('+977', '')
                                .replaceAll('-', '');
                            return TextEditingValue(
                              text: newText,
                              selection: TextSelection.collapsed(
                                offset: newText.length,
                              ),
                            );
                          }),
                        ],
                        controller: _mobileNumberController,

                        textInputType: TextInputType.phone,

                        onChanged: (value) {
                          if (value.length > 9) {
                            getTopupType(_mobileNumberController.text);
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ],
                ),
                if (_mobileNumberController.text.length >= 10)
                  getTopupType(_mobileNumberController.text).isNotEmpty
                      ? Column(
                        children: [
                          Row(
                            children: [
                              CustomCachedNetworkImage(
                                url:
                                    RepositoryProvider.of<CoOperative>(
                                      context,
                                    ).baseUrl +
                                    "/ismart/serviceIcon/" +
                                    getTopupType(
                                      _mobileNumberController.text,
                                    ).first.icon.toString(),
                                height: 50.hp,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(width: 20.wp),
                              Text(
                                getTopupType(
                                  _mobileNumberController.text,
                                ).first.service.toString(),
                                style: _textTheme.labelLarge!.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: _height * 0.01),
                          CustomTextField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            title: "Amount",
                            textInputType: TextInputType.number,
                            hintText: "Enter the amount",
                            controller: _amountController,
                            onChanged: (value) {
                              setState(() {
                                currentAmount = value;
                              });
                            },
                            validator:
                                (val) => FormValidator.validateAmount(
                                  val: val.toString(),
                                  maxAmount: selectedService.first.maxValue,
                                  minAmount: selectedService.first.minValue,
                                ),
                          ),
                        ],
                      )
                      : Text(
                        "Service is currently unavailable",
                        style: _textTheme.labelMedium!.copyWith(
                          color: CustomTheme.googleColor,
                        ),
                      ),
              ],
            ),
          ),
          onButtonPressed: () {
            _formKey.currentState!.save();

            if (_formKey.currentState!.validate()) {
              final phoneNumber =
                  _mobileNumberController.text.startsWith("+977")
                      ? _mobileNumberController.text.substring(4)
                      : _mobileNumberController.text;
              if (selectedService.isNotEmpty) {
                NavigationService.push(
                  target: CommonBillDetailPage(
                    serviceName: selectedService.first.service,
                    service: getTopupType(phoneNumber).first,
                    apiBody: const {},
                    serviceIdentifier:
                        getTopupType(phoneNumber).first.uniqueIdentifier,
                    accountDetails: {
                      "account_number":
                          RepositoryProvider.of<CustomerDetailRepository>(
                            context,
                          ).selectedAccount.value!.accountNumber,
                      "phone_number": phoneNumber,
                      "amount": _amountController.text,
                    },
                    apiEndpoint: "/api/topup",
                    body: Column(
                      children: [
                        KeyValueTile(
                          title: "Target Number",
                          value: phoneNumber,
                        ),
                        KeyValueTile(
                          title: "Amount",
                          value: _amountController.text,
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }

  String removeSpecificPatterns(String input) {
    if (input.startsWith('+977')) {
      input = input.substring(4);
    }
    input = input.replaceAll('-', '');
    return input;
  }
}
