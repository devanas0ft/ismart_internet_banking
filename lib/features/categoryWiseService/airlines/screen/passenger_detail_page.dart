import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/model/airlines_avliable_list_model.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/widgets/passenger_detail_widget.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

// ignore: must_be_immutable
class PassengerDetailScreen extends StatelessWidget {
  Flight? departureFlight;
  final String? airlineID;
  final UtilityResponseData utilityResponseData;
  Flight? arrivalFlight;
  final bool isTwoWay;

  final double totalFare;
  final ServiceList service;

  PassengerDetailScreen({
    super.key,
    required this.adultCount,
    required this.childrenCount,
    required this.departureFlight,
    this.arrivalFlight,
    required this.service,
    required this.totalFare,
    required this.utilityResponseData,
    this.airlineID,
    required this.isTwoWay,
  });
  final adultCount;
  final childrenCount;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => UtilityPaymentCubit(
                utilityPaymentRepository:
                    RepositoryProvider.of<UtilityPaymentRepository>(context),
              ),
        ),
      ],
      child: PassengerDetailWidget(
        isTwoWay: isTwoWay,
        airlineID: airlineID,
        totalFare: totalFare,
        service: service,
        adultCount: adultCount,
        departureFlight: departureFlight,
        arrivalFlight: arrivalFlight,
        childrenCount: childrenCount,
      ),
    );
  }
}
