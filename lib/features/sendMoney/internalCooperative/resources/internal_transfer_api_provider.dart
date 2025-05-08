import 'package:ismart_web/common/http/api_provider.dart';
import 'package:ismart_web/common/utils/url_utils.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';

class InternalTransferAPIProvider {
  final ApiProvider apiProvider;
  final UserRepository userRepository;
  final String baseUrl;

  InternalTransferAPIProvider({
    required this.apiProvider,
    required this.baseUrl,
    required this.userRepository,
  });

  getBranchList({required String cooperativeClientCode}) async {
    final url = "$baseUrl/get/bankbranches";
    final _header = {"client": cooperativeClientCode};

    return await apiProvider.get(
      Uri.parse(url),
      token: userRepository.token,
      userId: 0,
      extraHeaders: _header,
    );
  }

  internalFundTransfer({required Map<String, dynamic> payloadData}) async {
    final url = "$baseUrl/api/fundtransfer/";

    Uri _uri = UrlUtils.getUri(url: url, params: payloadData);

    return await apiProvider.post(
      _uri.toString(),
      payloadData,
      token: userRepository.token,
    );
  }
}
