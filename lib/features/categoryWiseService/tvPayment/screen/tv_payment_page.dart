import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/tvPayment/resources/tv_payment_cubit.dart';
import 'package:ismart_web/features/categoryWiseService/tvPayment/resources/tv_payment_repository.dart';
import 'package:ismart_web/features/categoryWiseService/tvPayment/widget/tv_payment_widget.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class TvPaymentPage extends StatelessWidget {
  final ServiceList service;
  const TvPaymentPage({Key? key, required this.service}) : super(key: key);
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
        BlocProvider(
          create:
              (context) => TvPaymentCubit(
                tvPaymentRepository: RepositoryProvider.of<TvPaymentRepository>(
                  context,
                ),
              ),
        ),
      ],
      child: TvPaymentWidget(service: service),
    );
  }
}
