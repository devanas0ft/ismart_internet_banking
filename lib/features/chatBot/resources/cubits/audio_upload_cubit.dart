import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/features/chatBot/resources/audio_upload_repository.dart';

class AudioUploadCubit extends Cubit<CommonState> {
  AudioUploadCubit({required this.audioUploadRepository})
    : super(CommonInitial());
  final AudioUploadRepository audioUploadRepository;

  uploadAudio({required File audioFile, required String sessionId}) async {
    emit(CommonLoading());
    final baseUrl = audioUploadRepository.coOperative.baseUrl;
    final _res = await audioUploadRepository.uploadAudio(
      audio: audioFile,
      sessionId: sessionId,
    );

    if (_res.status == Status.Success && _res.data != null) {
      emit(
        CommonStateSuccess(data: {"response": _res.data, "baseUrl": baseUrl}),
      );
      // emit(CommonStateSuccess(data: _res.data));
    } else {
      emit(
        CommonError(
          message: _res.message ?? "Error Fetching data from the server",
        ),
      );
    }
  }
}
