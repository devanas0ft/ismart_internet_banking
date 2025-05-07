import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/common/utils/hive_utils.dart';
import 'package:ismart_web/features/Dahboard/widgets/homePageTabbar/resources/category_repository.dart';

class CategoryCubit extends Cubit<CommonState> {
  final CategoryRepository servicesRepository;
  CategoryCubit({required this.servicesRepository}) : super(CommonInitial());
  Future<dynamic> fetchCategory() async {
    // emit(CommonLoading());
    emit(CommonDummyLoading());
    final _utilities = await ServiceHiveUtils.getUtilitiesServices(
      slug: "wallet_service",
    );

    if (_utilities.isNotEmpty) {
      emit(CommonDataFetchSuccess(data: _utilities));
    }
    try {
      final response = await servicesRepository.getCategoryList();
      emit(CommonDummyLoading());
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
