import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/models/internal_branch.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/resources/internal_transfer_repository.dart';

class InternalTransferCubit extends Cubit<CommonState> {
  InternalTransferRepository internalTransferRepository;

  InternalTransferCubit({required this.internalTransferRepository})
    : super(CommonInitial());

  fundTranfer({
    required String amount,
    required String mpin,
    required String remarks,
    required String receivingAccount,
    required String receivingBranchId,
    required String sendingAccount,
  }) async {
    emit(CommonLoading());

    final res = await internalTransferRepository.fundTranfer(
      amount: amount,
      mpin: mpin,
      remarks: remarks,
      receivingAccount: receivingAccount,
      receivingBranchId: receivingBranchId,
      sendingAccount: sendingAccount,
    );
    if (res.status == Status.Success && res.data != null) {
      emit(CommonStateSuccess(data: res.data!));
    } else {
      emit(
        CommonError(message: res.message ?? "Error fetching wallet balance."),
      );
    }
  }

  fetchBanksList() async {
    emit(CommonLoading());

    final res = await internalTransferRepository.getBranchList();
    if (res.status == Status.Success && res.data != null) {
      emit(CommonDataFetchSuccess<InternalBranch>(data: res.data!));
    } else {
      emit(
        CommonError(message: res.message ?? "Error fetching wallet balance."),
      );
    }
  }
}
