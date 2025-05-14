import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/constants/slugs.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/widget/common_amount_box.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';

import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/tvPayment/resources/tv_detail_model.dart';
import 'package:ismart_web/features/categoryWiseService/tvPayment/resources/tv_payment_cubit.dart';
import 'package:ismart_web/features/categoryWiseService/tvPayment/screen/tv_payment_detail_page.dart';

class TvPaymentWidget extends StatefulWidget {
  final ServiceList service;

  const TvPaymentWidget({Key? key, required this.service}) : super(key: key);

  @override
  State<TvPaymentWidget> createState() => _TvPaymentWidgetState();
}

class _TvPaymentWidgetState extends State<TvPaymentWidget> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController customerIDController = TextEditingController();
  final TextEditingController setupBoxController = TextEditingController();
  // final bool _changePackage = false;

  String? selectedDistrictValue;
  String? selectedProvinceValue;
  bool _isLoading = false;
  String _currentAmount = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // getAmount() {
  //   if (amountController.text.isEmpty) {
  //     return "";
  //   } else {
  //     return amountController.text;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      body: BlocListener<TvPaymentCubit, CommonState>(
        listener: (context, state) {
          print(state);
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

          if (state is CommonStateSuccess<TvDetailModel>) {
            final TvDetailModel _response = state.data;

            if (_response.code == "M0000" ||
                _response.status.toLowerCase() == "success") {
              NavigationService.push(
                target: TvPaymentDeatilPage(
                  amount: amountController.text,
                  detailFetchData: _response,
                  service: widget.service,
                  customerID: customerIDController.text,
                ),
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
        child: CommonContainer(
          verificationAmount: _currentAmount,
          showRecentTransaction: true,
          associatedId: widget.service.id.toString(),
          showAccountSelection: true,
          buttonName: "Show Bill ",
          title: widget.service.service,
          detail: widget.service.instructions,
          showDetail: true,
          topbarName: widget.service.serviceCategoryName,
          body: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              children: [
                // Row(
                //   children: [
                //     Container(
                //       height: _height * 0.11,
                //       width: _width * 0.23,
                //       margin: const EdgeInsets.only(right: 18),
                //       child: Image.network(
                //           "${RepositoryProvider.of<CoOperative>(context).baseUrl}/ismart/serviceIcon/${widget.service.icon}"),
                //     ),
                //     Expanded(
                //       child: Text(widget.service.service,
                //           style: Theme.of(context)
                //               .textTheme
                //               .titleLarge!
                //               .copyWith(fontWeight: FontWeight.w700)),
                //     ),
                //   ],
                // ),
                // SizedBox(height: _height * 0.02),
                CustomTextField(
                  title: widget.service.labelName,
                  hintText: widget.service.labelSample,
                  controller: customerIDController,
                  validator:
                      (value) => FormValidator.validateFieldNotEmpty(
                        value,
                        "Username",
                      ),
                ),
                widget.service.uniqueIdentifier.toLowerCase() == Slugs.skyTopup
                    ? CustomTextField(
                      title: "SetTop Box no.",
                      hintText: "Setup Box No.",
                      controller: setupBoxController,
                      validator:
                          (value) => FormValidator.validateFieldNotEmpty(
                            value,
                            "Customer ID",
                          ),
                    )
                    : Container(),
                CommonAmountBox(
                  onChanged: (value) {
                    amountController.text = value;
                    setState(() {
                      _currentAmount = value;
                    });
                  },
                  textController: amountController,
                  service: widget.service,
                ),
                // widget.service.priceInput
                //     ? CustomTextField(
                //         title: "Amount",
                //         hintText: "NPR",
                //         controller: amountController,
                //         validator: (value) => FormValidator.validateAmount(
                //             val: value.toString(),
                //             maxAmount: widget.service.maxValue,
                //             minAmount: widget.service.minValue),
                //       )
                //     : Container()
              ],
            ),
          ),
          onButtonPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<TvPaymentCubit>().fetchDetails(
                serviceIdentifier: widget.service.uniqueIdentifier,
                accountDetails: {
                  "username": customerIDController.text,
                  "customer_id": customerIDController.text,
                },
                apiEndpoint: "api/tvpackages",
              );
            }
          },
        ),
      ),
    );
  }
}

// NavigationService.push(target: TransactionPinScreen(
//   onValueCallback: (p0) {
//     NavigationService.pop();

//     context.read<UtilityPaymentCubit>().makePayment(
//         serviceIdentifier: widget.service.uniqueIdentifier,
//         // serviceIdentifier: "traffic_fine_payments",
//         apiEndpoint: "/api/tvpay",
//         body: {
//           "customerId ": usernameController.text
//         },
//         accountDetails: {
//           "account_number":
//               RepositoryProvider.of<CustomerDetailRepository>(
//                       context)
//                   .selectedAccount
//                   .value!
//                   .accountNumber
//                   .toString(),
//           "username": usernameController.text,
//           "customer_id": usernameController.text,
//           "amount": amountController.text,
//           // "account_number": "002001-001-102-0001010",

//           // "amount": myAmount,
//           // "amount": _response.findValue(
//           //     primaryKey: "hashResposne",
//           //     secondaryKey: "formattedFinalAmount"),
//           "mPin": p0
//         });
//   },
// ));
