import 'package:flutter/material.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/busBooking/widget/available_bus_widget.dart';
import 'package:ismart_web/features/categoryWiseService/busBooking/widget/bus_topbar_location_box.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class AvailableBusPage extends StatelessWidget {
  final BusTopBarModel busModel;
  final ServiceList service;
  final UtilityResponseData response;

  const AvailableBusPage({
    Key? key,
    required this.service,
    required this.response,
    required this.busModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AvailableBusWiget(
      busModel: busModel,
      response: response,
      service: service,
    );
  }
}
