import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ismart_web/features/sendMoney/internalCooperative/cubits/coop_list_cubit.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/models/internal_branch.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/resources/internal_transfer_repository.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/widget/select_coop_branch_widget.dart';

class CoOperativeBranchPage extends StatelessWidget {
  const CoOperativeBranchPage({Key? key, required this.onBankSelected})
    : super(key: key);
  final Function(InternalBranch) onBankSelected;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => CoopListCubit(
                internalTransferRepository:
                    RepositoryProvider.of<InternalTransferRepository>(context),
              ),
        ),
      ],
      child: CoOpBranchListWidget(onBankSelected: onBankSelected),
    );
  }
}
