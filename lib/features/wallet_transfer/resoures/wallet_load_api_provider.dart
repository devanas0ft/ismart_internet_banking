import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/http/api_provider.dart';
import 'package:ismart_web/common/utils/url_utils.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';

class WalletLoadAPIProvider {
  final ApiProvider apiProvider;
  final CoOperative coOperative;
  final String baseUrl;

  final UserRepository userRepository;

  const WalletLoadAPIProvider({
    required this.apiProvider,
    required this.baseUrl,
    required this.coOperative,
    required this.userRepository,
  });

  Future<dynamic> fetchWalletList() async {
    final _uri = UrlUtils.getUri(url: coOperative.baseUrl + "/api/wallet/list");

    return await apiProvider.get(_uri, token: userRepository.token, userId: 0);
  }

  Future<dynamic> validateWallet({
    required String walletId,
    required String amount,
    required String accountNumber,
  }) async {
    final _params = {
      "walletUsername": accountNumber,
      "walletId": walletId,
      "amount": amount,
    };
    final _uri = UrlUtils.getUri(
      url: coOperative.baseUrl + "/api/walletvalidate",
      params: _params,
    );

    return await apiProvider.get(_uri, token: userRepository.token, userId: 0);
  }

  Future<dynamic> sendToWallet({
    required String walletId,
    required String amount,
    required String accountNumber,
    required String customerName,
    required String walletAccountNumber,
    required String validationIdentifier,
    required String remarks,
    required String mPin,
  }) async {
    final _body = {
      "desc_one": customerName,
      "desc_two": walletAccountNumber,
      "wallet_id": walletId,
      "account_number": accountNumber,
      "amount": amount,
      "validationIdentifier": validationIdentifier,
      "skipValidation": true,
      "mPin": mPin,
      "remarks": remarks,
    };

    final _url = coOperative.baseUrl + "/api/wallet/load";
    final _uri = UrlUtils.getUri(url: _url, params: _body);

    return await apiProvider.post(
      _uri.toString(),
      {},
      token: userRepository.token,
    );
  }
}
