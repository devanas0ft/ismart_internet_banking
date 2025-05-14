import 'package:flutter/material.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/busBooking/widget/bus_detail_box.dart';
import 'package:ismart_web/features/categoryWiseService/busBooking/widget/bus_topbar_location_box.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class AvailableBusWiget extends StatelessWidget {
  final BusTopBarModel busModel;

  final ServiceList service;
  final UtilityResponseData response;

  const AvailableBusWiget({
    Key? key,
    required this.service,
    required this.response,
    required this.busModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final busList = response.findValue(primaryKey: "data");

    return PageWrapper(
      showBackButton: true,
      body: Column(
        children: [
          BusTopBarLocationBox(busModel: busModel),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: busList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return BusDetailBox(
                    services: service,
                    response: response,
                    index: index,
                    busModel: busModel,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
