import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/cubits/coop_list_cubit.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/resources/internal_transfer_repository.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/widget/internal_cooperative_widget.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class InternalCooperativePage extends StatelessWidget {
  final bool? isFavAccount;
  final String? branchName;
  final String? accountNumber;
  final String? accountName;
  final String? branchCode;
  final String? remarks;
  final String? branchId;

  const InternalCooperativePage({
    Key? key,
    this.accountNumber,
    this.accountName,
    this.branchCode,
    this.remarks,
    this.isFavAccount,
    this.branchName,
    this.branchId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => UtilityPaymentCubit(
                utilityPaymentRepository:
                    RepositoryProvider.of<UtilityPaymentRepository>(context),
              ),
        ),
        BlocProvider(
          create:
              (context) => CoopListCubit(
                internalTransferRepository:
                    RepositoryProvider.of<InternalTransferRepository>(context)
                      ..getBranchList(),
              ),
        ),
      ],
      child: InternalCooperativeWidget(
        branchId: branchId ?? "",
        isFavAccount: isFavAccount,
        branchName: branchName,
        remarks: remarks,
        accountName: accountName,
        accountNumber: accountNumber,
        branchCodeQr: branchCode,
      ),
    );
  }
}
