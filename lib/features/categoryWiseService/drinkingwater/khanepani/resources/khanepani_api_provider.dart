import 'package:ismart_web/common/http/api_provider.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/utils/url_utils.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';

class KhanePaniApiProvider {
  final ApiProvider apiProvider;
  final CoOperative coOperative;

  final UserRepository userRepository;

  KhanePaniApiProvider({
    required this.apiProvider,
    required this.coOperative,
    required this.userRepository,
  });

  Future<dynamic> fetchKhanePaniCounter() async {
    final _uri = UrlUtils.getUri(
      url: coOperative.baseUrl + "/get/khanepanicounters",
    );
    return await apiProvider.get(Uri.parse(_uri.toString()), userId: 0);
  }
}
