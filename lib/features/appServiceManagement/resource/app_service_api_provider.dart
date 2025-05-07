import 'package:ismart_web/common/constants/env.dart';
import 'package:ismart_web/common/http/api_provider.dart';
import 'package:ismart_web/common/utils/url_utils.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';

class AppServiceApiProvider {
  final ApiProvider apiProvider;
  final CoOperative coOperative;
  final String baseUrl;

  final UserRepository userRepository;

  const AppServiceApiProvider({
    required this.apiProvider,
    required this.baseUrl,
    required this.coOperative,
    required this.userRepository,
  });

  Future<dynamic> fetchAppService() async {
    // final _url = baseUrl + "/api/customerdetails", params = _body;
    final _uri = UrlUtils.getUri(
      url:
          coOperative.baseUrl +
          "/appServiceManagement/appServices/bank/app/${coOperative.clientCode}",
    );

    return await apiProvider.get(
      Uri.parse(_uri.toString()),
      token: userRepository.token,
      userId: 0,
    );
  }
}
