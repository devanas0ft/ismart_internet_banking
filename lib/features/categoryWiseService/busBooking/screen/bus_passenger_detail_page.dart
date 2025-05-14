import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/busBooking/widget/bus_passenger_detail_widget.dart';
import 'package:ismart_web/features/categoryWiseService/busBooking/widget/bus_topbar_location_box.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class BusPassengerDetailPage extends StatelessWidget {
  final double totalFare;
  final BusTopBarModel busModel;
  final List selectedSeats;

  final ServiceList service;
  final selectedBusData;

  final UtilityResponseData response;
  const BusPassengerDetailPage({
    Key? key,
    required this.response,
    required this.service,
    required this.totalFare,
    required this.selectedBusData,
    required this.busModel,
    required this.selectedSeats,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => UtilityPaymentCubit(
            utilityPaymentRepository:
                RepositoryProvider.of<UtilityPaymentRepository>(context),
          ),
      child: BusPassengerDetailWidget(
        selectedSeats: selectedSeats,
        service: service,
        busModel: busModel,
        totalFare: totalFare,
        response: response,
        selectedBusData: selectedBusData,
      ),
    );
  }
}
