import 'dart:io';
import 'package:ismart_web/common/http/api_provider.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';

class AudioUploadApiProvider {
  final ApiProvider apiProvider;
  final String baseUrl;
  final UserRepository userRepository;

  const AudioUploadApiProvider({
    required this.apiProvider,
    required this.baseUrl,
    required this.userRepository,
  });

  uploadAudio({required File auidoFile, required String sessionId}) async {
    final _url = baseUrl + "api/ai/message/audio/$sessionId";
    return await apiProvider.upload(
      isAudio: true,
      _url,
      auidoFile,
      userId: 0,
      token: userRepository.token,
    );
  }
}
