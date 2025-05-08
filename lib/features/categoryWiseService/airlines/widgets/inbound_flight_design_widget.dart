// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ismart/app/theme.dart';
// import 'package:ismart/common/constant/env.dart';
// import 'package:ismart/common/util/size_utils.dart';
// import 'package:ismart/common/widget/common_button.dart';
// import 'package:ismart/common/widget/custom_cached_network_image.dart';
// import 'package:ismart/common/widget/key_value_tile.dart';
// import 'package:ismart/feature/categoryWiseService/airlines/model/airlines_avliable_list_model.dart';

// // ignore: must_be_immutable
// class InboundFlightDesign extends StatelessWidget {
//   final List<Flight> availableFlights;
//   final Function(Flight) onpress;
//   Flight? selectedFlight;
//   InboundFlightDesign({
//     Key? key,
//     required this.availableFlights,
//     required this.onpress,
//     this.selectedFlight,
//   }) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     final _theme = Theme.of(context);
//     final _textTheme = _theme.textTheme;

//     return Container(
//       height: 100,
//       child: ListView.builder(
//         shrinkWrap: true,
//         itemCount: availableFlights.length,
//         itemBuilder: (context, index) {
//           final flight = availableFlights[index];
//           // final selectedFlight = availableFlights.availability.firstWhere(
//           //   (element) => element.flightId == flight.flightId,
//           // );
//           return InkWell(
//             onTap: () {
//               onpress(flight);
//               selectedFlight = flight;
//             },
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//               margin: const EdgeInsets.only(bottom: 20),
//               decoration: BoxDecoration(
//                   color: selectedFlight?.flightId == flight.flightId
//                       ? CustomTheme.googleColor
//                       : CustomTheme.backgroundColor,
//                   borderRadius: BorderRadius.circular(18)),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CustomCachedNetworkImage(
//                       url:
//                           "${RepositoryProvider.of<CoOperative>(context).baseUrl}ismart/airlinesPdfUrl/${flight.airlineImage}",
//                       height: 20.hp,
//                       fit: BoxFit.contain),
//                   SizedBox(height: 15.hp),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             flight.airline,
//                             style:
//                                 _textTheme.displaySmall!.copyWith(fontSize: 14),
//                           ),
//                           Text(
//                             flight.arrivalTime + " - " + flight.departureTime,
//                             style: _textTheme.titleLarge,
//                           ),
//                         ],
//                       ),
//                       const SizedBox(width: 5),
//                       Column(
//                         children: [
//                           Text('Ticket Price', style: _textTheme.titleLarge),
//                           Text(
//                             flight.totalFare.toString(),
//                             style:
//                                 _textTheme.displaySmall!.copyWith(fontSize: 16),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                   SizedBox(height: 10.hp),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             flight.refundable == "T"
//                                 ? "Refundable"
//                                 : 'Non Refundable',
//                             style: _textTheme.titleSmall!.copyWith(
//                               fontSize: 14,
//                               color: CustomTheme.darkGray,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           Container(
//                             child: CustomRoundedButtom(
//                                 horizontalPadding: 0,
//                                 verticalPadding: 5,
//                                 color: Colors.transparent,
//                                 textColor: CustomTheme.primaryColor,
//                                 borderColor: Colors.transparent,
//                                 fontSize: 14,
//                                 title: 'Fare Summary',
//                                 onPressed: () {
//                                   showModalBottomSheet(
//                                     shape: const RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.only(
//                                             topLeft: Radius.circular(18),
//                                             topRight: Radius.circular(18))),
//                                     context: context,
//                                     builder: (context) {
//                                       return Container(
//                                         padding: const EdgeInsets.all(18.0),
//                                         child: Wrap(
//                                           children: [
//                                             Text("Fare Summary",
//                                                 style:
//                                                     _textTheme.headlineSmall),
//                                             KeyValueTile(
//                                                 title: "Flight Detail",
//                                                 value: flight.airline +
//                                                     flight.flightNo),
//                                             KeyValueTile(
//                                                 title: "Time",
//                                                 value: flight.flightDate
//                                                         .toString() +
//                                                     flight.departureTime +
//                                                     "" +
//                                                     flight.arrivalTime),
//                                             KeyValueTile(
//                                                 title: "Flight Type",
//                                                 value: flight.aircraftType),
//                                             KeyValueTile(
//                                                 title: "Adult Fare",
//                                                 value: flight.adultFare),
//                                             flight.child == "0"
//                                                 ? Container()
//                                                 : KeyValueTile(
//                                                     title: "Child Fare",
//                                                     value: flight.childFare),
//                                             flight.infant == "0"
//                                                 ? Container()
//                                                 : KeyValueTile(
//                                                     title: "Infant Fare",
//                                                     value: flight.infantFare),
//                                             KeyValueTile(
//                                                 title: "Fuel Charge",
//                                                 value: flight.fuelSurcharge),
//                                             KeyValueTile(
//                                               title: "Ticket Type",
//                                               value: flight.refundable == "T"
//                                                   ? "Refundable"
//                                                   : "Non Refundable",
//                                             ),
//                                             KeyValueTile(
//                                                 title: "Free Baggage",
//                                                 value: flight.freeBaggage),
//                                             KeyValueTile(
//                                                 title: "Total Fare",
//                                                 value: "NPR" +
//                                                     flight.totalFare
//                                                         .toString()),
//                                           ],
//                                         ),
//                                       );
//                                     },
//                                   );
//                                 }),
//                           )
//                         ],
//                       ),
//                       const SizedBox(
//                         width: 10,
//                       ),

//                       // onPressed: () {
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
