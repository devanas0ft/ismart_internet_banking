import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/sendMoney/wallet_transfer/cubit/wallet_list_cubit.dart';
import 'package:ismart_web/features/sendMoney/wallet_transfer/cubit/wallet_send_cubit.dart';
import 'package:ismart_web/features/sendMoney/wallet_transfer/model/wallet_model.dart';
import 'package:ismart_web/features/sendMoney/wallet_transfer/resoures/wallet_load_repository.dart';
import 'package:ismart_web/features/sendMoney/wallet_transfer/ui/widgets/load_wallet_form_widget.dart';

class LoadWalletFormScreen extends StatelessWidget {
  final String? phoneNumber;
  final String? remarks;

  const LoadWalletFormScreen({
    Key? key,
    required this.selectedWallet,
    this.phoneNumber,
    this.remarks,
  }) : super(key: key);

  final WalletModel selectedWallet;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => WalletListCubit(
                walletLoadRepository:
                    RepositoryProvider.of<WalletLoadRepository>(context),
              ),
        ),
        BlocProvider(
          create:
              (context) => WalletSendCubit(
                walletLoadRepository:
                    RepositoryProvider.of<WalletLoadRepository>(context),
              ),
        ),
      ],
      child: LoadWalletFormWidget(
        remarks: remarks,
        phoneNumber: phoneNumber,
        selectedWallet: selectedWallet,
      ),
    );
  }
}
