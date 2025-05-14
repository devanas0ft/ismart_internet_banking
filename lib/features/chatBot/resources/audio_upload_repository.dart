import 'dart:io';
import 'package:ismart_web/common/http/api_provider.dart';
import 'package:ismart_web/common/http/custom_exception.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';
import 'package:ismart_web/features/chatBot/resources/audio_upload_api_provider.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class AudioUploadRepository {
  ApiProvider apiProvider;
  CoOperative coOperative;
  late AudioUploadApiProvider audioUploadApiProvider;
  UserRepository userRepository;

  AudioUploadRepository({
    required this.apiProvider,
    required this.coOperative,
    required this.userRepository,
  }) {
    audioUploadApiProvider = AudioUploadApiProvider(
      apiProvider: apiProvider,
      baseUrl: coOperative.baseUrl,
      userRepository: userRepository,
    );
  }

  Future<DataResponse<UtilityResponseData>> uploadAudio({
    required File audio,
    required String sessionId,
  }) async {
    try {
      final _res = await audioUploadApiProvider.uploadAudio(
        auidoFile: audio,
        sessionId: sessionId,
      );
      // Map<String, dynamic> _jsonResponse = Map.from(_res['data'] ?? {});

      // if (_jsonResponse.isNotEmpty) {
      //   if (_jsonResponse['code'] == 'M0000') {
      //     return DataResponse.success(true);
      //   }
      // }
      // return DataResponse.success(false);
      if (_res != null && _res.containsKey('data')) {
        final responseData = UtilityResponseData.fromJson(_res['data']);
        return DataResponse.success(responseData);
      }
      return DataResponse.error("Invalid response format");
    } on CustomException catch (e) {
      return DataResponse.error(e.message.toString());
    } catch (e) {
      return DataResponse.error(e.toString());
    }
  }
}
