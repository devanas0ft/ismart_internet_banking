// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:ismart/common/constant/env.dart';
// import 'package:ismart/common/navigation/navigation_service.dart';
// import 'package:ismart/common/util/form_validator.dart';
// import 'package:ismart/common/util/url_utils.dart';
// import 'package:ismart/common/widget/common_container.dart';
// import 'package:ismart/common/widget/common_text_field.dart';
// import 'package:ismart/common/widget/page_wrapper.dart';
// import 'package:ismart/common/widget/payment_web_view.dart';
// import 'package:ismart/feature/authentication/resource/user_repository.dart';
// import 'package:ismart/feature/customerDetail/resource/customer_detail_repository.dart';
// import 'package:ismart/feature/receiveMoney/mobileBanking/screen/receive_money_bank_list_screen.dart';
// import 'package:ismart/feature/sendMoney/models/bank.dart';
// import 'package:ismart_web/common/widget/common_container.dart';
// import 'package:ismart_web/common/widget/page_wrapper.dart';
// import 'package:ismart_web/features/auth/resources/user_repository.dart';
// import 'package:ismart_web/features/sendMoney/models/bank.dart';

// class InternetBankingWidget extends StatefulWidget {
//   const InternetBankingWidget({Key? key}) : super(key: key);

//   @override
//   State<InternetBankingWidget> createState() => _InternetBankingWidgetState();
// }

// class _InternetBankingWidgetState extends State<InternetBankingWidget> {
//   String _token = "";

//   final TextEditingController _amountController = TextEditingController();
//   final TextEditingController _remarksController = TextEditingController();
//   final TextEditingController _bankNameController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   Bank? selectedBank;

//   @override
//   void initState() {
//     // TODO: implement initState
//     _token = RepositoryProvider.of<UserRepository>(context).token;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PageWrapper(
//       body: CommonContainer(
//         showDetail: true,
//         showAccountSelection: true,
//         accountTitle: "To Account",
//         body: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               CustomTextField(
//                 hintText: "Select Bank",
//                 title: "Select Bank",
//                 readOnly: true,
//                 controller: _bankNameController,
//                 validator: (val) {
//                   if (selectedBank == null) {
//                     return "Please select a bank to proceed.";
//                   }
//                   return null;
//                 },
//                 onTap: () {
//                   NavigationService.push(
//                     target: ReceiveMoneyBankListScreen(
//                       onBankSelected: (val) {
//                         NavigationService.pop();

//                         selectedBank = val;
//                         _bankNameController.text = val.bankName;
//                         setState(() {});
//                       },
//                       type: "ismarts",
//                     ),
//                   );
//                 },
//               ),

//               CustomTextField(
//                 title: "Amount",
//                 hintText: "NPR ",
//                 controller: _amountController,
//                 validator: (val) {
//                   if ((int.tryParse(val ?? "") ?? 0) < 100) {
//                     return "Minimum amount is Rs. 100";
//                   } else if ((int.tryParse(val ?? "") ?? 0) > 200000) {
//                     return "Maximum amount is Rs. 2,00,000";
//                   } else {
//                     return null;
//                   }
//                 },
//               ),
//               //TODO :need to add amount selection box
//               // CustomTextField(
//               //   title: "Charge",
//               //   hintText: "NPR 10.00",
//               // ),
//               CustomTextField(
//                 title: "Remarks",
//                 hintText: "Remarks",
//                 controller: _remarksController,
//                 validator: (value) =>
//                     FormValidator.validateFieldNotEmpty(value, "Remarks"),
//               ),
//             ],
//           ),
//         ),
//         topbarName: "Receive Money",
//         buttonName: "Proceed",
//         onButtonPressed: () {
//           if (_formKey.currentState!.validate()) {
//             final _body = {
//               "accountNo":
//                   RepositoryProvider.of<CustomerDetailRepository>(context)
//                       .selectedAccount
//                       .value!
//                       .accountNumber,
//               "amount": _amountController.text,
//               "bankCode": selectedBank?.bankId ?? "",
//               "remarks": _remarksController.text,
//             };
//             final _url = RepositoryProvider.of<CoOperative>(context).baseUrl +
//                 "api/load_from_bank/payment/";
//             final url = UrlUtils.getUri(url: _url, params: _body);

//             NavigationService.push(
//               target: PaymentWebView(
//                 // urlRequest: URLRequest(url: url, headers: {

//                 urlRequest: URLRequest(url: WebUri.uri(url), headers: {
//                   "Authorization": "Bearer $_token",
//                 }),
//                 receiptUrl: "receiptUrl",
//               ),
//             );
//           }
//         },
//         title: "Internet Banking",
//         detail: "Load fund instantly from internet banking.",
//       ),
//     );
//   }
// }
