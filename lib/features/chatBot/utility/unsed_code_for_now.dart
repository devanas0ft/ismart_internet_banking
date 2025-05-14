// import 'dart:io';

// import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
// import 'package:path_provider/path_provider.dart';

// Future<String?> convertM4AToWAV(String inputPath) async {
//   try {
//     // Get the directory to save the converted file
//     final directory = await getApplicationDocumentsDirectory();
//     final outputPath = '${directory.path}/output.wav';

//     // final session = await FFmpegKit.execute(
//     //   '-i $inputPath -acodec pcm_s16le -ar 44100 -ac 2 $outputPath');

//     // FFmpeg command to convert m4a to wav
//     // String command = '-i "$inputPath" "$outputPath"';
//     String command =
//         '-i $inputPath -acodec pcm_s16le -ar 44100 -ac 2 $outputPath';

//     // Execute the command
//     await FFmpegKit.execute(command);

//     // Check if the output file is created
//     if (File(outputPath).existsSync()) {
//       return outputPath;
//     } else {
//       return null;
//     }
//   } catch (e) {
//     print("Error: $e");
//     return null;
//   }
// }

 // Future<File> loadAssetAsFile(String assetPath, String fileName) async {
  //   final byteData = await rootBundle.load(assetPath);
  //   final tempDir = await getTemporaryDirectory();
  //   final file = File('${tempDir.path}/$fileName');
  //   await file.writeAsBytes(byteData.buffer.asUint8List());
  //   return file;
  // }

//   Future<void> _startRecording() async {
//     try {
//       if (await Permission.microphone.isGranted) {
//         // Get documents directory
//         final Directory appDir = await getApplicationDocumentsDirectory();
//         final String appPath = path.join(appDir.path, 'iSmart Recordings');

//         // Create directory if it doesn't exist
//         await Directory(appPath).create(recursive: true);

//         // Generate unique filename with timestamp
//         final String fileName =
//             'recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
//         _recordedFilePath = path.join(appPath, fileName);

//         if (!await _recorder.isRecording()) {
//           await _recorder.start(
//             path: _recordedFilePath,
//             encoder: AudioEncoder.AAC,
//             bitRate: 128000,
//             samplingRate: 44100,
//           );
//           setState(() {
//             _isRecording = true;
//           });

//           // Debug print
//           print('Recording started. Saving to: $_recordedFilePath');
//         }
//       } else {
//         print('Microphone permission not granted');
//       }
//     } catch (e) {
//       print('Error starting recording: $e');
//     }
//   }

// // Modify _stopRecording to show save confirmation
//   Future<void> _stopRecording(String _sessionId) async {
//     try {
//       if (await _recorder.isRecording()) {
//         await _recorder.stop();
//         if (mounted) {
//           setState(() {
//             _isloadingVoice = true;
//             _isRecording = false;
//           });
//         }

//         // Verify file exists locally
//         final File audioFile = File(_recordedFilePath);
//         if (await audioFile.exists()) {
//           // Show confirmation to user
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text('Audio saved locally at:\n$_recordedFilePath'),
//             duration: const Duration(seconds: 3),
//           ));

//           // Upload the local file
//           context
//               .read<AudioUploadCubit>()
//               .uploadAudio(audioFile: audioFile, sessionId: _sessionId);
//         } else {
//           print('Error: Recorded file not found');
//         }
//       }
//     } catch (e) {
//       print("Error stopping the recording: $e");
//     }
//   }