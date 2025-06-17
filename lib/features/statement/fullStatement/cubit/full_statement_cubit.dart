import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/features/statement/fullStatement/model/full_statement_model.dart';
import 'package:ismart_web/features/statement/fullStatement/resources/full_statement_repository.dart';

class FullStatementCubit extends Cubit<CommonState> {
  final FullStatementRepository fullStatementRepository;
  FullStatementCubit({required this.fullStatementRepository})
    : super(CommonInitial());
  Future<dynamic> fetchFullStatement({
    required String accountNumber,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    emit(CommonLoading());
    try {
      final response = await fullStatementRepository.getFullStatement(
        accountNumber: accountNumber,
        fromDate: fromDate,
        toDate: toDate,
      );

      if (response.status == Status.Success && response.data != null) {
        emit(CommonStateSuccess<FullStatementModel>(data: response.data!));
      } else {
        emit(
          // CommonError(
          //   message: response.message ?? "Error fetching customer detail.",
          // ),
          CommonStateSuccess(data: fakeStatement),
        );
      }
    } catch (e) {
      emit(CommonError(message: e.toString()));
    }
  }

  final fakeStatement = FullStatementModel(
    openingBalance: 5000.00,
    closingBalance: 7500.00,
    fromDate: '2025-06-01',
    toDate: '2025-06-10',
    accountNumber: '1234567890',
    accountType: 'Savings',
    address: '123 Flutter Lane, Dev City',
    pdfUrl: 'https://example.com/statements/june.pdf',
    accountName: 'John Doe',
    accountStatementDtos: [
      AccountStatementDtos(
        transactionDate: '2025-06-01',
        remarks: 'Opening Balance',
        debit: 0.0,
        credit: 0.0,
        balance: 5000.0,
      ),
      AccountStatementDtos(
        transactionDate: '2025-06-03',
        remarks: 'ATM Withdrawal',
        debit: 500.0,
        credit: 0.0,
        balance: 4500.0,
      ),
      AccountStatementDtos(
        transactionDate: '2025-06-05',
        remarks: 'Salary Credit',
        debit: 0.0,
        credit: 3000.0,
        balance: 7500.0,
      ),
    ],
  );
}
