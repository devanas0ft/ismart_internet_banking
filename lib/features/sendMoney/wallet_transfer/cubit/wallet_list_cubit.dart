import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/common/utils/hive_utils.dart';
import 'package:ismart_web/features/sendMoney/wallet_transfer/model/wallet_model.dart';
import 'package:ismart_web/features/sendMoney/wallet_transfer/model/wallet_validation_model.dart';
import 'package:ismart_web/features/sendMoney/wallet_transfer/resoures/wallet_load_repository.dart';

class WalletListCubit extends Cubit<CommonState> {
  final WalletLoadRepository walletLoadRepository;
  WalletListCubit({required this.walletLoadRepository})
    : super(CommonInitial());
  fetchWalletList() async {
    emit(CommonLoading());
    final _walletList = await ServiceHiveUtils.getWalletList(
      slug: "wallet_list",
    );
    if (_walletList.isNotEmpty) {
      emit(CommonDataFetchSuccess(data: _walletList));
    }

    try {
      final response = await walletLoadRepository.fetchWalletList();
      if (response.status == Status.Success && response.data != null) {
        emit(CommonDataFetchSuccess<WalletModel>(data: response.data!));
      } else {
        emit(
          CommonError(
            message: response.message ?? "Error fetching wallet list.",
          ),
        );
      }
    } catch (e) {
      emit(CommonError(message: e.toString()));
    }
  }

  // validateWallet({
  //   required String walletId,
  //   required String accountNumber,
  //   required String amount,
  // }) async {
  //   emit(CommonLoading());
  //   try {
  //     final response = await walletLoadRepository.validateWalletAccount(
  //       walletId: walletId,
  //       accountNumber: accountNumber,
  //       amount: amount,
  //     );

  //     if (response.status == Status.Success && response.data != null) {
  //       emit(CommonStateSuccess<WalletValidationModel>(data: response.data!));
  //     } else {
  //       emit(
  //         CommonError(
  //           message: response.message ?? "Error fetching wallet list.",
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     emit(CommonError(message: e.toString()));
  //   }
  // }
}
