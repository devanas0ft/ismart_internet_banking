import 'package:ismart_web/common/constants/env.dart';
import 'package:ismart_web/common/http/api_provider.dart';
import 'package:ismart_web/common/utils/url_utils.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';

class CustomerAPIProvider {
  final ApiProvider apiProvider;
  final CoOperative coOperative;
  final String baseUrl;

  final UserRepository userRepository;

  const CustomerAPIProvider({
    required this.apiProvider,
    required this.baseUrl,
    required this.coOperative,
    required this.userRepository,
  });

  Future<dynamic> fetchCustomerDetail() async {
    final _body = {"additionalDetails": true, "getBalanceOfPrimaryOnly": false};
    // final _url = baseUrl + "/api/customerdetails", params = _body;
    final _uri = UrlUtils.getUri(
      url: coOperative.baseUrl + "/api/customerdetails",
      params: _body,
    );

    return await apiProvider.get(
      Uri.parse(_uri.toString()),
      token: userRepository.token,
      userId: 0,
    );
  }

  Future<dynamic> fetchCustomerBalance() async {
    final _url = baseUrl + "/api/getcustomerdetail";
    return await apiProvider.get(
      Uri.parse(_url),
      token: userRepository.token,
      userId: 0,
    );
  }
}
