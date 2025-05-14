import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/tvPayment/resources/tv_detail_model.dart';
import 'package:ismart_web/features/categoryWiseService/tvPayment/widget/tv_payment_detail_widget.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class TvPaymentDeatilPage extends StatelessWidget {
  final String amount;
  final String customerID;
  final ServiceList service;

  final TvDetailModel detailFetchData;

  const TvPaymentDeatilPage({
    super.key,
    required this.detailFetchData,
    required this.service,
    required this.amount,
    required this.customerID,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => UtilityPaymentCubit(
            utilityPaymentRepository:
                RepositoryProvider.of<UtilityPaymentRepository>(context),
          ),
      child: TvPaymentDeatilWidget(
        amount: amount,
        userName: customerID,
        detailFetchData: detailFetchData,
        service: service,
      ),
    );
  }
}
