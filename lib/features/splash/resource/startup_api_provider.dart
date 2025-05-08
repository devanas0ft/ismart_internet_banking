import 'package:ismart_web/common/http/api_provider.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/utils/url_utils.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';

class StartUpApiProvider {
  StartUpApiProvider({
    required this.baseUrl,
    required this.apiProvider,
    required this.userRepository,
    required this.env,
  });

  final ApiProvider apiProvider;
  final UserRepository userRepository;
  final CoOperative env;
  final String baseUrl;

  fetchBannerImages() async {
    final url =
        "$baseUrl"
        "get/bannerimage/";
    return await apiProvider.get(
      UrlUtils.getUri(url: url),
      extraHeaders: {"client": env.clientCode, "type": "LoginScreenImage"},
      token: userRepository.token,
      userId: -1,
    );
  }

  fetchdefaultBannerImages() async {
    final url =
        "$baseUrl"
        "get/bannerimage/";
    return await apiProvider.get(
      UrlUtils.getUri(url: url),
      extraHeaders: {"client": "EHVNI7CZJ3", "type": "LoginScreenImage"},
      token: userRepository.token,
      userId: -1,
    );
  }

  fetchAppService() async {
    final url =
        "$baseUrl"
        "/appServiceManagement/appServices/bank/app/${env.clientCode}";
    return await apiProvider.get(
      UrlUtils.getUri(url: url),
      extraHeaders: {"client": "EHVNI7CZJ3", "type": "LoginScreenImage"},
      token: userRepository.token,
      userId: -1,
    );
  }

  fetchAppConfig() async {
    final url =
        "$baseUrl"
        "app-config/${env.clientCode}";
    return await apiProvider.get(
      UrlUtils.getUri(url: url),
      token: userRepository.token,
      userId: -1,
    );
  }
}
