import 'package:ismart_web/common/http/api_provider.dart';
import 'package:ismart_web/common/utils/url_utils.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';

class TvPaymentAPIProvider {
  TvPaymentAPIProvider({
    required this.baseUrl,
    required this.apiProvider,
    required this.userRepository,
  });

  final ApiProvider apiProvider;
  final UserRepository userRepository;
  final String baseUrl;

  getTopup({
    required String serviceIdentifier,
    required String accountNumber,
    required String phoneNumber,
    required String amount,
    required String mpin,
  }) async {
    final _params = {
      "service_identifier": "$serviceIdentifier",
      "account_number": "$accountNumber",
      "phone_number": "$phoneNumber",
      "amount": "$amount",
      "mPin": "$mpin",
    };
    final url = UrlUtils.getUri(url: baseUrl + "/api/topup", params: _params);
    return await apiProvider.post(
      url.toString(),
      {},
      token: userRepository.token,
    );
  }

  makePayment({
    required String serviceIdentifier,
    required Map<String, dynamic> accountDetails,
    required Map<String, dynamic> body,
    required String apiEndpoint,
    required mPin,
  }) async {
    final _params = {...accountDetails};
    if (serviceIdentifier.isNotEmpty) {
      _params["service_identifier"] = "$serviceIdentifier";
    }
    if (mPin.isNotEmpty) {
      _params["mPin"] = "$mPin";
    }

    final url = UrlUtils.getUri(url: baseUrl + "$apiEndpoint", params: _params);

    if (serviceIdentifier == "ARS") {
      body['mobilePin'] = mPin;
    }

    return await apiProvider.post(
      url.toString(),
      body,
      token: userRepository.token,
    );
  }

  fetchDetails({
    required String serviceIdentifier,
    required Map<String, dynamic> accountDetails,
    required String apiEndpoint,
  }) async {
    final _params = {...accountDetails};
    if (serviceIdentifier.isNotEmpty) {
      _params["service_identifier"] = "$serviceIdentifier";
    }

    final url = UrlUtils.getUri(url: baseUrl + "$apiEndpoint", params: _params);

    return await apiProvider.get(url, token: userRepository.token, userId: 0);
  }
}
