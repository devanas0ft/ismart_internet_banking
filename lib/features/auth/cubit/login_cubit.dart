import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/common/models/users.dart';

import 'package:bloc/bloc.dart';

class LoginCubit extends Cubit<CommonState> {
  LoginCubit({required this.userRepository}) : super(CommonInitial());

  UserRepository userRepository;

  Future<bool> hasInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  loginUser({
    required String username,
    required String password,
    required String clientAlias,
    required String actualBaseUrl,
  }) async {
    bool isConnected = await hasInternetConnection();
    emit(CommonLoading());
    final res = await userRepository.loginUser(
      username: username,
      password: password,
      clientAlias: clientAlias,
      actualBaseUrl: actualBaseUrl,
    );
    if (res.status == Status.Success && res.data != null) {
      emit(CommonStateSuccess<User>(data: res.data!));
    } else if (!isConnected) {
      emit(const CommonNoData());
    } else {
      emit(
        CommonError(
          message: res.toString() ?? "Error logging in.",
          statusCode: res.statusCode,
        ),
      );
    }
  }
}
