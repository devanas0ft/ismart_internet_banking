import 'package:ismart_web/common/http/api_provider.dart';
import 'package:ismart_web/common/utils/url_utils.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';

class SendToBankAPIProvider {
  final ApiProvider apiProvider;
  final UserRepository userRepository;
  final String baseUrl;

  SendToBankAPIProvider({
    required this.apiProvider,
    required this.baseUrl,
    required this.userRepository,
  });

  getBanksList() async {
    final url = "$baseUrl/api/ips/bank/";

    return await apiProvider.get(
      Uri.parse(url),
      token: userRepository.token,
      userId: 0,
    );
  }

  getBankCharges({required String amount, required String bankId}) async {
    final url =
        "$baseUrl/api/ips/scheme/charge?amount=$amount&destinationBankId=$bankId";

    return await apiProvider.post(url, {}, token: userRepository.token);
  }

  getWalletBalance({required String payloadData}) async {
    final url = "$baseUrl/corewallet/api/v1/LoggedIn/";
    final payload = {"function_name": "GetBalance", "data": "$payloadData"};

    return await apiProvider.post(url, payload, token: userRepository.token);
  }

  loadFund({required String payloadData}) async {
    final url = "$baseUrl/corewallet/api/v1/LoggedIn/";
    final payload = {"function_name": "LoadFund", "data": "$payloadData"};

    return await apiProvider.post(url, payload, token: userRepository.token);
  }

  loadFundReceipt({required String payloadData}) async {
    final url = "$baseUrl/corewallet/api/v1/LoggedIn/";
    final payload = {
      "function_name": "LoadFundReceipt",
      "data": "$payloadData",
    };

    return await apiProvider.post(url, payload, token: userRepository.token);
  }

  accountValidation({required Map<String, dynamic> payloadData}) async {
    final url = "$baseUrl/api/account/validation/";

    Uri _uri = UrlUtils.getUri(url: url, params: payloadData);

    final _res = await apiProvider.get(
      _uri,
      token: userRepository.token,
      userId: -1,
    );
    return _res;
  }

  sendMoneyToBank({required Map<String, dynamic> payloadData}) async {
    final url = "$baseUrl/api/ips/transfer/";

    Uri _uri = UrlUtils.getUri(url: url, params: payloadData);

    return await apiProvider.post(
      _uri.toString(),
      {},
      token: userRepository.token,
    );
  }
}
