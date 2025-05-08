// import 'package:flutter/material.dart';
// import 'package:ismart/app/theme.dart';

// class AirlinesTitleList extends StatelessWidget {
//   final Function(String) onPress;
//   final List title = ["Mr.", "Mrs.", "Miss"];
//   AirlinesTitleList({Key? key, required this.onPress}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     final _theme = Theme.of(context);
//     final _textTheme = _theme.textTheme;
//     return Row(
//       children: [
//         ...List.generate(
//             title.length,
//             (index) => Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
//                   margin: const EdgeInsets.only(right: 15),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: CustomTheme.darkerBlack),
//                     color: Colors.white,
//                     // borderRadius: BorderRadius.circular(100),
//                   ),
//                   child: InkWell(
//                     borderRadius: BorderRadius.circular(100),
//                     onTap: () {
//                       onPress(title[index]);
//                     },
//                     child: Center(
//                       child: Text(
//                         title[index].toString(),
//                         textAlign: TextAlign.center,
//                         style: _textTheme.headlineSmall,
//                       ),
//                     ),
//                   ),
//                 ))
//       ],
//     );
//   }
// }
