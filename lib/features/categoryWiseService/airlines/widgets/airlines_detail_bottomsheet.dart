import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/model/airlines_avliable_list_model.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/model/flight_information_model.dart';

class AirlinesDetailBottomSheet extends StatefulWidget {
  final Flight flight;
  const AirlinesDetailBottomSheet({Key? key, required this.flight})
    : super(key: key);

  @override
  State<AirlinesDetailBottomSheet> createState() =>
      _AirlinesDetailBottomSheetState();
}

class _AirlinesDetailBottomSheetState extends State<AirlinesDetailBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final _height = SizeUtils.height;
    final f = widget.flight;
    final List<FlightInformationModel> flights = [
      FlightInformationModel(title: "Airlines", detail: f.airline),
      FlightInformationModel(title: "Flight Type", detail: f.aircraftType),
      FlightInformationModel(
        title: "Time",
        detail: f.departureTime + " - " + f.arrivalTime,
      ),
      FlightInformationModel(
        title: "Type",
        detail:
            f.refundable.toString() == "T" ? "Refundable" : "Non Refundable",
      ),
      FlightInformationModel(title: "Free Baggage", detail: f.freeBaggage),
      FlightInformationModel(
        title: "Adult Fare",
        detail: f.adultFare + " * " + f.adult,
      ),
      if (widget.flight.child != "0")
        FlightInformationModel(
          title: "Child Fare",
          detail: f.childFare + " * " + f.child,
        ),
      FlightInformationModel(title: "Airport Tax", detail: f.tax),
      FlightInformationModel(title: "Fuel Surcharge", detail: f.fuelSurcharge),
      FlightInformationModel(
        title: "Total Amount",
        detail: f.totalFare.toString(),
      ),
      if (!f.cashBack.isNegative)
        FlightInformationModel(
          title: "Cashback",
          detail: f.cashBack.toString(),
        ),
      if (!f.cashBack.isNegative)
        FlightInformationModel(
          title: "Total Paying",
          detail: (f.totalFare - f.cashBack).toString(),
        ),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Text(
              widget.flight.departure + " to " + widget.flight.arrival,
              style: _textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: flights.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                color:
                    index.isOdd
                        ? CustomTheme.testAppColor.withOpacity(0.05)
                        : CustomTheme.white,
                child: Row(
                  children: [
                    SizedBox(
                      width: _height * 0.18,
                      child: Text(
                        flights[index].title,
                        style: _textTheme.titleLarge,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          flights[index].detail,
                          style: _textTheme.titleLarge,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // KeyValueTile(
          //     title: "Flight Detail",
          //     value: widget.flight.airline + widget.flight.flightNo),
          // KeyValueTile(
          //     title: "Time",
          //     value: widget.flight.flightDate.toString() +
          //         widget.flight.departureTime +
          //         "" +
          //         widget.flight.arrivalTime),
          // KeyValueTile(title: "Flight Type", value: widget.flight.aircraftType),
          // KeyValueTile(title: "Adult Fare", value: widget.flight.adultFare),
          // widget.flight.child == "0"
          //     ? Container()
          //     : KeyValueTile(
          //         title: "Child Fare", value: widget.flight.childFare),
          // widget.flight.infant == "0"
          //     ? Container()
          //     : KeyValueTile(
          //         title: "Infant Fare", value: widget.flight.infantFare),
          // KeyValueTile(
          //     title: "Fuel Charge", value: widget.flight.fuelSurcharge),
          // KeyValueTile(
          //   title: "Ticket Type",
          //   value: widget.flight.refundable == "T"
          //       ? "Refundable"
          //       : "Non Refundable",
          // ),
          // KeyValueTile(title: "Free Baggage", value: widget.flight.freeBaggage),
          // KeyValueTile(
          //     title: "Free Baggage",
          //     value: DateUtils.dateOnly(widget.flight.flightDate).toString()),
          // KeyValueTile(
          //     title: "Total Fare",
          //     value: "NPR" + widget.flight.totalFare.toString()),
        ],
      ),
    );
  }
}
