// import 'package:flutter/material.dart';
// import 'package:ismart/app/theme.dart';
// import 'package:ismart/common/util/size_utils.dart';

// class FlightAmountDetailsColumnWidget extends StatelessWidget {
//   const FlightAmountDetailsColumnWidget({
//     Key? key,
//     required this.title,
//     required this.price,
//     required this.cashBack,
//   }) : super(key: key);

//   final String title;
//   final String price;
//   final String cashBack;
//   @override
//   Widget build(BuildContext context) {
//     final _theme = Theme.of(context);
//     final _textTheme = _theme.textTheme;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "$title",
//           style: _textTheme.titleSmall!.copyWith(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(
//           height: 5.hp,
//         ),
//         Text(
//           "NPR $price",
//           style: _textTheme.titleMedium!.copyWith(
//             color: CustomTheme.lightTextColor,
//             fontWeight: FontWeight.normal,
//           ),
//         ),
//       ],
//     );
//   }
// }
