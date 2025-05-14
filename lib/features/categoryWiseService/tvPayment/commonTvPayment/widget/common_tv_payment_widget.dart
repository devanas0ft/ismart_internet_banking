// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ismart/common/common/data_state.dart';
// import 'package:ismart/common/constant/env.dart';
// import 'package:ismart/common/navigation/navigation_service.dart';
// import 'package:ismart/common/util/form_validator.dart';
// import 'package:ismart/common/util/size_utils.dart';
// import 'package:ismart/common/widget/common_bill_details_screen.dart';
// import 'package:ismart/common/widget/common_container.dart';
// import 'package:ismart/common/widget/common_text_field.dart';
// import 'package:ismart/common/widget/common_transaction_success_screen.dart';
// import 'package:ismart/common/widget/key_value_tile.dart';
// import 'package:ismart/common/widget/page_wrapper.dart';
// import 'package:ismart/common/widget/show_loading_dialog.dart';
// import 'package:ismart/common/widget/show_pop_up_dialog.dart';
// import 'package:ismart/common/widget/transactipon_pin_screen.dart';
// import 'package:ismart/feature/categoryWiseService/governmentPayment/ui/screen/gov_place_page.dart';
// import 'package:ismart/feature/customerDetail/model/customer_detail_model.dart';
// import 'package:ismart/feature/customerDetail/resource/customer_detail_repository.dart';
// import 'package:ismart/feature/dashboard/homePage/homePageTabbar/servicesTab/model/category_model.dart';
// import 'package:ismart/feature/receiveMoney/models/bank.dart';
// import 'package:ismart/feature/utility_payment/cubit/utility_payment_cubit.dart';
// import 'package:ismart/feature/utility_payment/models/utility_response_data.dart';

// class CommonTvPaymentWidget extends StatefulWidget {
//   final ServiceList service;

//   const CommonTvPaymentWidget({Key? key, required this.service})
//       : super(key: key);

//   @override
//   State<CommonTvPaymentWidget> createState() => _CommonTvPaymentWidgetState();
// }

// class _CommonTvPaymentWidgetState extends State<CommonTvPaymentWidget> {
//   final TextEditingController amountController = TextEditingController();
//   final TextEditingController usernameController = TextEditingController();
//   String? selectedDistrictValue;
//   String? selectedProvinceValue;
//   bool _isLoading = false;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     final _theme = Theme.of(context);
//     final _textTheme = _theme.textTheme;
//     final _width = SizeUtils.width;
//     final _height = SizeUtils.height;
//     return PageWrapper(
//         body: BlocListener<UtilityPaymentCubit, CommonState>(
//       listener: (context, state) {
//         print(state);
//         if (state is CommonLoading && _isLoading == false) {
//           _isLoading = true;
//           showLoadingDialogBox(context);
//         } else if (state is! CommonLoading && _isLoading) {
//           _isLoading = false;
//           NavigationService.pop();
//         }
//         if (state is CommonError) {
//           showPopUpDialog(
//             context: context,
//             message: state.message,
//             title: "Error",
//             showCancelButton: false,
//             buttonCallback: () {
//               NavigationService.pop();
//             },
//           );
//         }
//         if (state is CommonStateSuccess<UtilityResponseData>) {
//           UtilityResponseData _response = state.data;
//           if (_response.code == "M0000" ||
//               _response.status.toLowerCase() == "success") {
//             NavigationService.push(
//               target: CommonBillDetailPage(
//                 serviceIdentifier: widget.service.uniqueIdentifier,
//                 apiEndpoint: "/api/tvpay",
//                 apiBody: {"customerId ": usernameController.text},
//                 accountDetails: {
//                   "account_number":
//                       RepositoryProvider.of<CustomerDetailRepository>(context)
//                           .selectedAccount
//                           .value!
//                           .accountNumber
//                           .toString(),
//                   "username": usernameController.text,
//                   // "customer_id": usernameController.text,
//                   "amount": amountController.text,
//                   // "account_number": "002001-001-102-0001010",

//                   // "amount": myAmount,
//                   // "amount": _response.findValue(
//                   //     primaryKey: "hashResposne",
//                   //     secondaryKey: "formattedFinalAmount"),
//                 },
//                 service: widget.service,
//                 body: Column(
//                   children: [
//                     KeyValueTile(
//                         title: "Customer ID",
//                         value: _response.findValue(
//                           primaryKey: "hashResponse",
//                           secondaryKey: "customerId ",
//                         )),
//                     KeyValueTile(
//                         title: "Customer Name",
//                         value: _response
//                             .findValue(
//                               primaryKey: "hashResponse",
//                               secondaryKey: "customerName",
//                             )
//                             .toString()),
//                     KeyValueTile(title: "Amount", value: amountController.text),
//                     _response.findValue(
//                                 primaryKey: "hashResponse",
//                                 secondaryKey: "customerName") ==
//                             null
//                         ? Container()
//                         : Column(
//                             children: [
//                               KeyValueTile(
//                                   title: "Number of TV",
//                                   value: _response
//                                       .findValue(
//                                         primaryKey: "hashResponse",
//                                         secondaryKey: "currentPackages",
//                                       )
//                                       .toString()),
//                             ],
//                           ),
//                     KeyValueTile(
//                         title: "Number of TV",
//                         value: _response
//                             .findValue(
//                               primaryKey: "hashResponse",
//                               secondaryKey: "noOfTv",
//                             )
//                             .toString()),
//                     KeyValueTile(
//                         title: "CashBack",
//                         value: widget.service.cashBackView ?? "0 %"),
//                   ],
//                 ),
//               ),
//             );
//           } else {
//             showPopUpDialog(
//               context: context,
//               message: _response.message,
//               title: _response.status,
//               showCancelButton: false,
//               buttonCallback: () {
//                 NavigationService.pop();
//               },
//             );
//           }
//         }
//       },
//       child: CommonContainer(
//         showBottomSheet: true,
//         associatedId: widget.service.id.toString(),
//         showAccountSelection: true,
//         buttonName: "Show Bill",
//         title: widget.service.service,
//         detail: widget.service.instructions,
//         showDetail: true,
//         topbarName: widget.service.serviceCategoryName,
//         body: Form(
//           autovalidateMode: AutovalidateMode.onUserInteraction,
//           key: _formKey,
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     height: _height * 0.11,
//                     width: _width * 0.23,
//                     margin: const EdgeInsets.only(right: 18),
//                     child: Image.network(
//                         "${RepositoryProvider.of<CoOperative>(context).baseUrl}/ismart/serviceIcon/${widget.service.icon}"),
//                   ),
//                   Expanded(
//                     child: Text(widget.service.service,
//                         style: Theme.of(context)
//                             .textTheme
//                             .titleLarge!
//                             .copyWith(fontWeight: FontWeight.w700)),
//                   ),
//                 ],
//               ),
//               SizedBox(height: _height * 0.02),
//               CustomTextField(
//                 title: widget.service.labelName,
//                 hintText: "XXXXXXXXX",
//                 controller: usernameController,
//                 validator: (value) =>
//                     FormValidator.validateFieldNotEmpty(value, "Username"),
//               ),
//               widget.service.priceInput
//                   ? CustomTextField(
//                       title: "Amount",
//                       hintText: "NPR",
//                       controller: amountController,
//                       // validator: (value) => FormValidator.validateAmount(
//                       //     val: value.toString(),
//                       //     maxAmount: widget.service.maxValue,
//                       //     minAmount: widget.service.minValue.toDouble())),
//                     )
//                   : Container()
//             ],
//           ),
//         ),
//         onButtonPressed: () {
//           if (_formKey.currentState!.validate()) {
//             context.read<UtilityPaymentCubit>().fetchDetails(
//                 serviceIdentifier: widget.service.uniqueIdentifier,
//                 accountDetails: {"username": usernameController.text},
//                 apiEndpoint: "api/tvpackages");
//           }
//         },
//       ),
//     ));
//   }
// }

//   // NavigationService.push(target: TransactionPinScreen(
//                 //   onValueCallback: (p0) {
//                 //     NavigationService.pop();

//                 //     context.read<UtilityPaymentCubit>().makePayment(
//                 //         serviceIdentifier: widget.service.uniqueIdentifier,
//                 //         // serviceIdentifier: "traffic_fine_payments",
//                 //         apiEndpoint: "/api/tvpay",
//                 //         body: {
//                 //           "customerId ": usernameController.text
//                 //         },
//                 //         accountDetails: {
//                 //           "account_number":
//                 //               RepositoryProvider.of<CustomerDetailRepository>(
//                 //                       context)
//                 //                   .selectedAccount
//                 //                   .value!
//                 //                   .accountNumber
//                 //                   .toString(),
//                 //           "username": usernameController.text,
//                 //           "customer_id": usernameController.text,
//                 //           "amount": amountController.text,
//                 //           // "account_number": "002001-001-102-0001010",

//                 //           // "amount": myAmount,
//                 //           // "amount": _response.findValue(
//                 //           //     primaryKey: "hashResposne",
//                 //           //     secondaryKey: "formattedFinalAmount"),
//                 //           "mPin": p0
//                 //         });
//                 //   },
//                 // ));
