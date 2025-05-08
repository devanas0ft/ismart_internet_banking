import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/sendMoney/anyBank/widgets/bank_list_widget.dart';
import 'package:ismart_web/features/sendMoney/cubits/send_to_bank_cubit.dart';
import 'package:ismart_web/features/sendMoney/models/bank.dart';
import 'package:ismart_web/features/sendMoney/resources/send_to_bank_repository.dart';

class BankListPage extends StatelessWidget {
  const BankListPage({Key? key, required this.onBankSelected})
    : super(key: key);
  final Function(Bank) onBankSelected;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => SendToBankCubit(
                sendToBankRepository:
                    RepositoryProvider.of<SendToBankRepository>(context),
              ),
        ),
      ],
      child: BanksListWidget(onBankSelected: onBankSelected),
    );
  }
}
