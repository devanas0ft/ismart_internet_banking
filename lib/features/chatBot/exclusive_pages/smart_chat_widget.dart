// import 'package:flutter/material.dart';
// import 'package:ismart/app/theme.dart';
// import 'package:ismart/common/widget/common_text_field.dart';
// import 'package:ismart/feature/chatBot/SmartBot_topUp_service.dart';
// import 'package:ismart/feature/chatBot/typing_animation.dart';
// // import 'package:lottie/lottie.dart';
// import 'smart_chat_page_state.dart';

// extension SmartChatWidgets on SmartChatPageState {
//   Widget buildMessageList(
//       CategoryService categoryService, int id, BuildContext context) {
//     return ListView.builder(
//       controller: scrollController,
//       padding: const EdgeInsets.all(8),
//       itemCount: chatHistory.length + (isLoading ? 1 : 0),
//       itemBuilder: (context, index) {
//         if (index == chatHistory.length && isLoading) {
//           return _buildTypingIndicator(categoryService);
//         }
//         return _buildMessageItem(categoryService, chatHistory[index], context);
//       },
//     );
//   }

//   Widget _buildTypingIndicator(CategoryService categoryService) {
//     return Container(
//       alignment: Alignment.centerLeft,
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         decoration: BoxDecoration(
//           color: CustomTheme.primaryColor.withOpacity(0.9),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: const TypingIndicator(),
//       ),
//     );
//   }

//   Widget _buildMessageItem(CategoryService categoryService,
//       Map<String, dynamic> message, BuildContext context) {
//     final bool isUser = message['type'] == 'user';

//     return Column(
//       crossAxisAlignment:
//           isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//       children: [
//         Container(
//           alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//           margin: const EdgeInsets.symmetric(vertical: 4),
//           child: (message['message'] != '' && message['message'] != null)
//               ? Container(
//                   constraints: BoxConstraints(
//                     maxWidth: MediaQuery.of(context).size.width * 0.8,
//                   ),
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                   decoration: BoxDecoration(
//                     color: isUser
//                         ? CustomTheme.primaryColor
//                         : const Color.fromRGBO(255, 255, 255, 1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     message['message'],
//                     style: TextStyle(
//                         color: !isUser
//                             ? CustomTheme.primaryColor
//                             : const Color.fromRGBO(255, 255, 255, 1),
//                         fontSize: 14),
//                   ),
//                 )
//               : Container(),
//         ),
//         if (!isUser && message['options'] != null)
//           Wrap(
//             spacing: 2.0,
//             runSpacing: 2.0,
//             children: (message['options'] as List<String>).map((option) {
//               return Padding(
//                 padding: const EdgeInsets.all(2.0),
//                 child: GestureDetector(
//                   onTap: () => handleUserInput(
//                       context, categoryService, option, widget.id),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 10.0, horizontal: 12.0),
//                     decoration: BoxDecoration(
//                       color: CustomTheme.primaryColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Text(
//                       option,
//                       style: TextStyle(
//                           color: CustomTheme.primaryColor, fontSize: 11),
//                     ),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//       ],
//     );
//   }

//   Widget buildUserInput(
//       CategoryService categoryService, int id, BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Expanded(
//             child: CustomTextField(
//               controller: messageController,
//               hintText: 'Type a message...',
//               onSubmited: (value) =>
//                   handleUserInput(context, categoryService, value, id),
//             ),
//           ),
//           Center(
//             child: Container(
//               margin: const EdgeInsets.only(bottom: 10),
//               child: Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(
//                       Icons.mic,
//                       color: CustomTheme.primaryColor,
//                       size: 30,
//                     ),
//                     onPressed: () {},
//                   ),
//                   IconButton(
//                     icon: Icon(
//                       Icons.send,
//                       color: CustomTheme.primaryColor,
//                       size: 30,
//                     ),
//                     onPressed: () => handleUserInput(
//                         context, categoryService, messageController.text, id),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
