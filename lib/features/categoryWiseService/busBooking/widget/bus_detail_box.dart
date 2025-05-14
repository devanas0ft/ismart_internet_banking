import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/busBooking/screen/bus_seat_page.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

import 'bus_topbar_location_box.dart';

class BusDetailBox extends StatelessWidget {
  final int index;
  final BusTopBarModel busModel;

  final ServiceList services;
  final UtilityResponseData response;

  const BusDetailBox({
    Key? key,
    required this.index,
    required this.response,
    required this.services,
    required this.busModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final busList = response.findValue(primaryKey: "data");

    final data = busList[index];
    final list = data["seatLayout"];
    return InkWell(
      onTap: () {
        NavigationService.push(
          target: BusSeatPage(
            index: index,
            columnNumber: busList[index]["noOfColumn"],
            seatLayout: list,
            busList: busList,
            services: services,
            busModel: busModel,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          // color: _theme.primaryColor.withOpacity(0.4)),
          color: CustomTheme.white,
        ),
        // padding: EdgeInsets.all(18),
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data["operator"],
                          style: _textTheme.titleSmall!.copyWith(
                            color: _theme.primaryColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "${data["busType"]} - ${data["departureTime"]}",
                          style: _textTheme.titleSmall!.copyWith(
                            color: CustomTheme.darkGray,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Seat \n${list.length}",
                      style: _textTheme.titleSmall!.copyWith(
                        color: _theme.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Text(
                      data["amenities"].toString() != "null"
                          ? data["amenities"].toString()
                          : "",
                      style: _textTheme.titleSmall!.copyWith(
                        // color: CustomTheme.darkGray,
                        fontSize: 11,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    color: _theme.primaryColor,
                  ),
                  child: Text(
                    "Rs. ${data["ticketPrice"]}",
                    style: _textTheme.titleSmall!.copyWith(
                      color: CustomTheme.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
