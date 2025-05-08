import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/http/api_provider.dart';
import 'package:ismart_web/common/http/custom_exception.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/models/users.dart';
import 'package:ismart_web/common/shared_pref.dart';
import 'package:ismart_web/common/utils/snack_bar_utils.dart';
import 'package:ismart_web/features/auth/enum/login_response_value.dart';
import 'package:ismart_web/features/auth/model/coop_value.dart';
import 'package:ismart_web/features/auth/resources/auth_api_provider.dart';
import 'package:ismart_web/features/auth/ui/screens/login_page.dart';

class UserRepository {
  ApiProvider apiProvider;
  late AuthApiProvider authApiProvider;
  CoOperative env;

  String _token = '';
  final ValueNotifier<User?> _user = ValueNotifier(null);

  UserRepository({required this.env, required this.apiProvider}) {
    authApiProvider = AuthApiProvider(
      baseUrl: env.baseUrl,
      apiProvider: apiProvider,
      coOperative: env,
    );

    print(authApiProvider);
  }

  Future initialState() async {
    _token = await fetchToken();
    _isLoggedIn.value = _token.isNotEmpty;
    final LoginCoOpValue? _coopValue = await SharedPref.getLoginCoop();

    if (_coopValue != null) {
      updateCoopValue(_coopValue);
    }
  }

  updateCoopValue(LoginCoOpValue coop) {
    if (!RepositoryProvider.of<CoOperative>(
      NavigationService.context,
    ).shouldValidateCooperative) {
      return;
    }
    final String _baseUrl =
        RepositoryProvider.of<CoOperative>(NavigationService.context).baseUrl;

    RepositoryProvider.of<CoOperative>(NavigationService.context).bannerImage =
        _baseUrl + coop.banner.replaceFirst("/", "");
    RepositoryProvider.of<CoOperative>(NavigationService.context).clientCode =
        coop.clientId;
    RepositoryProvider.of<CoOperative>(NavigationService.context).clientSecret =
        coop.clientSecret;

    RepositoryProvider.of<CoOperative>(NavigationService.context)
        .coOperativeName = coop.bank;
    RepositoryProvider.of<CoOperative>(NavigationService.context)
        .coOperativeLogo = _baseUrl + coop.logo.replaceFirst("/", "");
  }

  Future<bool> logout({bool isSessionExpired = false}) async {
    try {
      _token = '';
      _isLoggedIn.value = false;
      _user.value = null;
      await SharedPref.deleteAccessToken();
      await SharedPref.deleteUser();
      if (isSessionExpired)
        SnackBarUtils.showErrorBar(
          context: NavigationService.context,
          message: "Session expired. Please re-login",
        );
      NavigationService.pushUntil(target: const LoginPage());
      return true;
    } on Exception catch (_) {
      print('custom exception is been obtained');
    }
    return false;
  }

  Future<bool> persistToken(String token) async {
    try {
      await SharedPref.setAccessToken(token);

      _isLoggedIn.value = true;
      return true;
    } on Exception catch (_) {
      print('custom exception is been obtained');
    }
    return false;
  }

  Future<String> fetchToken() async {
    try {
      final token = await SharedPref.getAccessToken();
      if (token.isNotEmpty) {
        _token = token;
      }

      print("Token------------------------------------------");
      print(token);
    } on Exception catch (_) {
      print('custom exception is been obtained');
    }
    return token;
  }

  ValueNotifier<User?> get user => _user;

  String get token => _token;

  final ValueNotifier<bool> _isLoggedIn = ValueNotifier(false);

  ValueNotifier<bool> get isLoggedIn => _isLoggedIn;

  Future<void> _getAndUpdateNotificationToken() async {
    // final String? firebabseToken = await FirebaseMessaging.instance.getToken();
    // if (firebabseToken != null) {
    //   updateNotificationToken(refreshedToken: firebabseToken);
    // }
  }

  // Future<DataResponse<bool>> updateNotificationToken(
  //     {required String notificationToken}) async {
  //   try {
  //     await authApiProvider.sendNotificationToken(
  //       notificationToken: notificationToken,
  //       token: _token,
  //     );
  //     return DataResponse.success(true);
  //   } on CustomException catch (e) {
  //     return DataResponse.error(
  //         e.message ?? "Unable to update notification token");
  //   } catch (e) {
  //     return DataResponse.error(e.toString());
  //   }
  // }

  // Future<DataResponse<User>> fetchProfile() async {
  //   try {
  //     final _res = await authApiProvider.fetchProfile(token: token);
  //     final _result = Map<String, dynamic>.from(_res);
  //     _user.value = User.fromJson(_result['data']);
  //     SharedPref.setUser(_user.value!);
  //     return DataResponse.success(_user.value!);
  //   } on CustomException catch (e) {
  //     return DataResponse.error(e.message!);
  //   } catch (e) {
  //     return DataResponse.error(e.toString());
  //   }
  // }

  Future<DataResponse<LoginResponseValue>> loginUser({
    required String username,
    required String password,
    required String deviceUUID,
    String? otpCode,
  }) async {
    try {
      final _res = await authApiProvider.loginUser(
        username: username,
        password: password,
        otpCode: otpCode,
        deviceUUID: deviceUUID,
      );

      final String _accessToken = _res['data']?['access_token'] ?? "";
      final String _refreshToken = _res['data']?['refresh_token'] ?? "";

      if (_accessToken.isNotEmpty && _refreshToken.isNotEmpty) {
        persistToken(_accessToken);
        _token = _accessToken;

        return DataResponse.success(LoginResponseValue.Success);
      } else {
        final String error = _res['data']['error'] ?? "";
        final String errorDescription = _res['data']['error_description'] ?? "";
        if (error.toLowerCase().contains("access_denied") &&
            errorDescription.toLowerCase().contains("otp")) {
          return DataResponse.success(LoginResponseValue.OTPVerification);
        }
        return DataResponse.error(errorDescription);
      }
    } on CustomException catch (e) {
      if (e is SessionExpireErrorException) {
        rethrow;
      }
      return DataResponse.error(e.message!, e.statusCode);
    } catch (e) {
      return DataResponse.error(e.toString());
    }
  }

  Future<DataResponse<bool>> updateNotificationToken({
    String? refreshedToken,
  }) async {
    // final String? _notificationToken =
    //     refreshedToken ?? await FirebaseMessaging.instance.getToken();

    try {
      // print(_notificationToken);
      // if (_notificationToken != null) {
      //   final _ = await authApiProvider.setUserToken(
      //     token: _notificationToken,
      //     userToken: _token,
      //     appVersion: await DeviceUtils.getAppVersion,
      //     // deviceId: '',
      //   );
      //   print(_);
      // }

      return DataResponse.success(true);
    } on CustomException catch (e) {
      if (e is SessionExpireErrorException) {
        rethrow;
      }
      return DataResponse.error(
        e.message ?? "Unable to update notification token",
        e.statusCode,
      );
    } catch (e) {
      return DataResponse.error(e.toString());
    }
  }

  Future<DataResponse<List<LoginCoOpValue>>> validateCoOperative({
    required String username,
    required String channelPartner,
  }) async {
    final List<LoginCoOpValue> _allCoops = [];
    try {
      final _res = await authApiProvider.validateCoOperative(
        username: username,
        channelPartner: channelPartner,
      );

      final List<Map<String, dynamic>> _coopList = List.from(
        _res['data']?['detail'] ?? [],
      );

      if (_coopList.isNotEmpty) {
        _coopList.forEach((e) {
          _allCoops.add(LoginCoOpValue.fromJson(e));
        });
        // print(_loginCoop.bank);
        // _updateCoopValue(_loginCoop);
        // SharedPref.setLoginCoop(_loginCoop);

        return DataResponse.success(_allCoops);
      } else {
        return DataResponse.error("Error retrieving data");
      }
    } on CustomException catch (e) {
      if (e is SessionExpireErrorException) {
        rethrow;
      }
      return DataResponse.error(e.message!, e.statusCode);
    } catch (e) {
      return DataResponse.error(e.toString());
    }
  }
}
