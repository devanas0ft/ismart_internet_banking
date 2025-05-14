import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/tvPayment/commonTvPayment/screen/net_tv_detail_page.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class NetTvPaymentWidget extends StatefulWidget {
  final ServiceList service;

  const NetTvPaymentWidget({Key? key, required this.service}) : super(key: key);

  @override
  State<NetTvPaymentWidget> createState() => _NetTvPaymentWidgetState();
}

class _NetTvPaymentWidgetState extends State<NetTvPaymentWidget> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  String? selectedDistrictValue;
  String? selectedProvinceValue;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      body: BlocListener<UtilityPaymentCubit, CommonState>(
        listener: (context, state) {
          print(state);
          if (state is CommonLoading && _isLoading == false) {
            _isLoading = true;
            showLoadingDialogBox(context);
          } else if (state is! CommonLoading && _isLoading) {
            _isLoading = false;
            NavigationService.pop();
          }

          if (state is CommonStateSuccess<UtilityResponseData>) {
            final UtilityResponseData _response = state.data;
            if (_response.code == "M0000") {
              NavigationService.push(
                target: NetTvDetailPage(
                  service: widget.service,
                  detailFetchData: _response,
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
          buttonName: "Proceed",
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
                  title: "Customer ID",
                  hintText: "XXXXXXXXX",
                  controller: usernameController,
                  validator:
                      (value) => FormValidator.validateFieldNotEmpty(
                        value,
                        "Username",
                      ),
                ),
              ],
            ),
          ),
          onButtonPressed: () {
            if (_formKey.currentState!.validate()) {
              onButtonPressed(username: usernameController.text);
              // target: CommonBillDetailPage(
              //     serviceName: widget.service.service,
              //     body: Column(children: [
              //       KeyValueTile(
              //           title: "Username", value: usernameController.text),
              //       KeyValueTile(
              //           title: "Amount", value: amountController.text),
              //     ]),
              //     accountDetails: {
              //       "amount": amountController.text,
              //       "account_number":
              //           RepositoryProvider.of<CustomerDetailRepository>(
              //                   context)
              //               .selectedAccount
              //               .value!
              //               .accountNumber,
              //       "phone_number": usernameController.text
              //     },
              //     apiEndpoint: "/api/topup",
              //     apiBody: const {},
              //     service: widget.service,
              //     serviceIdentifier: widget.service.uniqueIdentifier)
            }
          },
        ),
      ),
    );
  }

  void onButtonPressed({required String username}) {
    context.read<UtilityPaymentCubit>().fetchDetailsPost(
      serviceIdentifier: widget.service.uniqueIdentifier,
      accountDetails: {"username": username},
      apiEndpoint: "api/nettv/details/fetch",
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
