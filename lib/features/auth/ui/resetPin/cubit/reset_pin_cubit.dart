import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/constants/locale_keys.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/features/auth/ui/resetPin/resources/reset_pin_repository.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class ResetPinCubit extends Cubit<CommonState> {
  ResetPinCubit({required this.resetPinRepository}) : super(CommonInitial());

  ResetPinRepository resetPinRepository;

  resetPin({
    required String serviceIdentifier,
    required Map<String, dynamic> accountDetails,
    required Map<String, dynamic> body,
    required String apiEndpoint,
    required mPin,
  }) async {
    emit(CommonLoading());

    final _res = await resetPinRepository.resetPin(
      mPin: mPin,
      serviceIdentifier: serviceIdentifier,
      accountDetails: accountDetails,
      apiEndpoint: apiEndpoint,
      body: body,
    );
    if (_res.status == Status.Success && _res.data != null) {
      emit(CommonStateSuccess<UtilityResponseData>(data: _res.data!));
    } else {
      emit(CommonError(message: _res.message ?? LocaleKeys.error.tr()));
    }
  }
  // makePayment({
  //   required String serviceIdentifier,
  //   required Map<String, dynamic> accountDetails,
  //   required Map<String, dynamic> body,
  //   required String apiEndpoint,
  //   required mPin,
  // }) async {
  //   emit(CommonLoading());

  //   final _res = await resetPinRepository.makePayment(
  //     mPin: mPin,
  //     serviceIdentifier: serviceIdentifier,
  //     accountDetails: accountDetails,
  //     apiEndpoint: apiEndpoint,
  //     body: body,
  //   );
  //   if (_res.status == Status.Success ||
  //       _res.message!.toLowerCase().contains("otp")) {
  //     emit(CommonStateSuccess(data: _res.data));
  //   } else {
  //     emit(
  //       CommonError(
  //         message: _res.message ?? "Error",
  //       ),
  //     );
  //   }
  // }
}
