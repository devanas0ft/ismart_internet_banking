import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/constants/slugs.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_bill_details_screen.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/key_value_tile.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/internet/common/screen/common_internet_payment_detail_page.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class CommonInternetWithAmountWidget extends StatefulWidget {
  const CommonInternetWithAmountWidget({Key? key, required this.service})
    : super(key: key);

  final ServiceList service;

  @override
  State<CommonInternetWithAmountWidget> createState() =>
      _CommonInternetWithAmountWidgetState();
}

class _CommonInternetWithAmountWidgetState
    extends State<CommonInternetWithAmountWidget> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _setupBoxController = TextEditingController();
  String _currentAmmount = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // final _theme = Theme.of(context);
    // final _textTheme = _theme.textTheme;
    final _width = SizeUtils.width;
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

          if (state is CommonError) {
            showPopUpDialog(
              context: context,
              message: state.message,
              title: "Error",
              buttonCallback: () {
                NavigationService.pop();
              },
              showCancelButton: false,
            );
          }

          if (state is CommonStateSuccess<UtilityResponseData>) {
            final UtilityResponseData _response = state.data;
            if (_response.code == "M0000") {
              NavigationService.push(
                target: CommonInternetPaymentDeatilScreen(
                  username: _usernameController.text,
                  amount: _amountController.text,
                  service: widget.service,
                  detailFetchData: _response,
                ),
              );
            } else {
              showPopUpDialog(
                context: context,
                message: _response.message,
                title: _response.status,
                buttonCallback: () {
                  NavigationService.pop();
                },
                showCancelButton: false,
              );
            }
          }
        },
        child: Form(
          key: _formKey,
          child: CommonContainer(
            verificationAmount: _currentAmmount,
            showRecentTransaction: true,
            associatedId: widget.service.id.toString(),
            showDetail: true,
            title: widget.service.service,
            detail: widget.service.instructions,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: _height * 0.1,
                      width: _width * 0.2,
                      margin: const EdgeInsets.only(right: 18),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.05),
                            offset: const Offset(0, 4),
                            blurRadius: 4,
                          ),
                        ],
                        //color: _theme.primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(
                          "${RepositoryProvider.of<CoOperative>(context).baseUrl}/ismart/serviceIcon/${widget.service.icon}",
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.service.service,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: _height * 0.03),
                Text(
                  "Provide Username to fetch details and pay respective amount.",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                SizedBox(height: _height * 0.03),
                CustomTextField(
                  title: widget.service.labelName,
                  controller: _usernameController,
                  hintText: 'Enter Username',
                  validator:
                      (value) => FormValidator.validateFieldNotEmpty(
                        value,
                        'Username',
                      ),
                ),
                widget.service.uniqueIdentifier == Slugs.skyinternetTopup ||
                        widget.service.uniqueIdentifier == Slugs.websurferTopup
                    ? CustomTextField(
                      controller: _setupBoxController,
                      title: "Customer Id",
                      hintText: "Number",
                    )
                    : Container(),
                // widget.service.uniqueIdentifier == Slugs.pokharainternetTopup
                //     ? CustomTextField(
                //         controller: _setupBoxController,
                //         title: "Mobile Number",
                //         hintText: "Number",
                //       )
                //     : Container(),
                // widget.service.priceInput
                //     ? CustomTextField(
                //         autovalidateMode: AutovalidateMode.onUserInteraction,
                //         controller: _amountController,
                //         title: "Amount",
                //         hintText: "NPR",
                //         validator: (value) => FormValidator.validateAmount(
                //             val: value.toString(),
                //             minAmount: widget.service.minValue,
                //             maxAmount: widget.service.maxValue),
                //       )
                //     : Container()
                CustomTextField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _amountController,
                  title: "Amount",
                  hintText: "NPR",
                  validator:
                      (value) => FormValidator.validateAmount(
                        val: value.toString(),
                        minAmount: widget.service.minValue,
                        maxAmount: widget.service.maxValue,
                      ),
                  onChanged: (value) {
                    setState(() {
                      _currentAmmount = value;
                    });
                  },
                ),
              ],
            ),
            topbarName: 'Payment',
            buttonName: 'Proceed',
            onButtonPressed: () {
              _formKey.currentState!.save();
              if (_formKey.currentState!.validate()) {
                NavigationService.push(
                  target: CommonBillDetailPage(
                    serviceName: widget.service.service,
                    body: Column(
                      children: [
                        KeyValueTile(
                          title: "Username",
                          value: _usernameController.text,
                        ),
                        KeyValueTile(
                          title: "Amount",
                          value: _amountController.text,
                        ),
                      ],
                    ),
                    apiBody: const {},
                    service: widget.service,
                    serviceIdentifier: widget.service.uniqueIdentifier,
                    accountDetails: {
                      "account_number":
                          RepositoryProvider.of<CustomerDetailRepository>(
                            context,
                          ).selectedAccount.value!.accountNumber,
                      // "username": _usernameController.text,
                      "phone_number": _usernameController.text,
                      "amount": _amountController.text,
                    },
                    apiEndpoint: "api/topup",
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
