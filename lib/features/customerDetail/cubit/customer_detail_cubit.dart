import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';

class CustomerDetailCubit extends Cubit<CommonState> {
  final CustomerDetailRepository customerDetailRepository;
  CustomerDetailCubit({required this.customerDetailRepository})
    : super(CommonInitial());
  Future<dynamic> fetchCustomerDetail({bool isCalledAtStatup = false}) async {
    emit(CommonLoading());
    try {
      final response = await customerDetailRepository.getCustomerDetail(
        isCalledAtStartup: isCalledAtStatup,
      );

      if (response.status == Status.Success && response.data != null) {
        emit(CommonStateSuccess(data: response.data!));
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
