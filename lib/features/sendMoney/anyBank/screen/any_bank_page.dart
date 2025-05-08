import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/sendMoney/anyBank/widgets/any_bank_widget.dart';
import 'package:ismart_web/features/sendMoney/cubits/bank_charge_cubit.dart';
import 'package:ismart_web/features/sendMoney/cubits/send_to_bank_cubit.dart';
import 'package:ismart_web/features/sendMoney/resources/send_to_bank_repository.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class AnyBankpage extends StatelessWidget {
  final String? remarks;
  final String? accountNumber;
  final String? accountName;
  final String? bankCode;
  final String? bankName;
  final bool? isScanQr;

  const AnyBankpage({
    Key? key,
    this.accountNumber,
    this.accountName,
    this.bankCode,
    this.bankName,
    this.isScanQr,
    this.remarks,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => BankChargeCubit(
                sendToBankRepository:
                    RepositoryProvider.of<SendToBankRepository>(context),
              ),
        ),
        BlocProvider(
          create:
              (_) => SendToBankCubit(
                sendToBankRepository:
                    RepositoryProvider.of<SendToBankRepository>(context),
              ),
        ),
        BlocProvider(
          create:
              (_) => UtilityPaymentCubit(
                utilityPaymentRepository:
                    RepositoryProvider.of<UtilityPaymentRepository>(context),
              ),
        ),
      ],
      child: AnyBankWidget(
        isScanQr: isScanQr,
        remarks: remarks,
        accountName: accountName,
        accountNumber: accountNumber,
        bankCode: bankCode,
        bankName: bankName,
      ),
    );
  }
}
