import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/models/common_contact_model.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/busBooking/widget/bus_bill_detail_widget.dart';
import 'package:ismart_web/features/categoryWiseService/busBooking/widget/bus_topbar_location_box.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class BusBillDetailPage extends StatelessWidget {
  final ServiceList service;
  final UtilityResponseData response;

  final List selectedSeats;
  final String boardingPoint;
  final UserContactModel contactDetail;
  final BusTopBarModel busModel;
  final double totalFare;
  final String remarks;

  final busData;
  const BusBillDetailPage({
    Key? key,
    required this.service,
    this.busData,
    required this.busModel,
    required this.selectedSeats,
    required this.boardingPoint,
    required this.contactDetail,
    required this.response,
    required this.totalFare,
    required this.remarks,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => UtilityPaymentCubit(
            utilityPaymentRepository:
                RepositoryProvider.of<UtilityPaymentRepository>(context),
          ),
      child: BusBillDetailWidget(
        totalFare: totalFare,
        contactDetail: contactDetail,
        boardingPoint: boardingPoint,
        busTopBarModel: busModel,
        selectedSeats: selectedSeats,
        selectedBusData: busData,
        service: service,
        response: response,
        remarks: remarks,
      ),
    );
  }
}
