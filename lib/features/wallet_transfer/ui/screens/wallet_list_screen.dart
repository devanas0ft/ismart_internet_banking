import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ismart_web/features/wallet_transfer/cubit/wallet_list_cubit.dart';
import 'package:ismart_web/features/wallet_transfer/resoures/wallet_load_repository.dart';
import 'package:ismart_web/features/wallet_transfer/ui/widgets/wallet_list_widget.dart';

class WalletListScreen extends StatelessWidget {
  const WalletListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => WalletListCubit(
            walletLoadRepository: RepositoryProvider.of<WalletLoadRepository>(
              context,
            ),
          )..fetchWalletList(),
      child: const WalletListWidget(),
    );
  }
}
