import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/tvPayment/commonTvPayment/widget/net_tv_payment_widget.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class NetTvPaymentPage extends StatelessWidget {
  final ServiceList service;
  const NetTvPaymentPage({Key? key, required this.service}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => UtilityPaymentCubit(
            utilityPaymentRepository:
                RepositoryProvider.of<UtilityPaymentRepository>(context),
          ),
      child: NetTvPaymentWidget(service: service),
    );
  }
}
