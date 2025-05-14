import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/busBooking/widget/bus_seat_widget.dart';
import 'package:ismart_web/features/categoryWiseService/busBooking/widget/bus_topbar_location_box.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class BusSeatPage extends StatelessWidget {
  final List seatLayout;
  final ServiceList services;
  final BusTopBarModel busModel;
  final columnNumber;
  final List<dynamic> busList;
  final int index;
  const BusSeatPage({
    Key? key,
    required this.seatLayout,
    this.columnNumber,
    required this.busList,
    required this.index,
    required this.services,
    required this.busModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => UtilityPaymentCubit(
            utilityPaymentRepository:
                RepositoryProvider.of<UtilityPaymentRepository>(context),
          ),
      child: BusSeatsListWidget(
        seatLayout: seatLayout,
        columnNumber: columnNumber,
        busList: busList,
        index: index,
        services: services,
        busModel: busModel,
      ),
    );
  }
}
