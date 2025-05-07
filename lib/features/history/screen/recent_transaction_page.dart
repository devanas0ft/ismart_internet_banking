import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/history/cubit/receipt_download_cubit.dart';
import 'package:ismart_web/features/history/cubit/recent_transaction_cubit.dart';
import 'package:ismart_web/features/history/resources/recent_transaction_repository.dart';
import 'package:ismart_web/features/history/widget/recent_transaction_widget.dart';

class RecentTransactionScreen extends StatefulWidget {
  const RecentTransactionScreen({Key? key}) : super(key: key);

  @override
  State<RecentTransactionScreen> createState() =>
      _RecentTransactionScreenState();
}

class _RecentTransactionScreenState extends State<RecentTransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => RecentTransactionCubit(
                recentTransactionRepository:
                    RepositoryProvider.of<RecentTransactionRepository>(context),
              ),
        ),
        BlocProvider(
          create:
              (context) => TransactionDownloadCubit(
                recentTransactionRepository:
                    RepositoryProvider.of<RecentTransactionRepository>(context),
              ),
        ),
      ],
      child: const RecentTransactionWidget(),
    );
  }
}
