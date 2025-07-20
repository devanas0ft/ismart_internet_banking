import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/fundManagement/components/load_wallet_content.dart';
import 'package:ismart_web/features/sendMoney/wallet_transfer/cubit/wallet_list_cubit.dart';
import 'package:ismart_web/features/sendMoney/wallet_transfer/cubit/wallet_send_cubit.dart';
import 'package:ismart_web/features/sendMoney/wallet_transfer/cubit/wallet_validate_cubit.dart';
import 'package:ismart_web/features/sendMoney/wallet_transfer/resoures/wallet_load_repository.dart';

class LoadWalletPageProviders extends StatelessWidget {
  const LoadWalletPageProviders({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => WalletListCubit(
                walletLoadRepository:
                    RepositoryProvider.of<WalletLoadRepository>(context),
              )..fetchWalletList(),
        ),
        BlocProvider(
          create:
              (context) => WalletSendCubit(
                walletLoadRepository:
                    RepositoryProvider.of<WalletLoadRepository>(context),
              ),
        ),
        BlocProvider(
          create:
              (context) => WalletValidationCubit(
                walletLoadRepository:
                    RepositoryProvider.of<WalletLoadRepository>(context),
              ),
        ),
      ],
      child: LoadWalletContent(),
    );
  }
}
