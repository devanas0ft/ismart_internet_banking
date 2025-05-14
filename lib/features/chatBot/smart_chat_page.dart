import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_sound_record/flutter_sound_record.dart';

// import 'package:ismart/feature/dashboard/homePage/homePageTabbar/servicesTab/resources/category_repository.dart';

import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/shared_pref.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/cubit/category_cubit.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/chatBot/SmartBot_topUp_service.dart';
import 'package:ismart_web/features/chatBot/exclusive_pages/chat_prompts.dart';
import 'package:ismart_web/features/chatBot/resources/cubits/audio_upload_cubit.dart';
import 'package:ismart_web/features/chatBot/typing_animation.dart';
import 'package:ismart_web/features/chatBot/utility/smartchat_busticket_cubit.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

import 'package:permission_handler/permission_handler.dart';

class SmartChatPage extends StatefulWidget {
  final String? receiverEmail;
  final int id;
  // final GlobalKey<_SmartChatPageState> widgetKey = GlobalKey();

  const SmartChatPage({Key? key, this.receiverEmail = "iSmart", this.id = 1})
    : super(key: key);

  @override
  State<SmartChatPage> createState() => _SmartChatPageState();
}

class _SmartChatPageState extends State<SmartChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  late final CategoryService _categoryService;
  StreamSubscription? _playerStateSubscription;

  String destinationFrom = '';
  String destinationTo = '';
  String destinationDate = '';

  //for sound record
  // final FlutterSoundRecord _recorder = FlutterSoundRecord();
  final String _recordedFilePath = '';
  // final AudioPlayer _audioPlayer = AudioPlayer();
  final bool _isRecording = false;
  bool _isAudioPlaying = false;

  final List<Map<String, dynamic>> _chatHistory = [];
  bool _isLoading = false;
  bool _isloadingVoice = false;

  @override
  void initState() {
    super.initState();
    _categoryService = CategoryService();
    _focusNode.addListener(_onFocusChange);
    _initializeCategoryService();
    _addInitialPrompt();
    _requestPermissions();
    _initAudioSession();
  }

  Future<void> _initAudioSession() async {
    // final session = await AudioSession.instance;
    // await session.configure(const AudioSessionConfiguration.speech());
  }

  Future<void> _requestPermissions() async {
    final isVoiceActive = await SharedPref.getVoiceChatVisibility();
    if (isVoiceActive) {
      await Permission.microphone.request();
    }
  }

  // Future<void> _startRecording() async {
  //   try {
  //     if (await Permission.microphone.isGranted) {
  //       final Directory tempDir = await getTemporaryDirectory();
  //       _recordedFilePath = '${tempDir.path}/temp_recording.m4a';

  //       if (!await _recorder.isRecording()) {
  //         await _recorder.start(
  //           path: _recordedFilePath,
  //           encoder: AudioEncoder.AAC,
  //           bitRate: 128000,
  //           samplingRate: 44100,
  //         );
  //         setState(() {
  //           _isRecording = true;
  //         });
  //       } else {
  //         print('MicroPhone permission not granted');
  //       }
  //     }
  //   } catch (e) {
  //     print('Error starting recording: $e');
  //   }
  // }

  // Future<void> _stopRecording(String _sessionId) async {
  //   try {
  //     if (await _recorder.isRecording()) {
  //       await _recorder.stop();
  //       if (mounted) {
  //         setState(() {
  //           _isloadingVoice = true;
  //           _isRecording = false;
  //         });
  //       }
  //       final File audioFile = File(_recordedFilePath);
  //       // final File audioStatic =
  //       //     await loadAssetAsFile('assets/test2.wav', 'test2.wav');
  //       if (_recordedFilePath.isNotEmpty && mounted) {
  //         context
  //             .read<AudioUploadCubit>()
  //             .uploadAudio(audioFile: audioFile, sessionId: _sessionId);
  //       }
  //     }
  //   } catch (e) {
  //     print("Eroor stopping the recording : $e");
  //   }
  // }

  Future<void> _playAudioResponse(String audioUrl) async {
    // try {
    //   await _audioPlayer.stop();
    //   await _audioPlayer.setUrl(audioUrl);
    //   await _audioPlayer.play();
    // } catch (e) {
    //   print('Error playing audio: $e');
    // }
  }

  void _showAudioDialog(String audioUrl) {
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (context) {
    //     _playAudioResponse(audioUrl);
    //     _playerStateSubscription?.cancel();
    //     _playerStateSubscription =
    //         _audioPlayer.playerStateStream.listen((playerState) {
    //       if (playerState.processingState == ProcessingState.completed) {
    //         if (Navigator.of(context).canPop()) {
    //           setState(() {
    //             _isAudioPlaying = false;
    //           });
    //           NavigationService.pop();
    //         }
    //       }
    //     });
    //     // _audioPlayer.playerStateStream.listen((playerState) {

    //     // });

    //     return AlertDialog(
    //       title: const Center(
    //           child: Text(
    //         'Response',
    //         style: TextStyle(
    //           fontSize: 20,
    //           color: CustomTheme.darkGray,
    //         ),
    //       )),
    //       content: SizedBox(
    //         height: 150,
    //         child: Center(
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               TypingIndicator(
    //                 dotColor: CustomTheme.primaryColor,
    //                 dotSize: 35,
    //                 dotSpacing: 12,
    //                 duration: const Duration(milliseconds: 700),
    //               ),
    //               const SizedBox(height: 15),
    //               TextButton(
    //                 onPressed: () {
    //                   _audioPlayer.stop();
    //                   setState(() {
    //                     _isAudioPlaying = false;
    //                   });
    //                   NavigationService.pop();
    //                 },
    //                 child: const Text(
    //                   'Stop',
    //                   style: TextStyle(
    //                       fontSize: 20,
    //                       color: CustomTheme.darkGray,
    //                       fontWeight: FontWeight.bold),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // ).then((_) {
    //   _playerStateSubscription?.cancel();
    // });
  }

  Future<void> _initializeCategoryService() async {
    await _categoryService.initialize(context);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 300), _scrollToBottom);
    }
  }

  void _scrollToBottom({
    Duration duration = const Duration(milliseconds: 300),
  }) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: duration,
        curve: Curves.easeOutQuart,
      );
    }
  }

  void _addInitialPrompt() {
    setState(() {
      _chatHistory.add({
        'type': 'assistant',
        'message': ChatPrompts.getCurrentQuestion('start'),
        'timestamp': DateTime.now(),
        'options': ['What is iSmart'],
      });
    });
  }

  Widget _buildMessageItem(Map<String, dynamic> message, BuildContext context) {
    final bool isUser = message['type'] == 'user';

    return Column(
      crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child:
              (message['message'] != '' && message['message'] != null)
                  ? Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isUser
                              ? CustomTheme.primaryColor
                              : const Color.fromRGBO(255, 255, 255, 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message['message'],
                      style: TextStyle(
                        color:
                            !isUser
                                ? CustomTheme.primaryColor
                                : const Color.fromRGBO(255, 255, 255, 1),
                        fontSize: 14,
                      ),
                    ),
                  )
                  : Container(),
        ),
        if (!isUser && message['options'] != null)
          Wrap(
            spacing: 2.0,
            runSpacing: 2.0,
            children:
                (message['options'] as List<String>).map((option) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: GestureDetector(
                      onTap: () => _handleMessage(context, option),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 12.0,
                        ),
                        decoration: BoxDecoration(
                          color: CustomTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          option,
                          style: TextStyle(
                            color: CustomTheme.primaryColor,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
      ],
    );
  }

  void _handleMessage(BuildContext context, String message) {
    if (message.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
      message = _capitalizeFirstWord(message);
      _chatHistory.add({
        'type': 'user',
        'message': message,
        'timestamp': DateTime.now(),
      });
      _messageController.clear();
    });

    _scrollToBottom();

    context.read<UtilityPaymentCubit>().makePayment(
      mPin: '',
      accountDetails: {},
      serviceIdentifier: '',
      body: {'message': message},
      apiEndpoint: 'api/ai/message/${widget.id}',
    );
  }

  void _busBooking(String from, String to) {
    context.read<SmartChatBusTicketCubit>().sendBusRequest(from: from, to: to);
  }

  String _capitalizeFirstWord(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  Widget _buildMessageList(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
      itemCount: _chatHistory.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _chatHistory.length && _isLoading) {
          return _buildTypingIndicator();
        }
        return _buildMessageItem(_chatHistory[index], context);
      },
    );
  }

  Widget _buildTypingIndicator({bool isRed = false}) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isRed ? Colors.red : CustomTheme.primaryColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const TypingIndicator(),
      ),
    );
  }

  Widget _buildUserInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child:
                (_isRecording || _isloadingVoice)
                    ? Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10.0, 5, 5, 5),
                              child: Text(
                                _isloadingVoice ? "Processing" : "Listening",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red.shade400,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            TypingIndicator(dotColor: Colors.red.shade400),
                          ],
                        ),
                      ),
                    )
                    : CustomTextField(
                      controller: _messageController,
                      //   focusNode: _focusNode,
                      hintText: 'Type a message...',
                      onSubmited: (value) => _handleMessage(context, value),
                    ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  // FutureBuilder(
                  //     future: SharedPref.getVoiceChatVisibility(),
                  //     builder: (context, snapshot) {
                  //       final isVoiceChatVisible = snapshot.data ?? false;
                  //       return isVoiceChatVisible
                  //           ? GestureDetector(
                  //               onLongPressStart: (_) => _startRecording(),
                  //               onLongPressEnd: (_) =>
                  //                   _stopRecording(widget.id.toString()),
                  //               child: IconButton(
                  //                 icon: Icon(
                  //                   Icons.mic,
                  //                   color: _isRecording
                  //                       ? Colors.grey
                  //                       : CustomTheme.primaryColor,
                  //                   size: 30,
                  //                 ),
                  //                 onPressed: () {},
                  //               ),
                  //             )
                  //           : const SizedBox.shrink();
                  //     }),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: CustomTheme.primaryColor,
                      size: 30,
                    ),
                    onPressed:
                        () => _handleMessage(context, _messageController.text),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updateChatWithResponse(String message) {
    setState(() {
      _isLoading = false;
      _chatHistory.add({
        'type': 'assistant',
        'message': message,
        'timestamp': DateTime.now(),
      });
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      // key: widget.widgetKey,
      builder:
          (context) => MultiBlocListener(
            listeners: [
              BlocListener<AudioUploadCubit, CommonState>(
                listener: (context, state) {
                  print("Current state SKP: ${state.runtimeType}");
                  if (state is CommonLoading) {
                    if (mounted) {
                      setState(() {
                        _isloadingVoice = true;
                      });
                    }
                  }
                  if (state is CommonStateSuccess) {
                    if (mounted) {
                      setState(() {
                        _isloadingVoice = false;
                      });
                    }
                    try {
                      print("State data: ${state.data}");
                      final responseData = state.data;
                      final String baseUrl = responseData["baseUrl"];
                      final UtilityResponseData _res = responseData["response"];
                      final String audioUrl = _res.detail['audioURL'];
                      final String initialUrl = baseUrl + audioUrl;
                      final String completeUrl = initialUrl
                          .replaceAll("//", "/")
                          .replaceFirst(":/", "://");
                      print("complete URL : $completeUrl");
                      if (completeUrl.isNotEmpty ||
                          _res.detail['serviceIdentifier'] != null) {
                        setState(() {
                          _isAudioPlaying = true;
                        });
                        if (_res.detail['serviceIdentifier'] != null) {
                          actionButton(_res);
                        } else {
                          _showAudioDialog(completeUrl);
                        }
                      } else {
                        print('Error in audio path');
                      }
                    } catch (e) {
                      print('Error processing audio response: $e');
                    }
                  }
                  if (state is CommonError) {
                    if (mounted) {
                      setState(() {
                        _isloadingVoice = false;
                        _chatHistory.add({
                          'type': 'assistant',
                          'message': "Error in audio response!",
                          'timestamp': DateTime.now(),
                        });
                        _messageController.clear();
                      });
                    }
                  }
                },
              ),
              BlocListener<CategoryCubit, CommonState>(
                listener: (context, state) {
                  if (state is CommonDataFetchSuccess<CategoryList>) {
                    _categoryService.updateCategoryList(state.data);
                  }
                },
              ),
              BlocListener<SmartChatBusTicketCubit, CommonState>(
                listener: (context, state) {
                  if (state is CommonStateSuccess) {
                    final responseData = state.data;
                    final String destinationFrom = responseData["from"];
                    final String destinationTo = responseData["to"];
                    context.read<UtilityPaymentCubit>().fetchDetails(
                      serviceIdentifier: "",
                      accountDetails: {
                        "fromSector": destinationFrom.toUpperCase(),
                        "toSector": destinationTo.toUpperCase(),
                        "departureDate": destinationDate,
                        "shift": 'Both',
                      },
                      apiEndpoint: "/api/busSewa/getTrips",
                    );
                  }
                },
              ),
              BlocListener<UtilityPaymentCubit, CommonState>(
                listener: (context, state) {
                  if (state is CommonStateSuccess<UtilityResponseData>) {
                    final UtilityResponseData response = state.data;
                    if (response.details.isNotEmpty) {
                      for (var keyValue in response.details) {
                        if (keyValue.title == "data" &&
                            keyValue.value is List) {
                          final List dataList = keyValue.value as List;
                          for (var item in dataList) {
                            if (item is Map<String, dynamic> &&
                                item.containsKey('ticketPrice')) {
                              _categoryService.navigateToBusBooking2(
                                context,
                                response,
                                destinationFrom,
                                destinationTo,
                                destinationDate,
                              );
                              break;
                            }
                          }
                        }
                      }
                      print("hey handsome hey handosme");
                    }
                    if (response.detail["serviceIdentifier"] != null) {
                      print("there is payement request");
                      actionButton(response);
                    }
                    updateChatWithResponse(response.detail['message']);
                  } else if (state is CommonError) {
                    setState(() {
                      _chatHistory.add({
                        'type': 'assistant',
                        'message': "Something went wrong",
                        'timestamp': DateTime.now(),
                        'options': ['Start again'],
                      });
                    });
                    Future.delayed(Duration(seconds: 4), () {
                      NavigationService.pop();
                    });
                  }
                },
              ),
            ],
            child: PageWrapper(
              showBackButton: true,
              body: Builder(
                builder:
                    (context) => Stack(
                      children: [
                        // !(_isRecording || _isloadingVoice)
                        //     ? Positioned(
                        //         bottom: 55,
                        //         child: SizedBox(
                        //           height: 65,
                        //           width: 65,
                        //           child: Image.asset("assets/smart_fuchee.png"),
                        //         ),
                        //       )
                        //     : Container(),
                        Column(
                          children: [
                            Expanded(child: _buildMessageList(context)),
                            _buildUserInput(context),
                          ],
                        ),
                      ],
                    ),
              ),
            ),
          ),
    );
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _messageController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    // _recorder.dispose();
    // _audioPlayer.dispose();
    super.dispose();
  }

  void actionButton(UtilityResponseData response) {
    if (response.detail["serviceIdentifier"] == 'topup') {
      _categoryService.topupWithAmount(
        context,
        response.findValue(primaryKey: 'paymentData', secondaryKey: 'amount'),
        response.findValue(
          primaryKey: 'paymentData',
          secondaryKey: 'mobileNumber',
        ),
      );
    } else if (response.detail["serviceIdentifier"] == 'movies') {
      _categoryService.navigateToMovie(context);
    } else if (response.detail["serviceIdentifier"] == 'bus_ticket') {
      setState(() {
        destinationFrom = response.findValue(
          primaryKey: 'paymentData',
          secondaryKey: 'from',
        );
        destinationTo = response.findValue(
          primaryKey: 'paymentData',
          secondaryKey: 'to',
        );
        destinationDate = response.findValue(
          primaryKey: 'paymentData',
          secondaryKey: 'date',
        );
      });
      _busBooking(
        response.findValue(primaryKey: 'paymentData', secondaryKey: 'from'),
        response.findValue(primaryKey: 'paymentData', secondaryKey: 'to'),
      );
    } else if (response.detail["serviceIdentifier"] == 'airlines') {
      _categoryService.navigateToAirlines(context);
    } else if (response.detail["serviceIdentifier"] == 'landline') {
      _categoryService.navigateToLandline(context);
    } else if (response.detail["serviceIdentifier"] == 'electricity') {
      _categoryService.navigateToElectricityPayment(context);
    }
  }
}
