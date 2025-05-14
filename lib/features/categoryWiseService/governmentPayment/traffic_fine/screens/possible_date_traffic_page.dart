// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ismart/common/util/size_utils.dart';
// import 'package:ismart/feature/categoryWiseService/governmentPayment/traffic_fine/widget/possible_date_traffic_widget.dart';
// import 'package:ismart/feature/dashboard/homePage/homePageTabbar/servicesTab/model/category_model.dart';
// import 'package:ismart/feature/utility_payment/cubit/utility_payment_cubit.dart';
// import 'package:ismart/feature/utility_payment/resources/utility_payment_repository.dart';

// class PossibleDateTrafficPage extends StatelessWidget {
//   final ServiceList service;
//   const PossibleDateTrafficPage({Key? key, required this.service})
//       : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     final _theme = Theme.of(context);
//     final _textTheme = _theme.textTheme;
//     final _width = SizeUtils.width;
//     final _height = SizeUtils.height;
//     return BlocProvider(
//       create: (context) => UtilityPaymentCubit(
//           utilityPaymentRepository:
//               RepositoryProvider.of<UtilityPaymentRepository>(context))
//         ..fetchDetails(
//           serviceIdentifier: service.uniqueIdentifier,
//           accountDetails: {},
//           apiEndpoint: "/api/governmentpayment/possibleFiscalYears",
//         ),
//       child: PossibleDateTrafficWidget(),
//     );
//   }
// }
