import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/features/sendMoney/wallet_transfer/model/wallet_validation_model.dart';
import 'package:ismart_web/features/sendMoney/wallet_transfer/resoures/wallet_load_repository.dart';

class WalletValidationCubit extends Cubit<CommonState> {
  final WalletLoadRepository walletLoadRepository;

  WalletValidationCubit({required this.walletLoadRepository})
    : super(CommonInitial());

  validateWallet({
    required String walletId,
    required String accountNumber,
    required String amount,
  }) async {
    emit(CommonLoading());
    try {
      final response = await walletLoadRepository.validateWalletAccount(
        walletId: walletId,
        accountNumber: accountNumber,
        amount: amount,
      );

      if (response.status == Status.Success && response.data != null) {
        emit(CommonStateSuccess<WalletValidationModel>(data: response.data!));
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
}
