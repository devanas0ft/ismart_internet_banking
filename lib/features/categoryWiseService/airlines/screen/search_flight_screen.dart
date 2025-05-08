// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ismart/feature/categoryWiseService/airlines/cubit/airlines_cubit.dart';
// import 'package:ismart/feature/categoryWiseService/airlines/resources/airlines_repository.dart';
// import 'package:ismart/feature/categoryWiseService/airlines/widgets/search_flight_widget.dart';
// import 'package:ismart/feature/dashboard/homePage/homePageTabbar/servicesTab/model/category_model.dart';

// class SearchFlightScreen extends StatelessWidget {
//   final ServiceList service;

//   const SearchFlightScreen({super.key, required this.service});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//         create: (context) => AirlinesCubit(
//             airlinesRepository:
//                 RepositoryProvider.of<AirlinesRepository>(context)),
//         child: SearchFlightWidget(
//           service: service,
//         ));
//   }
// }
