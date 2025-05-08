import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/features/sendMoney/resources/send_to_bank_repository.dart';

class BankChargeCubit extends Cubit<CommonState> {
  SendToBankRepository sendToBankRepository;

  BankChargeCubit({required this.sendToBankRepository})
    : super(CommonInitial());

  getBankCharges({
    required String amount,
    required String bankId,
    required String destinationAccountNumber,
    required String destinationAccountName,
    required String destinationBankId,
  }) async {
    emit(CommonLoading());

    final res = await sendToBankRepository.getBankCharges(
      amount: amount,
      bankId: bankId,
      destinationBankAccountName: destinationAccountName,
      destinationBankAccountNumber: destinationAccountNumber,
      destinationBankInstrumentCode: destinationBankId,
    );
    if (res.status == Status.Success && res.data != null) {
      emit(CommonStateSuccess(data: res.data!));
    } else {
      emit(
        CommonError(message: res.message ?? "Error fetching wallet balance."),
      );
    }
  }
}
