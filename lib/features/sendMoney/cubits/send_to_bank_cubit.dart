import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/features/sendMoney/models/bank.dart';
import 'package:ismart_web/features/sendMoney/resources/send_to_bank_repository.dart';

class SendToBankCubit extends Cubit<CommonState> {
  SendToBankRepository sendToBankRepository;

  SendToBankCubit({required this.sendToBankRepository})
    : super(CommonInitial());

  sendMoneyToBank({
    required String charge,
    required String amount,
    required String mpin,
    required String remarks,
    required String destinationBankInstrumentCode,
    required String destinationBankAccountName,
    required String destinationBankAccountNumber,
    required String destinationBankName,
    required String sendingAccount,
    required String otp,
  }) async {
    emit(CommonLoading());

    final res = await sendToBankRepository.sendMoneyToBank(
      otp: otp,
      amount: amount,
      mpin: mpin,
      remarks: remarks,
      destinationBankAccountName: destinationBankAccountName,
      destinationBankAccountNumber: destinationBankAccountNumber,
      destinationBankInstrumentCode: destinationBankInstrumentCode,
      serviceCharge: charge,
      destinationBankName: destinationBankName,
      sendingAccount: sendingAccount,
    );
    if (res.status == Status.Success && res.data != null) {
      emit(CommonStateSuccess(data: res.data!));
    } else {
      emit(CommonError(message: res.message ?? "Error fetching balance."));
    }
  }

  fetchBanksList() async {
    emit(CommonLoading());

    final res = await sendToBankRepository.getBanksList();
    if (res.status == Status.Success && res.data != null) {
      emit(CommonDataFetchSuccess<Bank>(data: res.data!));
    } else {
      emit(
        CommonError(message: res.message ?? "Error fetching wallet balance."),
      );
    }
  }
}
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ismart/common/common/data_state.dart';
// import 'package:ismart/common/http/response.dart';
// import 'package:ismart/feature/sendMoney/models/bank.dart';
// import 'package:ismart/feature/sendMoney/resources/send_to_bank_repository.dart';

// class SendToBankCubit extends Cubit<CommonState> {
//   SendToBankRepository sendToBankRepository;

//   SendToBankCubit({
//     required this.sendToBankRepository,
//   }) : super(CommonInitial());

//   sendMoneyToBank({
//     required String charge,
//     required String amount,
//     required String mpin,
//     required String remarks,
//     required String destinationBankInstrumentCode,
//     required String destinationBankAccountName,
//     required String destinationBankAccountNumber,
//     required String destinationBankName,
//     required String sendingAccount,
//   }) async {
//     emit(CommonLoading());

//     final res = await sendToBankRepository.sendMoneyToBank(
//       amount: amount,
//       mpin: mpin,
//       remarks: remarks,
//       destinationBankAccountName: destinationBankAccountName,
//       destinationBankAccountNumber: destinationBankAccountNumber,
//       destinationBankInstrumentCode: destinationBankInstrumentCode,
//       serviceCharge: charge,
//       destinationBankName: destinationBankName,
//       sendingAccount: sendingAccount,
//     );
//     if (res.status == Status.Success && res.data != null) {
//       emit(CommonStateSuccess(data: res.data!));
//     } else {
//       emit(CommonError(
//         message: res.message ?? "Error fetching wallet balance.",
//       ));
//     }
//   }

//   fetchBanksList() async {
//     emit(CommonLoading());

//     final res = await sendToBankRepository.getBanksList();
//     if (res.status == Status.Success && res.data != null) {
//       emit(CommonDataFetchSuccess<Bank>(data: res.data!));
//     } else {
//       emit(CommonError(
//         message: res.message ?? "Error fetching wallet balance.",
//       ));
//     }
//   }
// }
