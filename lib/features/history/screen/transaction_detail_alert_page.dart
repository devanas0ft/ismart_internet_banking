// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ismart/common/util/size_utils.dart';
// import 'package:ismart/feature/history/cubit/recent_transaction_cubit.dart';
// import 'package:ismart/feature/history/models/recent_transaction_model.dart';
// import 'package:ismart/feature/history/resources/recent_transaction_repository.dart';
// import 'package:ismart/feature/history/widget/transaction_detail_widget.dart';

// class TransactionDetailAlertPage extends StatelessWidget {
//   final RecentTransactionModel recentTransactionModel;
//   const TransactionDetailAlertPage(
//       {Key? key, required this.recentTransactionModel})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final _theme = Theme.of(context);
//     final _textTheme = _theme.textTheme;
//     final _width = SizeUtils.width;
//     final _height = SizeUtils.height;
//     return BlocProvider(
//       create: (context) => RecentTransactionCubit(
//         recentTransactionRepository:
//             RepositoryProvider.of<RecentTransactionRepository>(context),
//       )..generateUrl(
//           transactionId: recentTransactionModel.transactionIdentifier,
//         ),
//       child: TransactionDetailWidget(
//         recentTransactionModel: recentTransactionModel,
//       ),
//     );
//   }
// }
