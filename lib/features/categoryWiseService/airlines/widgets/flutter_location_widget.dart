// import 'package:flutter/material.dart';
// import 'package:ismart/common/util/size_utils.dart';

// class FlightLocationWidget extends StatelessWidget {
//   const FlightLocationWidget({
//     Key? key,
//     this.iconData,
//     this.svgPicture,
//     required this.locationSlug,
//     required this.locationName,
//   }) : super(key: key);
//   final IconData? iconData;
//   final String locationSlug;
//   final String locationName;
//   final String? svgPicture;
//   @override
//   Widget build(BuildContext context) {
//     final _theme = Theme.of(context);
//     final _textTheme = _theme.textTheme;
//     return Row(
//       children: [
//         if (iconData != null)
//           Icon(
//             iconData,
//             color: _theme.primaryColor,
//           ),
//         if (svgPicture != null || iconData != null)
//           SizedBox(
//             width: 10.hp,
//           ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "$locationSlug",
//               style: _textTheme.titleLarge!.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text("$locationName"),
//           ],
//         )
//       ],
//     );
//   }
// }
