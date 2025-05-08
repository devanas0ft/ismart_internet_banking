import 'package:ismart_web/common/http/api_provider.dart';
import 'package:ismart_web/common/http/custom_exception.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';
import 'package:ismart_web/features/auth/ui/actiateAccount/resources/reset_otp_register_api_provider.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class ResetOtpRegisterRepository {
  ApiProvider apiProvider;
  late ResetOtpRegisterApiProvider resetPinApiProvider;
  UserRepository userRepository;
  CoOperative env;

  ResetOtpRegisterRepository({
    required this.env,
    required this.userRepository,
    required this.apiProvider,
  }) {
    resetPinApiProvider = ResetOtpRegisterApiProvider(
      baseUrl: env.baseUrl,
      apiProvider: apiProvider,
      userRepository: userRepository,
    );
  }

  Future<DataResponse<UtilityResponseData>> resetOtp({
    required String serviceIdentifier,
    required Map<String, dynamic> accountDetails,
    required Map<String, dynamic> body,
    required String apiEndpoint,
    required mPin,
  }) async {
    try {
      final _res = await resetPinApiProvider.resetOtp(
        mPin: mPin,
        accountDetails: accountDetails,
        apiEndpoint: apiEndpoint,
        body: body,
      );

      final UtilityResponseData _responseData = UtilityResponseData.fromJson(
        _res['data'] ?? {},
      );
      print(_responseData);

      return DataResponse.success(_responseData);
    } on CustomException catch (e) {
      if (e is SessionExpireErrorException) {
        rethrow;
      }
      return DataResponse.error(e.message, e.statusCode);
    } catch (e) {
      return DataResponse.error(e.toString());
    }
  }
}
