import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/constants/slugs.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/widget/common_bill_details_screen.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/key_value_tile.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';

import '../../../customerDetail/resource/customer_detail_repository.dart';

class LandlinePaymentWidget extends StatefulWidget {
  final CategoryList category;

  const LandlinePaymentWidget({super.key, required this.category});

  @override
  State<LandlinePaymentWidget> createState() => _LandlinePaymentWidgetState();
}

class _LandlinePaymentWidgetState extends State<LandlinePaymentWidget> {
  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _amountController = TextEditingController();

  bool _isLoading = false;
  String currentAmount = '';
  final _fromKey = GlobalKey<FormState>();
  ServiceList getService() {
    final service = widget.category.services.firstWhere(
      (element) => element.uniqueIdentifier.contains("pstn_online_topup"),
    );

    return service;
  }

  @override
  Widget build(BuildContext context) {
    final selectedService = widget.category.services.firstWhere(
      (element) => element.uniqueIdentifier.toString() == Slugs.pstnOnlineTopup,
    );
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

          if (state is CommonStateSuccess) {
          } else if (state is CommonError) {
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
        },
        child: CommonContainer(
          showDetail: true,
          showAccountSelection: true,
          buttonName: "Proceed",
          topbarName: "Landline",
          title: "LandLine Payment",
          verificationAmount: currentAmount,
          detail: selectedService.instructions,
          body: Form(
            key: _fromKey,
            child: Column(
              children: [
                CustomTextField(
                  textInputType: TextInputType.number,
                  title: "Landline Number",
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  hintText: "xxxxxxxxxx",
                  controller: _phoneNumberController,
                  validator:
                      (value) =>
                          FormValidator.validateFieldNotEmpty(value, "Number"),
                ),
                CustomTextField(
                  textInputType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  title: "Amount",
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
                        maxAmount: selectedService.maxValue,
                        minAmount: selectedService.minValue,
                      ),
                ),
              ],
            ),
          ),
          onButtonPressed: () {
            if (_fromKey.currentState!.validate()) {
              print(
                _phoneNumberController.text.substring(
                  _phoneNumberController.text.length - 8,
                ),
              );
              NavigationService.push(
                target: CommonBillDetailPage(
                  serviceName: selectedService.service,
                  serviceIdentifier: "pstn_online_topup",
                  apiBody: const {},
                  apiEndpoint: "/api/topup",
                  service: getService(),
                  accountDetails: {
                    // "phone_number": _phoneNumberController.text.substring(
                    //     _phoneNumberController.text.length - 8),
                    "phone_number": _phoneNumberController.text.replaceAll(
                      "-",
                      "",
                    ),

                    "amount": _amountController.text,
                    "account_number":
                        RepositoryProvider.of<CustomerDetailRepository>(
                          context,
                        ).selectedAccount.value!.accountNumber,
                  },
                  body: Column(
                    children: [
                      KeyValueTile(
                        title: "Phone Number",
                        value: _phoneNumberController.text,
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
          },
        ),
      ),
    );
  }
}
