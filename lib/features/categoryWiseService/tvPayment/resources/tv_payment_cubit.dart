import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/constants/locale_keys.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/features/categoryWiseService/tvPayment/resources/tv_detail_model.dart';

import 'tv_payment_repository.dart';

class TvPaymentCubit extends Cubit<CommonState> {
  TvPaymentCubit({required this.tvPaymentRepository}) : super(CommonInitial());

  TvPaymentRepository tvPaymentRepository;

  fetchDetails({
    required String serviceIdentifier,
    required Map<String, dynamic> accountDetails,
    required String apiEndpoint,
  }) async {
    emit(CommonLoading());

    final _res = await tvPaymentRepository.fetchDetails(
      serviceIdentifier: serviceIdentifier,
      accountDetails: accountDetails,
      apiEndpoint: apiEndpoint,
    );
    if (_res.status == Status.Success && _res.data != null) {
      emit(CommonStateSuccess<TvDetailModel>(data: _res.data!));
    } else {
      emit(CommonError(message: _res.message ?? LocaleKeys.error.tr()));
    }
  }
}
