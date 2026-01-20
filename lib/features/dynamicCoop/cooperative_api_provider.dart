// lib/features/cooperative/resource/cooperative_api_provider.dart

import 'package:ismart_web/common/http/api_provider.dart';

class CooperativeApiProvider {
  final String baseUrl;
  final ApiProvider apiProvider;

  CooperativeApiProvider({
    required this.baseUrl,
    required this.apiProvider,
  });

  Future<dynamic> fetchCooperativeConfig() async {
    final _uri = Uri.parse(baseUrl + "get/ibanking/config");
    return await apiProvider.get(
      _uri,
      userId: 0,
      token: '',
    );
  }
}