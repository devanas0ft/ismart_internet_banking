import 'package:ismart_web/common/http/api_provider.dart';
import 'package:ismart_web/common/utils/url_utils.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';

class CategoryApiProvider {
  final ApiProvider apiProvider;
  final CoOperative coOperative;
  final String baseUrl;
  final UserRepository userRepository;

  CategoryApiProvider({
    required this.apiProvider,
    required this.coOperative,
    required this.baseUrl,
    required this.userRepository,
  });

  Future<dynamic> fetchServices() async {
    final _params = {"withService": "true"};
    final _uri = UrlUtils.getUri(
      url: coOperative.baseUrl + "/api/category",
      params: _params,
    );
    return await apiProvider.get(
      Uri.parse(_uri.toString()),
      userId: 0,
      token: userRepository.token,
    );
  }
}
