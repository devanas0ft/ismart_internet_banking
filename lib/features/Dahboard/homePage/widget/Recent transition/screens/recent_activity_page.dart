import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/Dahboard/homePage/widget/Recent%20transition/recent_activity_widget.dart';
import 'package:ismart_web/features/history/cubit/receipt_download_cubit.dart';
import 'package:ismart_web/features/history/cubit/recent_transaction_cubit.dart';
import 'package:ismart_web/features/history/resources/recent_transaction_repository.dart';

class RecentActivityPage extends StatefulWidget {
  const RecentActivityPage({Key? key}) : super(key: key);

  @override
  State<RecentActivityPage> createState() => _RecentActivityPageState();
}

class _RecentActivityPageState extends State<RecentActivityPage> {
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
      child: RecentActivityTable(),
    );
  }
}
