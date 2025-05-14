import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/constants/locale_keys.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/features/categoryWiseService/movie/resource/model/movie_seat_model.dart';
import 'package:ismart_web/features/categoryWiseService/movie/resource/model/movie_seat_select_model.dart';
import 'package:ismart_web/features/categoryWiseService/movie/resource/movie_repository.dart';

class MovieCubit extends Cubit<CommonState> {
  MovieCubit({required this.movieRepository}) : super(CommonInitial());

  MovieRepository movieRepository;

  fetchMovieSeat({
    required String serviceIdentifier,
    required Map<String, dynamic> accountDetails,
    required String apiEndpoint,
    Map<String, dynamic>? extraHeaders,
  }) async {
    emit(CommonLoading());
    final _res = await movieRepository.fetchMovieSeats(
      extraHeaders: extraHeaders,
      serviceIdentifier: serviceIdentifier,
      accountDetails: accountDetails,
      apiEndpoint: apiEndpoint,
    );
    if (_res.status == Status.Success && _res.data != null) {
      emit(CommonStateSuccess<MovieSeatModel>(data: _res.data!));
    } else {
      emit(CommonError(message: _res.message ?? LocaleKeys.error.tr()));
    }
  }

  selectSeat({
    required String serviceIdentifier,
    required Map<String, dynamic> accountDetails,
    required Map<String, dynamic> body,
    required String apiEndpoint,
    required mPin,
  }) async {
    emit(CommonLoading());

    final _res = await movieRepository.selectSeats(
      mPin: mPin,
      serviceIdentifier: serviceIdentifier,
      accountDetails: accountDetails,
      apiEndpoint: apiEndpoint,
      body: body,
    );
    if (_res.status == Status.Success && _res.data != null) {
      emit(CommonStateSuccess<MovieSeatSelectModel>(data: _res.data!));
    } else {
      emit(CommonError(message: _res.message ?? LocaleKeys.error.tr()));
    }
  }

  unSelectSeat({
    required String serviceIdentifier,
    required Map<String, dynamic> accountDetails,
    required Map<String, dynamic> body,
    required String apiEndpoint,
    required mPin,
  }) async {
    emit(CommonLoading());

    final _res = await movieRepository.unSelectSeats(
      mPin: mPin,
      serviceIdentifier: serviceIdentifier,
      accountDetails: accountDetails,
      apiEndpoint: apiEndpoint,
      body: body,
    );
    if (_res.status == Status.Success && _res.data != null) {
      emit(CommonStateSuccess<MovieSeatUnSelectModel>(data: _res.data!));
    } else {
      emit(CommonError(message: _res.message ?? LocaleKeys.error.tr()));
    }
  }
}
