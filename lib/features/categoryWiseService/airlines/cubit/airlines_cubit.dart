import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/model/airlines_avliable_list_model.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/model/airlines_sector_model.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/resources/airlines_repository.dart';

class AirlinesCubit extends Cubit<CommonState> {
  final AirlinesRepository airlinesRepository;
  AirlinesCubit({required this.airlinesRepository}) : super(CommonInitial());
  Future<dynamic> fetchAirlinesLocation() async {
    emit(CommonLoading());
    try {
      final response = await airlinesRepository.getAirlinesLocation();

      if (response.status == Status.Success && response.data != null) {
        emit(
          CommonDataFetchSuccess<AirlinesSectorList>(data: response.data ?? []),
        );
      } else {
        emit(CommonError(message: response.message ?? "Error fetching Data"));
      }
    } catch (e) {
      emit(CommonError(message: e.toString()));
    }
  }

  fetchFlight({
    required Map<String, dynamic> accountDetails,
    required Map<String, dynamic> body,
  }) async {
    emit(CommonLoading());

    final _res = await airlinesRepository.fetchFlights(
      accountDetails: accountDetails,
      body: body,
    );
    if (_res.status == Status.Success && _res.data != null) {
      emit(CommonStateSuccess<SearchFlightResponse>(data: _res.data!));
    } else {
      print(_res);
      emit(CommonError(message: _res.message.toString()));
    }
  }
}
