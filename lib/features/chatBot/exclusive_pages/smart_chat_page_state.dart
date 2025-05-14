// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:ismart/common/util/form_validator.dart';
// import 'package:ismart/common/util/secure_storage_service.dart';
// import 'package:ismart/common/util/url_launcher.dart';
// import 'package:ismart/feature/chatBot/SmartBot_topUp_service.dart';
// import 'package:ismart/feature/chatBot/chat_prompts.dart';

// import 'smart_chat_page.dart';

// abstract class SmartChatPageState extends State<SmartChatPage> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final FocusNode _focusNode = FocusNode();

//   String _currentPromptKey = 'start';
//   List<String> _promptHistory = ['start'];
//   final List<Map<String, dynamic>> _chatHistory = [];
//   bool _isLoading = false;
//   String? _pendingInputType;
//   String? _storedPhoneNumber;
//   String? _storedToUpAmount;
//   List<String> _StoredForPayment = [];

//   @override
//   void initState() {
//     super.initState();
//     _focusNode.addListener(_onFocusChange);
//     _addInitialPrompt();
//     _scrollToBottom();
//   }

//   void _onFocusChange() {
//     if (_focusNode.hasFocus) {
//       Future.delayed(const Duration(milliseconds: 300), _scrollToBottom);
//     }
//   }

//   Future<bool> executeRecharge(String input) async {
//     final regex =
//         RegExp(r'^recharge my number with (\d+)$', caseSensitive: false);
//     final match = regex.firstMatch(input);
//     if (match != null) {
//       _storedPhoneNumber = await SecureStorageService.appPhoneNumber;
//       // _storedPhoneNumber = match.group(1);
//       print("This is number i want : $_storedPhoneNumber");
//       _storedToUpAmount = match.group(1);
//       return true;
//     } else {
//       return false;
//     }
//   }

//   void _scrollToBottom({
//     Duration duration = const Duration(milliseconds: 300),
//   }) {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: duration,
//         curve: Curves.easeOutQuart,
//       );
//     }
//   }

//   String? extractAndValidatePhoneNumber(String? value) {
//     if (value == null || value.isEmpty) {
//       return "invalid";
//     }

//     String formattedValue = value;

//     if (value.startsWith("+977")) {
//       formattedValue = value.substring(4);
//     }

//     final validationError = FormValidator.validatePhoneNumber(formattedValue);

//     if (validationError == null) {
//       return formattedValue;
//     }

//     return "invalid";
//   }

//   void _addInitialPrompt() {
//     setState(() {
//       _chatHistory.add({
//         'type': 'assistant',
//         'message': ChatPrompts.getCurrentQuestion('start'),
//         'timestamp': DateTime.now(),
//         'options': _getPromptOptionsWithBack(),
//       });
//     });
//   }

//   List<String> _getPromptOptionsWithBack() {
//     final List<String> options =
//         ChatPrompts.getCurrentOptions(_currentPromptKey);
//     return _promptHistory.length > 1 ? ['Back', ...options] : options;
//   }

//   void _goBack() {
//     if (_promptHistory.length > 1) {
//       setState(() {
//         _promptHistory.removeLast();
//         _currentPromptKey = _promptHistory.last;

//         //  final previousResponse = _chatHistory[_chatHistory.length - 2];
//         _chatHistory.add({
//           'type': 'assistant',
//           //  'message': previousResponse['message'],
//           'message':
//               'Please select an option below to proceed further, as per your preference.',
//           'timestamp': DateTime.now(),
//           'options': _getPromptOptionsWithBack(),
//         });

//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           _scrollToBottom();
//         });
//       });
//     } else if (_promptHistory.length == 1) {
//       _pendingInputType = '';
//       setState(() {
//         _isLoading = false;
//         _currentPromptKey = 'start';
//         _promptHistory = ['start'];
//         _chatHistory.add({
//           'type': 'assistant',
//           'message': "Let's start over.",
//           'timestamp': DateTime.now(),
//           'options': _getPromptOptionsWithBack(),
//         });
//       });
//       _messageController.clear();
//       _scrollToBottom();
//     }
//   }

//   Future handleUserInput(
//     CategoryService categoryService,
//     String message,
//   ) async {
//     _scrollToBottom();
//     if (message.isEmpty) {
//       return;
//     }

//     message = _capitalizeFirstWord(message);

//     if (message == 'Back') {
//       _goBack();
//       _pendingInputType = '';
//       return;
//     }
//     if (message.toLowerCase() == 'confirm') {
//       UrlLauncher.launchPhone(context: context, phone: '9801132219');
//     }

//     if (await executeRecharge(message)) {
//       if (extractAndValidatePhoneNumber(_storedPhoneNumber) != "invalid") {
//         categoryService.topupWithAmount(context, _storedToUpAmount.toString(),
//             _storedPhoneNumber.toString());
//         setState(() {
//           _chatHistory.add({
//             'type': 'user',
//             'message': message,
//             'timestamp': DateTime.now(),
//           });
//           _chatHistory.add({
//             'type': 'assistant',
//             'message':
//                 'Phone Number: $_storedPhoneNumber\nTop-Up Amount: $_storedToUpAmount. Once verify your transaction. Thank you!',
//             'timestamp': DateTime.now(),
//           });
//           _chatHistory.add({
//             'type': 'assistant',
//             'message': '"Lets start over!',
//             'timestamp': DateTime.now(),
//             'options': _getPromptOptionsWithBack(),
//           });
//           _pendingInputType = null;
//         });
//         _messageController.clear();
//         _scrollToBottom();
//         return;
//       } else {
//         setState(() {
//           _chatHistory.add({
//             'type': 'user',
//             'message': message,
//             'timestamp': DateTime.now(),
//           });
//           _chatHistory.add({
//             'type': 'assistant',
//             'message':
//                 'Invalid phone number. Please enter a valid 10-digit number',
//             'timestamp': DateTime.now(),
//           });
//         });
//         _messageController.clear();
//         _scrollToBottom();
//         return;
//       }
//     }

//     if (true) {
//       _StoredForPayment.add(message);
//       print('The previous response is: ${_StoredForPayment}');
//     }
//     if (message.toLowerCase() == 'proceed for payment') {
//       if (_StoredForPayment[_StoredForPayment.length - 2].toLowerCase() ==
//           'electricity payment') {
//         categoryService.navigateToElectricityPayment(context);
//       } else if (_StoredForPayment[_StoredForPayment.length - 2]
//               .toLowerCase() ==
//           'broker payment') {
//         categoryService.navigateToBrokerPayment(context);
//       } else if (_StoredForPayment[_StoredForPayment.length - 2]
//               .toLowerCase() ==
//           'movie ticket booking') {
//         categoryService.navigateToMovie(context);
//       } else if (_StoredForPayment[_StoredForPayment.length - 2]
//               .toLowerCase() ==
//           'bus ticketing') {
//         categoryService.navigateToBusBooking(context);
//       } else if (_StoredForPayment[_StoredForPayment.length - 2]
//               .toLowerCase() ==
//           'airlines') {
//         categoryService.navigateToAirlines(context);
//       } else if (_StoredForPayment[_StoredForPayment.length - 2]
//               .toLowerCase() ==
//           'lanline payment') {
//         categoryService.navigateToLandline(context);
//       }
//     }

//     if (message.toLowerCase() == 'top up' ||
//         message.toLowerCase().contains('top up')) {
//       setState(() {
//         _chatHistory.add({
//           'type': 'user',
//           'message': message,
//           'timestamp': DateTime.now(),
//         });
//         _chatHistory.add({
//           'type': 'assistant',
//           'message': 'Please enter your phone number (e.g., 98XXXXXXXX):',
//           'timestamp': DateTime.now(),
//           'options': ['Back'],
//         });
//         _pendingInputType = 'phone_number';
//       });
//       _messageController.clear();
//       _scrollToBottom();
//       return;
//     }

//     if (_pendingInputType == 'phone_number') {
//       if (extractAndValidatePhoneNumber(message) != "invalid") {
//         //   getTopupType(message);

//         setState(() {
//           _storedPhoneNumber = message;
//           _chatHistory.add({
//             'type': 'user',
//             'message': message,
//             'timestamp': DateTime.now(),
//           });
//           _chatHistory.add({
//             'type': 'assistant',
//             'message':
//                 'Phone number verified. How much would you like to top up?',
//             'timestamp': DateTime.now(),
//             'options': ['50', '100', '150', '200', '500'],
//           });
//           _pendingInputType = 'top_up_amount';
//         });
//         _messageController.clear();
//         _scrollToBottom();
//         return;
//       } else {
//         setState(() {
//           _chatHistory.add({
//             'type': 'user',
//             'message': message,
//             'timestamp': DateTime.now(),
//           });
//           _chatHistory.add({
//             'type': 'assistant',
//             'message':
//                 'Invalid phone number. Please enter a valid 10-digit number',
//             'timestamp': DateTime.now(),
//           });
//         });
//         _messageController.clear();
//         _scrollToBottom();
//         return;
//       }
//     }

//     // Handle top-up amount validation if in that state
//     if (_pendingInputType == 'top_up_amount') {
//       final List<String> validAmounts = ['50', '100', '150', '200', '500'];
//       if (validAmounts.contains(message) ||
//           validAmounts
//               .any((amount) => message.toLowerCase().contains(amount))) {
//         categoryService.topupWithAmount(
//             context, message.toString(), _storedPhoneNumber.toString());
//         setState(() {
//           _chatHistory.add({
//             'type': 'user',
//             'message': message,
//             'timestamp': DateTime.now(),
//           });

//           _storedToUpAmount = message;
//           _chatHistory.add({
//             'type': 'assistant',
//             'message':
//                 'Phone Number: $_storedPhoneNumber\nTop-Up Amount: $_storedToUpAmount. Once verify your transaction. Thank you!',
//             'timestamp': DateTime.now(),
//           });
//           _chatHistory.add({
//             'type': 'assistant',
//             'message': '"Lets start over!',
//             'timestamp': DateTime.now(),
//             'options': _getPromptOptionsWithBack(),
//           });
//           _pendingInputType = null;
//           // NavigationService.push(target: Container());
//         });
//         _messageController.clear();
//         _scrollToBottom();
//         return;
//       } else {
//         setState(() {
//           _chatHistory.add({
//             'type': 'user',
//             'message': message,
//             'timestamp': DateTime.now(),
//           });
//           _chatHistory.add({
//             'type': 'assistant',
//             'message':
//                 'Please select a valid top-up amount from the options: 50, 100, 150, 200, or 500.',
//             'timestamp': DateTime.now(),
//             'options': ['50', '100', '150', '200', '500'],
//           });
//         });
//         _messageController.clear();
//         _scrollToBottom();
//         return;
//       }
//     }

//     setState(() {
//       _chatHistory.add({
//         'type': 'user',
//         'message': message,
//         'timestamp': DateTime.now(),
//       });
//       _isLoading = true;
//     });

//     int getRandomNumber() {
//       final random = Random();
//       return 200 + random.nextInt(1200 - 200 + 1);
//     }

//     await Future.delayed(Duration(milliseconds: getRandomNumber()));
//     _scrollToBottom();
//     final List<String> currentOptions = _getPromptOptionsWithBack();
//     final String? matchedOption = currentOptions.firstWhere(
//       (option) => message.toLowerCase().contains(option.toLowerCase()),
//       orElse: () => '',
//     );

//     if (matchedOption!.isNotEmpty) {
//       await _handleMatchedInput(matchedOption);
//     } else {
//       setState(() {
//         _isLoading = false;
//         _currentPromptKey = 'start';
//         _promptHistory = ['start'];
//         _chatHistory.add({
//           'type': 'assistant',
//           'message': "I don't understand. Let's start over.",
//           'timestamp': DateTime.now(),
//           'options': _getPromptOptionsWithBack(),
//         });
//       });
//       _messageController.clear();
//       _scrollToBottom();
//     }
//   }

//   Future<void> _handleMatchedInput(String matchedOption) async {
//     final String? response =
//         ChatPrompts.getResponse(_currentPromptKey, matchedOption);
//     final String? nextPromptKey =
//         ChatPrompts.getNextPromptKey(_currentPromptKey, matchedOption);

//     setState(() {
//       _isLoading = false;
//       if (response != null) {
//         _chatHistory.add({
//           'type': 'assistant',
//           'message': response,
//           'timestamp': DateTime.now(),
//         });
//       }

//       if (nextPromptKey != null) {
//         _currentPromptKey = nextPromptKey;
//         _promptHistory.add(nextPromptKey);

//         final prompt =
//             ChatPrompts.findPrompt(ChatPrompts.prompts, nextPromptKey);
//         if (prompt != null) {
//           _chatHistory.add({
//             'type': 'assistant',
//             'message': ChatPrompts.getCurrentQuestion(nextPromptKey),
//             'timestamp': DateTime.now(),
//             'options': _getPromptOptionsWithBack(),
//           });

//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             _scrollToBottom();
//           });
//         }
//       } else {
//         _currentPromptKey = 'start';
//         _promptHistory = ['start'];
//         _chatHistory.add({
//           'type': 'assistant',
//           'message':
//               "I am glad I could be there to assist you. Feel free to know about us further. How can I help?",
//           'timestamp': DateTime.now(),
//           'options': _getPromptOptionsWithBack(),
//         });
//       }
//       _scrollToBottom();
//     });

//     _messageController.clear();
//   }

//   String _capitalizeFirstWord(String input) {
//     if (input.isEmpty) {
//       return input;
//     }
//     return input[0].toUpperCase() + input.substring(1);
//   }

//   TextEditingController get messageController => _messageController;
//   ScrollController get scrollController => _scrollController;
//   FocusNode get focusNode => _focusNode;
//   List<Map<String, dynamic>> get chatHistory => _chatHistory;
//   bool get isLoading => _isLoading;

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _focusNode.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
// }
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:ismart/common/util/form_validator.dart';
// import 'package:ismart/common/util/secure_storage_service.dart';
// import 'package:ismart/common/util/url_launcher.dart';
// import 'package:ismart/feature/chatBot/SmartBot_topUp_service.dart';
// import 'package:ismart/feature/chatBot/chat_prompts.dart';
// import 'package:ismart/feature/utility_payment/cubit/utility_payment_cubit.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'smart_chat_page.dart';

// abstract class SmartChatPageState extends State<SmartChatPage> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final FocusNode _focusNode = FocusNode();

//   final List<Map<String, dynamic>> _chatHistory = [];
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _focusNode.addListener(_onFocusChange);
//     _addInitialPrompt();
//     _scrollToBottom();
//   }

//   void _onFocusChange() {
//     if (_focusNode.hasFocus) {
//       Future.delayed(const Duration(milliseconds: 300), _scrollToBottom);
//     }
//   }

//   void _scrollToBottom({
//     Duration duration = const Duration(milliseconds: 300),
//   }) {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: duration,
//         curve: Curves.easeOutQuart,
//       );
//     }
//   }

//   void _addInitialPrompt() {
//     setState(() {
//       _chatHistory.add({
//         'type': 'assistant',
//         'message': ChatPrompts.getCurrentQuestion('start'),
//         'timestamp': DateTime.now(),
//         // 'options': [''],
//       });
//     });
//   }

//   Future handleUserInput(BuildContext context, CategoryService categoryService,
//       String message, int id) async {
//     _scrollToBottom();
//     if (message.isEmpty) {
//       return;
//     }
//     message = _capitalizeFirstWord(message);
//     setState(() {
//       _chatHistory.add({
//         'type': 'user',
//         'message': message,
//         'timestamp': DateTime.now(),
//         // 'options': [''],
//       });
//       _messageController.clear();
//     });

//     context.read<UtilityPaymentCubit>().makePayment(
//           mPin: '',
//           accountDetails: {},
//           serviceIdentifier: '',
//           body: {'message': message},
//           apiEndpoint: '/api/ai/message/$id',
//         );
//   }

//   String _capitalizeFirstWord(String input) {
//     if (input.isEmpty) {
//       return input;
//     }
//     return input[0].toUpperCase() + input.substring(1);
//   }

//   TextEditingController get messageController => _messageController;
//   ScrollController get scrollController => _scrollController;
//   FocusNode get focusNode => _focusNode;
//   List<Map<String, dynamic>> get chatHistory => _chatHistory;
//   bool get isLoading => _isLoading;
//   set isLoading(bool value) => _isLoading = value;
//   void scrollToBottom() => _scrollToBottom();

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _focusNode.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
// }
