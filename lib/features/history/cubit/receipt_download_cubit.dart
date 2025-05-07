import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/features/history/resources/recent_transaction_repository.dart';

class TransactionDownloadCubit extends Cubit<CommonState> {
  final RecentTransactionRepository recentTransactionRepository;
  TransactionDownloadCubit({required this.recentTransactionRepository})
    : super(CommonInitial());

  generateUrl({required String transactionId}) async {
    emit(CommonLoading());
    try {
      final response = await recentTransactionRepository.generateDownloadUrl(
        transactionId: transactionId,
      );

      if (response.status == Status.Success && response.data != null) {
        emit(CommonStateSuccess<String>(data: response.data!));
      } else {
        emit(
          CommonError(
            message: response.message ?? "Error fetching customer detail.",
          ),
        );
      }
    } catch (e) {
      emit(CommonError(message: e.toString()));
    }
  }
}
