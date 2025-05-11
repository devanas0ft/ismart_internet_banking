import 'package:ismart_web/common/http/api_provider.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/utils/url_utils.dart';

class AuthApiProvider {
  final ApiProvider apiProvider;
  final CoOperative coOperative;
  final String baseUrl;

  const AuthApiProvider({
    required this.apiProvider,
    required this.baseUrl,
    required this.coOperative,
  });

  // Future<dynamic> fetchProfile({required String token}) async {
  //   return await apiProvider.get('$baseUrl/user/profile', token: token);
  // }

  Future<dynamic> sendNotificationToken({
    required String notificationToken,
    required String token,
  }) async {
    final param = {"token": notificationToken};
    return await apiProvider.post(
      '$baseUrl/auth/firebase',
      param,
      token: token,
    );
  }

  Future<dynamic> loginUser({
    required String username,
    required String password,
    required String deviceUUID,
    String? otpCode,
  }) async {
    final _body = {
      "client_id": coOperative.clientCode,
      "client_secret": coOperative.clientSecret,
      "password": password,
      "grant_type": "password",
      "username": coOperative.clientCode + username,
      "deviceUniqueIdentifier": "$deviceUUID",
    };
    if (otpCode != null) {
      _body['otp'] = otpCode;
    }

    final _uri = UrlUtils.getUri(
      url: coOperative.baseUrl + "oauth/token",
      params: _body,
    );
    return await apiProvider.post(_uri.toString(), {});
  }

  Future<dynamic> validateCoOperative({
    required String username,
    required String channelPartner,
  }) async {
    // final _body = {
    //   "mobileNumber": username,
    // };

    final _uri =
        coOperative.baseUrl +
        "ismart/getBanks?mobileNumber=$username&channelPartner=$channelPartner";
    return await apiProvider.post(
      _uri.toString(),
      {},
      header: {"token": "VCGFVBJHKUIY&*T^YBH NMKJLIYUHGVBH NMKJIGYUV B"},
    );
  }

  Future<dynamic> setUserToken({
    required String token,
    // required String deviceId,
    required String appVersion,
    required String userToken,
  }) async {
    final url = "$baseUrl/api/setdevicetoken/";

    final _body = {
      "fcmserver_identifier": "android",
      "device_token": token,
      "version": appVersion,
    };

    final _url = UrlUtils.getUri(url: url, params: _body);
    return await apiProvider.post(_url.toString(), {}, token: userToken);
  }
}
