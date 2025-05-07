import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/features/wallet_transfer/model/wallet_transfer_model.dart';
import 'package:ismart_web/features/wallet_transfer/resoures/wallet_load_repository.dart';

class WalletSendCubit extends Cubit<CommonState> {
  final WalletLoadRepository walletLoadRepository;
  WalletSendCubit({required this.walletLoadRepository})
    : super(CommonInitial());

  sendToWallet({
    required String walletId,
    required String amount,
    required String customerName,
    required String walletAccountNumber,
    required String validationIdentifier,
    required String remarks,
    required String mPin,
  }) async {
    emit(CommonLoading());
    try {
      final response = await walletLoadRepository.sendToWallet(
        mPin: mPin,
        remarks: remarks,
        walletId: walletId,
        amount: amount,
        validationIdentifier: validationIdentifier,
        customerName: customerName,
        walletAccountNumber: walletAccountNumber,
      );

      if (response.status == Status.Success && response.data != null) {
        emit(CommonStateSuccess<WalletTransferModel>(data: response.data!));
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
