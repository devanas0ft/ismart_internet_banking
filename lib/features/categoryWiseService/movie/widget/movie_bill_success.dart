// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ismart/app/theme.dart';
// import 'package:ismart/common/constant/env.dart';
// import 'package:ismart/common/navigation/navigation_service.dart';
// import 'package:ismart/common/route/routes.dart';
// import 'package:ismart/common/util/file_download_utils.dart';
// import 'package:ismart/common/util/size_utils.dart';
// import 'package:ismart/common/widget/common_button.dart';
// import 'package:ismart/common/widget/page_wrapper.dart';
// import 'package:ismart/feature/categoryWiseService/movie/resource/model/movie_seat_model.dart';

// class MoviePaymentSuccessScreen extends StatelessWidget {
//   final String pdfUrl;
//   final MovieDetails? movieDetails;
//   final List<Seats?> selectedSeats;
//   final String transactionId;
//   final String totalAmount;

//   const MoviePaymentSuccessScreen({
//     Key? key,
//     required this.movieDetails,
//     required this.selectedSeats,
//     required this.transactionId,
//     required this.totalAmount,
//     required this.pdfUrl,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final textTheme = theme.textTheme;

//     return PageWrapper(
//       backgroundColor: CustomTheme.white,
//       showBackButton: false,
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             SizedBox(height: 40.hp),
//             _buildSuccessIcon(),
//             SizedBox(height: 24.hp),
//             _buildSuccessMessage(textTheme),
//             SizedBox(height: 32.hp),
//             _buildTransactionDetails(textTheme),
//             SizedBox(height: 24.hp),
//             _buildMovieDetails(textTheme),
//             SizedBox(height: 24.hp),
//             _buildSeatInfo(textTheme),
//             SizedBox(height: 24.hp),
//             _buildTotalAmount(textTheme),
//             SizedBox(height: 40.hp),
//             CustomRoundedButtom(
//               title: "Download Ticket",
//               onPressed: () {
//                 // `TODO`: Implement ticket download functionality
//               },
//             ),
//             SizedBox(height: 16.hp),
//             CustomRoundedButtom(
//               title: "Done",
//               onPressed: () {
//                 NavigationService.pushNamedAndRemoveUntil(
//                     routeName: Routes.dashboard);
//               },
//               textColor: CustomTheme.primaryColor,
//             ),
//             CustomRoundedButtom(
//               borderColor: Theme.of(context).primaryColor,
//               textColor: Theme.of(context).primaryColor,
//               title: "Download Receipt",
//               color: Colors.transparent,
//               onPressed: () {
//                 FileDownloadUtils.downloadFile(
//                   downloadLink:
//                       RepositoryProvider.of<CoOperative>(context).baseUrl +
//                           pdfUrl,
//                   fileName: FileDownloadUtils.generateDownloadFileName(
//                     name: "${movieDetails?.movieName}_movie_ticket_iSmart",
//                     filetype: FileType.pdf,
//                   ),
//                   context: context,
//                 );
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSuccessIcon() {
//     return Icon(
//       Icons.check_circle_outline,
//       color: CustomTheme.primaryColor,
//       size: 80.hp,
//     );
//   }

//   Widget _buildSuccessMessage(TextTheme textTheme) {
//     return Column(
//       children: [
//         Text(
//           "Payment Successful!",
//           style: textTheme.headlineSmall!.copyWith(
//             fontWeight: FontWeight.bold,
//             color: CustomTheme.primaryColor,
//           ),
//         ),
//         SizedBox(height: 8.hp),
//         Text(
//           "Your movie tickets have been booked successfully.",
//           style: textTheme.bodyMedium,
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }

//   Widget _buildTransactionDetails(TextTheme textTheme) {
//     return Card(
//       color: CustomTheme.backgroundColor,
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Transaction Details", style: textTheme.titleLarge),
//             SizedBox(height: 8.hp),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Transaction ID:", style: textTheme.bodyMedium),
//                 Text(transactionId, style: textTheme.bodyLarge),
//               ],
//             ),
//             SizedBox(height: 8.hp),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Date:", style: textTheme.bodyMedium),
//                 Text(DateTime.now().toString().split(' ')[0],
//                     style: textTheme.bodyLarge),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMovieDetails(TextTheme textTheme) {
//     return Card(
//       color: CustomTheme.backgroundColor,
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Movie Details", style: textTheme.titleLarge),
//             SizedBox(height: 8.hp),
//             Text(movieDetails?.movieName ?? "", style: textTheme.titleMedium),
//             SizedBox(height: 4.hp),
//             Text('${movieDetails?.genre} | ${movieDetails?.duration}',
//                 style: textTheme.bodyMedium),
//             SizedBox(height: 8.hp),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Date', style: textTheme.bodySmall),
//                     Text("${movieDetails?.showDate}",
//                         style: textTheme.bodyLarge),
//                   ],
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Time', style: textTheme.bodySmall),
//                     Text(movieDetails?.showTime ?? "",
//                         style: textTheme.bodyLarge),
//                   ],
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Screen', style: textTheme.bodySmall),
//                     Text(movieDetails?.screenName ?? "",
//                         style: textTheme.bodyLarge),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSeatInfo(TextTheme textTheme) {
//     return Card(
//       color: CustomTheme.backgroundColor,
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Seats', style: textTheme.titleLarge),
//             SizedBox(height: 8.hp),
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: selectedSeats
//                   .map((seat) => Chip(
//                         label: Text(seat?.seatName ?? ""),
//                         backgroundColor:
//                             CustomTheme.primaryColor.withOpacity(0.1),
//                         labelStyle: TextStyle(color: CustomTheme.primaryColor),
//                       ))
//                   .toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTotalAmount(TextTheme textTheme) {
//     return Card(
//       color: CustomTheme.backgroundColor,
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('Total Amount', style: textTheme.titleLarge),
//             Text('Rs $totalAmount',
//                 style: textTheme.headlineSmall
//                     ?.copyWith(color: CustomTheme.primaryColor)),
//           ],
//         ),
//       ),
//     );
//   }
// }
