// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ismart_web/features/receiveMoney/cubit/receive_money_cubit.dart';
// import 'package:ismart_web/features/receiveMoney/internetBanking/widget/internet_banking_widget.dart';
// import 'package:ismart_web/features/receiveMoney/resources/receive_money_repository.dart';

// class InternetBankingPage extends StatelessWidget {
//   const InternetBankingPage({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create:
//           (context) => ReceiveMoneyCubit(
//             receiveMoneyRepository:
//                 RepositoryProvider.of<ReceiveMoneyRepository>(context),
//           ),
//       child: const InternetBankingWidget(),
//     );
//   }
// }
