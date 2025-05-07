// import 'package:flutter/material.dart';
// import 'package:ismart/app/theme.dart';
// import 'package:ismart/common/navigation/navigation_service.dart';
// import 'package:ismart/common/util/size_utils.dart';
// import 'package:ismart/common/widget/common_button.dart';
// import 'package:ismart/common/widget/common_text_field.dart';
// import 'package:ismart/common/widget/primary_account_box.dart';

// class ShowDatePickerStatement extends StatefulWidget {
//   final fromDate;
//   final toDate;

//   const ShowDatePickerStatement(
//       {Key? key, required this.fromDate, required this.toDate})
//       : super(key: key);

//   @override
//   State<ShowDatePickerStatement> createState() =>
//       _ShowDatePickerStatementState();
// }

// class _ShowDatePickerStatementState extends State<ShowDatePickerStatement> {
//   @override
//   Widget build(BuildContext context) {
//     final _theme = Theme.of(context);
//     final _textTheme = _theme.textTheme;
//     final _width = SizeUtils.width;
//     final _height = SizeUtils.height;
//     return Center(
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(18),
//         ),
//         height: _height * 0.7,
//         width: _width * 0.9,
//         child: Scaffold(
//           backgroundColor: CustomTheme.white,
//           body: Padding(
//             padding: const EdgeInsets.all(18.0),
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Text(
//                 "Filter",
//                 style: _textTheme.labelLarge!
//                     .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               PrimaryAccountBox(),
//               CustomTextField(
//                 customHintTextStyle: true,
//                 readOnly: true,
//                 onTap: () async {
//                   final DateTime? picked = await showDatePicker(
//                       context: context,
//                       initialDate: widget.fromDate,
//                       firstDate: DateTime(2015, 8),
//                       lastDate: DateTime.now());
//                   widget.fromDate = picked;
//                 },
//                 showSuffixImage: true,
//                 title: "From Date",
//                 hintText:
//                     "${widget.fromDate.year}-${widget.fromDate.month}-${widget.fromDate!.day}",
//               ),
//               CustomTextField(
//                 showSuffixImage: true,
//                 customHintTextStyle: true,
//                 readOnly: true,
//                 hintText: "${widget.toDate.year}-${widget.toDate.month}-${widget.toDate.day}",
//                 title: "To Date",
//                 onTap: () async {
//                   final DateTime? picked = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(2015, 8),
//                       lastDate: DateTime.now());
//                   setState(() {
//                     toDate = picked!;
//                   });
//                 },
//               ),
//               CustomRoundedButtom(
//                   title: "View",
//                   onPressed: () {
//                     getData();
//                     NavigationService.pop();
//                   })
//             ]),
//           ),
//         ),
//       ),
//     );
//   }
// }
