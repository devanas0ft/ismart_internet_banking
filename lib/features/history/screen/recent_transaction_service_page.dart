import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/history/cubit/receipt_download_cubit.dart';
import 'package:ismart_web/features/history/cubit/recent_transaction_cubit.dart';
import 'package:ismart_web/features/history/models/recent_transaction_model.dart';
import 'package:ismart_web/features/history/resources/recent_transaction_repository.dart';
import 'package:ismart_web/features/history/widget/recent_transaction_service_widget.dart';

class RecentTransactionServiceScreen extends StatelessWidget {
  final String serviceCategoryId;
  final String associatedId;
  final String? service;
  final String serviceId;
  final VoidCallback onListTap;

  final Function(RecentTransactionModel) onRecentTransactionPressed;

  const RecentTransactionServiceScreen({
    Key? key,
    required this.serviceCategoryId,
    required this.associatedId,
    this.service,
    required this.onRecentTransactionPressed,
    required this.onListTap,
    required this.serviceId,
  }) : super(key: key);

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
      child: RecentTransactionServiceWidget(
        onRecentTransactionPressed: onRecentTransactionPressed,
        service: service ?? "SERVICE",
        associatedId: associatedId,
        serviceCategoryId: serviceCategoryId,
        serviceId: serviceId,
        onListTap: onListTap,
      ),
    );
  }
}
