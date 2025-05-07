import 'package:ismart_web/common/constants/env.dart';
import 'package:ismart_web/common/http/api_provider.dart';
import 'package:ismart_web/common/utils/url_utils.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';

class RecentTransactionApiProvider {
  final ApiProvider apiProvider;
  final CoOperative coOperative;
  final String baseUrl;
  final UserRepository userRepository;

  RecentTransactionApiProvider({
    required this.coOperative,
    required this.apiProvider,
    required this.userRepository,
    required this.baseUrl,
  });

  Future<dynamic> fetchRecentTransaction({
    required String serviceCategoryId,
    required String associatedId,
    required String serviceId,
    required String fromDate,
    required String toDate,
    required String service,
  }) async {
    final _params = {
      "serviceOf": service,
      if (serviceCategoryId.isNotEmpty) "serviceCategoryId": serviceCategoryId,
      if (associatedId.isNotEmpty) "associatedId": associatedId,
      if (serviceId.isNotEmpty) "serviceId": serviceId,
      "fromDate": fromDate,
      "toDate": toDate,
    };
    final _uri = UrlUtils.getUri(
      url: coOperative.baseUrl + "/api/recentTransaction",
      params: _params,
    );
    return await apiProvider.get(
      Uri.parse(_uri.toString()),
      userId: 0,
      token: userRepository.token,
    );
  }

  Future<dynamic> generateDownloadUrl({required String transactionId}) async {
    final _uri = UrlUtils.getUri(
      url: coOperative.baseUrl + "/api/gettransactionreceiptpdf",
      params: {"transactionId": transactionId},
    );
    return await apiProvider.get(_uri, userId: 0, token: userRepository.token);
  }
}
