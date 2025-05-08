// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ismart/common/util/size_utils.dart';
// import 'package:ismart/feature/categoryWiseService/airlines/cubit/airlines_cubit.dart';
// import 'package:ismart/feature/categoryWiseService/airlines/model/airlines_sector_model.dart';
// import 'package:ismart/feature/categoryWiseService/airlines/resources/airlines_repository.dart';
// import 'package:ismart/feature/categoryWiseService/airlines/widgets/location_list_widget.dart';
// import 'package:ismart/feature/utility_payment/cubit/utility_payment_cubit.dart';
// import 'package:ismart/feature/utility_payment/resources/utility_payment_repository.dart';

// class LoationListFlightPage extends StatelessWidget {
//   final Function(AirlinesSectorList) selectedLocation;
//   const LoationListFlightPage({Key? key, required this.selectedLocation})
//       : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     final _theme = Theme.of(context);
//     final _textTheme = _theme.textTheme;
//     final _width = SizeUtils.width;
//     final _height = SizeUtils.height;
//     return BlocProvider(
//       create: (context) => AirlinesCubit(
//           airlinesRepository:
//               RepositoryProvider.of<AirlinesRepository>(context)),
//       child: FlightSear(selectedLocation: selectedLocation),
//     );
//   }
// }
