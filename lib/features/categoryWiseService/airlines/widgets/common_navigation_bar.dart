// import 'package:flutter/material.dart';
// import 'package:ismart/common/util/size_utils.dart';

// import '../../../../app/theme.dart';

// class CommonNavigationBar extends StatefulWidget {
//   final ValueNotifier<int> selectedIndex;
//   final List<String> items;
//   final void Function(int)? onChanged;
//   final EdgeInsets? margin;
//   final double borderRadius;
//   final double verticalPadding;
//   final bool showBorder;
//   const CommonNavigationBar({
//     Key? key,
//     required this.selectedIndex,
//     required this.items,
//     this.onChanged,
//     this.margin,
//     this.borderRadius = 13,
//     this.verticalPadding = 8,
//     this.showBorder = true,
//   }) : super(key: key);

//   @override
//   State<CommonNavigationBar> createState() => _CommonNavigationBarState();
// }

// class _CommonNavigationBarState extends State<CommonNavigationBar> {
//   @override
//   Widget build(BuildContext context) {
//     final _theme = Theme.of(context);
//     final _textTheme = _theme.textTheme;

//     return Container(
//       decoration: BoxDecoration(
//         color: CustomTheme.lightGray,
//         borderRadius: BorderRadius.circular(widget.borderRadius),
//       ),
//       margin: widget.margin,
//       padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//       child: Row(
//         children: List.generate(
//           widget.items.length,
//           (index) {
//             return Expanded(
//               child: Container(
//                 padding: widget.showBorder == false
//                     ? EdgeInsets.zero
//                     : EdgeInsets.only(left: index == 0 ? 0 : 12.wp),
//                 child: InkWell(
//                   onTap: () {
//                     widget.selectedIndex.value = index;
//                     if (widget.onChanged != null) {
//                       widget.onChanged!(index);
//                     }
//                   },
//                   child: ValueListenableBuilder<int>(
//                     valueListenable: widget.selectedIndex,
//                     builder: (context, currentIndex, _) {
//                       return Row(
//                         children: [
//                           Expanded(
//                             child: Container(
//                               alignment: Alignment.center,
//                               padding: EdgeInsets.symmetric(
//                                   vertical: widget.verticalPadding,
//                                   horizontal: 4),
//                               decoration: BoxDecoration(
//                                 color: currentIndex == index
//                                     ? Colors.white
//                                     : Colors.transparent,
//                                 borderRadius:
//                                     BorderRadius.circular(widget.borderRadius),
//                               ),
//                               child: Text(
//                                 widget.items[index],
//                                 style: _textTheme.titleLarge!.copyWith(
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           if (index != (widget.items.length - 1) &&
//                               widget.showBorder)
//                             Container(
//                               margin: EdgeInsets.only(left: 12.wp),
//                               height: 12.hp,
//                               width: 2.wp,
//                               decoration: BoxDecoration(
//                                 color: CustomTheme.gray,
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                             ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
