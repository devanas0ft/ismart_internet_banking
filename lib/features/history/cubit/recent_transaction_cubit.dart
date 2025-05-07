import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/features/history/models/recent_transaction_model.dart';
import 'package:ismart_web/features/history/resources/recent_transaction_repository.dart';

class RecentTransactionCubit extends Cubit<CommonState> {
  final RecentTransactionRepository recentTransactionRepository;
  RecentTransactionCubit({required this.recentTransactionRepository})
    : super(CommonInitial());
  Future<dynamic> fetchrecentTransaction({
    String? service,
    required String serviceCategoryId,
    required String serviceId,
    String? fromDate,
    String? toDate,
    required String associatedId,
  }) async {
    emit(CommonLoading());
    try {
      // final String mPin = await SecureStorageService.appPassword;
      final response = await recentTransactionRepository.getRecentTransaction(
        fromDate: fromDate ?? "",
        toDate: toDate ?? "",
        serviceId: serviceId,
        service: service ?? "SERVICE",
        serviceCategoryId: serviceCategoryId,
        associatedId: associatedId,
      );

      if (response.status == Status.Success) {
        emit(
          CommonDataFetchSuccess<RecentTransactionModel>(data: response.data!),
        );
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
