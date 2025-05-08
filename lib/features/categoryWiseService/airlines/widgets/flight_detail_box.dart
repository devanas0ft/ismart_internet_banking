import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/custom_cached_network_image.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/model/airlines_avliable_list_model.dart';

class FlightDetailBox extends StatelessWidget {
  final Flight? flight;
  const FlightDetailBox({Key? key, this.flight}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    // final adultFare = double.parse(flight?.adultFare ?? "0");
    // final childFare = double.parse(flight?.adultFare ?? "0");

    final d = flight;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xFFF4F4F9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    d?.airline ?? "",
                    style: _textTheme.labelLarge!.copyWith(
                      color: _theme.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    d?.aircraftType ?? "",
                    style: _textTheme.labelLarge!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: CustomTheme.spanishGray,
                    ),
                  ),
                ],
              ),
              CustomCachedNetworkImage(
                url: d?.airlineImage ?? "",
                fit: BoxFit.fitWidth,
                height: 20.hp,
              ),
            ],
          ),
          SizedBox(height: 5.hp),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Route : " +
                          (d?.departure ?? "") +
                          "-" +
                          (d?.arrival ?? ""),
                      style: _textTheme.labelLarge,
                    ),
                    SizedBox(height: 3.hp),
                    Text(
                      "Departure : " +
                          (d?.departureTime ?? "") +
                          "-" +
                          (d?.arrivalTime ?? ""),
                      style: _textTheme.labelLarge,
                    ),
                    SizedBox(height: 3.hp),
                    Text(
                      "Flight Date : " +
                          (d?.flightDate.year.toString() ?? "") +
                          "-" +
                          (d?.flightDate.month.toString() ?? "") +
                          "-" +
                          (d?.flightDate.day.toString() ?? ""),
                      style: _textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text("Total Paying", style: _textTheme.labelLarge),
                  Text(
                    "NPR " + (d?.getTotalFareAfterCashback() ?? "").toString(),
                    style: _textTheme.labelLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _theme.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 5.hp),
          Wrap(
            children: [
              SvgPicture.asset(Assets.personIcon, height: 15.hp),
              Text(
                " Adult : " + (d?.adult ?? ""),
                style: _textTheme.labelMedium,
              ),
              SizedBox(width: 10.wp),
              SvgPicture.asset(Assets.personIcon, height: 15.hp),
              Text(
                "Children : " + (d?.child ?? ""),
                style: _textTheme.labelMedium,
              ),
              SizedBox(width: 10.wp),
              SvgPicture.asset(Assets.luggageIcon, height: 15.hp),
              Text(
                "Luggage : " + (d?.freeBaggage ?? ""),
                style: _textTheme.labelMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ismart/common/constant/env.dart';
// import 'package:ismart/common/util/size_utils.dart';
// import 'package:ismart/common/widget/custom_cached_network_image.dart';
// import 'package:ismart/common/widget/key_value_tile.dart';
// import 'package:ismart/feature/categoryWiseService/airlines/model/airlines_avliable_list_model.dart';

// class FlightDetailBox extends StatelessWidget {
//   final Flight? flight;
//   const FlightDetailBox({Key? key, this.flight}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     final _theme = Theme.of(context);
//     final _textTheme = _theme.textTheme;
//     final _width = SizeUtils.width;
//     final _height = SizeUtils.height;
//     final adultFare = double.parse(flight?.adultFare ?? "0");
//     final childFare = double.parse(flight?.adultFare ?? "0");

//     final d = flight;
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(18),
//         color: const Color(0xFFF3F3F3),
//       ),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Row(
//           children: [
//             Expanded(
//                 child: KeyValueTile(
//               axis: Axis.vertical,
//               titleFontWeight: FontWeight.bold,
//               title: d?.airline ?? "",
//               value: d?.aircraftType ?? "",
//             )),
//             CustomCachedNetworkImage(
//                 url: RepositoryProvider.of<CoOperative>(context).baseUrl +
//                     "ismart/airlinesPdfUrl/" +
//                     "${d?.airlineImage}",
//                 height: 40.hp,
//                 fit: BoxFit.contain),
//           ],
//         ),
//         KeyValueTile(
//           title: "Destination",
//           value: "${d?.departure ?? ""} - ${d?.arrival ?? ""}",
//         ),
//         KeyValueTile(
//           title: "Date",
//           value:
//               "${d?.flightDate.year ?? ""}-${d?.flightDate.month}-${d?.flightDate.day ?? ""}",
//         ),
//         KeyValueTile(
//           title: "Time",
//           value: "${d?.departureTime ?? ""} - ${d?.arrivalTime ?? ""}",
//         ),
//         KeyValueTile(
//           title: "Total Luggage",
//           value: "${d?.freeBaggage ?? ""}",
//         ),
//         KeyValueTile(
//           title: "Status",
//           value: d?.refundable == "T" ? "Refundable" : 'Non Refundable',
//         ),
//         KeyValueTile(
//           title: "${d?.adult ?? ""} Adult * ${d?.adultFare ?? ""}",
//           value: (adultFare * int.parse(d?.adult ?? "0")).toString(),
//         ),
//         if (d?.child != "0")
//           KeyValueTile(
//               title: "${d?.child ?? "0"} Children * ${d?.childFare ?? "0"}",
//               value: ((d?.childFare ?? "0") * int.parse(d?.child ?? "0"))
//                   .toString()),
//         KeyValueTile(
//           title: "Fuel Charge",
//           value: d?.fuelSurcharge ?? "",
//         ),
//         KeyValueTile(
//           title: "Tax",
//           value: d?.tax ?? "",
//         ),
//         KeyValueTile(
//           title: "Total Fare",
//           value: (d?.totalFare ?? 0).toString(),
//         ),
//       ]),
//     );
//   }
// }
