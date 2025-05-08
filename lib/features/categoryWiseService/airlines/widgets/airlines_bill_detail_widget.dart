// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ismart/app/theme.dart';
// import 'package:ismart/common/common/data_state.dart';
// import 'package:ismart/common/navigation/navigation_service.dart';
// import 'package:ismart/common/util/size_utils.dart';
// import 'package:ismart/common/widget/common_button.dart';
// import 'package:ismart/common/widget/common_transaction_success_screen.dart';
// import 'package:ismart/common/widget/key_value_tile.dart';
// import 'package:ismart/common/widget/page_wrapper.dart';
// import 'package:ismart/common/widget/primary_account_box.dart';
// import 'package:ismart/common/widget/show_loading_dialog.dart';
// import 'package:ismart/common/widget/show_pop_up_dialog.dart';
// import 'package:ismart/common/widget/transactipon_pin_screen.dart';
// import 'package:ismart/feature/categoryWiseService/airlines/model/airlines_avliable_list_model.dart';
// import 'package:ismart/feature/categoryWiseService/airlines/widgets/flight_detail_box.dart';
// import 'package:ismart/feature/dashboard/homePage/homePageTabbar/servicesTab/model/category_model.dart';
// import 'package:ismart/feature/utility_payment/cubit/utility_payment_cubit.dart';
// import 'package:ismart/feature/utility_payment/models/utility_response_data.dart';
// import 'package:ismart/feature/utility_payment/resources/utility_payment_repository.dart';

// // ignore: must_be_immutable
// class AirlinesBillDetailPage extends StatelessWidget {
//   final String serviceIdentifier;
//   Flight? departureFlight;
//   Flight? arrivalFlight;
//   final String contactName;
//   final String contactPhoneNumber;
//   final bool isTwoWay;
//   final String contactEmail;

//   final double totalFare;

//   final Map<String, dynamic> accountDetails;
//   final Map<String, dynamic> apiBody;
//   final String apiEndpoint;
//   final ServiceList service;
//   final List<dynamic> passengerList;

//   AirlinesBillDetailPage(
//       {super.key,
//       this.departureFlight,
//       this.arrivalFlight,
//       required this.accountDetails,
//       required this.apiEndpoint,
//       required this.apiBody,
//       required this.service,
//       required this.serviceIdentifier,
//       required this.totalFare,
//       required this.contactName,
//       required this.contactPhoneNumber,
//       required this.contactEmail,
//       required this.passengerList,
//       required this.isTwoWay});
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => UtilityPaymentCubit(
//         utilityPaymentRepository:
//             RepositoryProvider.of<UtilityPaymentRepository>(context),
//       ),
//       child: AirlinesBillDetailWidget(
//         isTwoWay: isTwoWay,
//         contactEmail: contactEmail,
//         contactName: contactName,
//         contactPhoneNumber: contactPhoneNumber,
//         service: service,
//         totalFare: totalFare,
//         apiBody: apiBody,
//         arrivalFlight: arrivalFlight,
//         departureFlight: departureFlight,
//         apiEndpoint: apiEndpoint,
//         accountDetails: accountDetails,
//         serviceIdentifier: serviceIdentifier,
//         passengerList: passengerList,
//       ),
//     );
//   }
// }

// // ignore: must_be_immutable
// class AirlinesBillDetailWidget extends StatefulWidget {
//   final ServiceList service;
//   final List passengerList;
//   final bool isTwoWay;

//   final Map<String, dynamic> accountDetails;
//   final Map<String, dynamic> apiBody;
//   final String apiEndpoint;
//   final String serviceIdentifier;
//   Flight? departureFlight;
//   Flight? arrivalFlight;
//   final double totalFare;
//   final String contactName;
//   final String contactPhoneNumber;
//   final String contactEmail;

//   AirlinesBillDetailWidget({
//     super.key,
//     required this.accountDetails,
//     this.departureFlight,
//     this.arrivalFlight,
//     required this.apiEndpoint,
//     required this.apiBody,
//     required this.service,
//     required this.serviceIdentifier,
//     required this.totalFare,
//     required this.contactName,
//     required this.contactPhoneNumber,
//     required this.contactEmail,
//     required this.passengerList,
//     required this.isTwoWay,
//   });

//   @override
//   State<AirlinesBillDetailWidget> createState() =>
//       _AirlinesBillDetailWidgetState();
// }

// class _AirlinesBillDetailWidgetState extends State<AirlinesBillDetailWidget> {
//   bool _isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     final _theme = Theme.of(context);
//     final _textTheme = _theme.textTheme;

//     return PageWrapper(
//       backgroundColor: CustomTheme.white,
//       padding: EdgeInsets.zero,
//       useOwnAppBar: true,
//       appBar: AppBar(
//           elevation: 0,
//           backgroundColor: CustomTheme.white,
//           title: Text(
//             widget.service.service,
//             style: _textTheme.displaySmall,
//           )),
//       body: BlocListener<UtilityPaymentCubit, CommonState>(
//         listener: (context, state) {
//           if (state is CommonLoading && _isLoading == false) {
//             _isLoading = true;
//             showLoadingDialogBox(context);
//           }
//           if (state is! CommonLoading && _isLoading) {
//             NavigationService.pop();
//             _isLoading = false;
//           }

//           if (state is CommonError) {
//             showPopUpDialog(
//               context: context,
//               message: state.message,
//               title: "Error",
//               showCancelButton: false,
//               buttonCallback: () {
//                 NavigationService.pop();
//               },
//             );
//           }

//           if (state is CommonStateSuccess<UtilityResponseData>) {
//             final UtilityResponseData _response = state.data;
//             if (_response.code == "M0000" ||
//                 _response.status.toLowerCase() == "M0000" ||
//                 _response.status.toLowerCase() == "success" ||
//                 _response.message
//                     .toLowerCase()
//                     .contains("success".toLowerCase())) {
//               NavigationService.pushReplacement(
//                   target: CommonTransactionSuccessPage(
//                       serviceName: widget.service.service,
//                       arrival: widget.arrivalFlight,
//                       departure: widget.departureFlight,
//                       pdfUrl:
//                           state.data.findValue(primaryKey: "airlinesPdfUrl"),
//                       transactionID: state.data.transactionIdentifier,
//                       body: Container(),
//                       message: state.data.message,
//                       service: widget.service));
//             } else {
//               showPopUpDialog(
//                 context: context,
//                 message: _response.message,
//                 title: _response.status,
//                 showCancelButton: false,
//                 buttonCallback: () {
//                   NavigationService.pop();
//                 },
//               );
//             }
//           }
//         },
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(18),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         const Text(
//                           "From Account",
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 14,
//                             color: CustomTheme.lightTextColor,
//                           ),
//                         ),
//                         const PrimaryAccountBox(),
//                         Text(
//                           "Flight Details",
//                           style: _textTheme.headlineMedium,
//                         ),
//                         FlightDetailBox(
//                           flight: widget.departureFlight,
//                         ),
//                         if (widget.isTwoWay == true)
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 10),
//                             child: FlightDetailBox(
//                               flight: widget.arrivalFlight,
//                             ),
//                           ),
//                         Text(
//                           "Contact Detail",
//                           style: _textTheme.headlineSmall,
//                         ),
//                         Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.all(18),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(18),
//                             color: const Color(0xFFF4F4F9),
//                           ),
//                           child: Column(children: [
//                             KeyValueTile(
//                                 title: "Contact Name",
//                                 value: widget.contactName),
//                             KeyValueTile(
//                                 title: "Contact Email",
//                                 value: widget.contactEmail),
//                             KeyValueTile(
//                                 title: "Contact Contact",
//                                 value: widget.contactPhoneNumber)
//                           ]),
//                         ),
//                         Text(
//                           "Passenger Detail",
//                           style: _textTheme.headlineSmall,
//                         ),
//                         Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.all(18),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(18),
//                             color: const Color(0xFFF4F4F9),
//                           ),
//                           child: ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: widget.passengerList.length,
//                               itemBuilder: (context, index) {
//                                 return Wrap(spacing: 10.wp, children: [
//                                   Text(
//                                     (index + 1).toString() + " -",
//                                     style:
//                                         _theme.textTheme.titleSmall!.copyWith(
//                                       fontWeight: FontWeight.w700,
//                                     ),
//                                   ),
//                                   Text(widget.passengerList[index]["title"],
//                                       style:
//                                           _theme.textTheme.titleSmall!.copyWith(
//                                         fontWeight: FontWeight.w700,
//                                       )),
//                                   Text(
//                                       widget.passengerList[index]["firstName"] +
//                                           " " +
//                                           widget.passengerList[index]
//                                               ["lastName"],
//                                       style:
//                                           _theme.textTheme.titleSmall!.copyWith(
//                                         fontWeight: FontWeight.w700,
//                                       )),
//                                   Text(
//                                       widget.passengerList[index]
//                                           ["nationality"],
//                                       style:
//                                           _theme.textTheme.titleSmall!.copyWith(
//                                         fontWeight: FontWeight.w700,
//                                       )),
//                                   Text(widget.passengerList[index]["paxType"],
//                                       style:
//                                           _theme.textTheme.titleSmall!.copyWith(
//                                         fontWeight: FontWeight.w700,
//                                       )),
//                                 ]);
//                               }),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(18),
//                   color: _theme.scaffoldBackgroundColor),
//               padding: const EdgeInsets.all(18),
//               child: Column(children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Total Paying",
//                       style: _textTheme.headlineSmall,
//                     ),
//                     Text(
//                       "Rs " +
//                           widget.departureFlight!
//                               .getTotalFareAfterCashback()
//                               .toString(),
//                       style: _textTheme.displaySmall!
//                           .copyWith(color: _theme.primaryColor),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10.hp),
//                 CustomRoundedButtom(
//                     verificationAmount: widget.departureFlight!
//                         .getTotalFareAfterCashback()
//                         .toString(),
//                     title: "Pay",
//                     onPressed: () {
//                       NavigationService.push(target: TransactionPinScreen(
//                         onValueCallback: (p0) {
//                           NavigationService.pop();

//                           context.read<UtilityPaymentCubit>().makePayment(
//                                 mPin: p0,
//                                 serviceIdentifier: widget.serviceIdentifier,
//                                 apiEndpoint: widget.apiEndpoint,
//                                 body: widget.apiBody,
//                                 accountDetails: widget.accountDetails,
//                               );
//                         },
//                       ));
//                     }),
//               ]),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
