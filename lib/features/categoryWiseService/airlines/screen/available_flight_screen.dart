// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ismart/common/models/key_value.dart';
// import 'package:ismart/feature/categoryWiseService/airlines/cubit/airlines_cubit.dart';
// import 'package:ismart/feature/categoryWiseService/airlines/model/airlines_avliable_list_model.dart';
// import 'package:ismart/feature/categoryWiseService/airlines/resources/airlines_repository.dart';
// import 'package:ismart/feature/categoryWiseService/airlines/widgets/available_flight_widget_test.dart';
// import 'package:ismart/feature/dashboard/homePage/homePageTabbar/servicesTab/model/category_model.dart';
// import 'package:ismart/feature/utility_payment/cubit/utility_payment_cubit.dart';
// import 'package:ismart/feature/utility_payment/resources/utility_payment_repository.dart';

// class AvailableFlightPage extends StatelessWidget {
//   final KeyValue fromSector;
//   final KeyValue toSector;

//   final ServiceList service;

//   final SearchFlightResponse flightDetail;
//   final bool isTwoWay;
//   const AvailableFlightPage({
//     super.key,
//     required this.adultCount,
//     required this.childrenCount,
//     required this.flightDetail,
//     required this.service,
//     required this.isTwoWay,
//     required this.fromSector,
//     required this.toSector,
//   });
//   final int adultCount;
//   final int childrenCount;

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => AirlinesCubit(
//               airlinesRepository:
//                   RepositoryProvider.of<AirlinesRepository>(context)),
//         ),
//         BlocProvider(
//           create: (context) => UtilityPaymentCubit(
//               utilityPaymentRepository:
//                   RepositoryProvider.of<UtilityPaymentRepository>(context)),
//         ),
//       ],
//       child: AvailableFlightsListWidget(
//         fromSector: fromSector,
//         inboundFlights: flightDetail.inboundFlights,
//         isTwoWay: isTwoWay,
//         outboundFlights: flightDetail.outboundFligts,
//         serviceInfo: service,
//         toSector: toSector,
//         useServiceResponse: flightDetail,
//         adultCount: adultCount,
//         childrenCount: childrenCount,
//       ),
//     );
//   }
// }
