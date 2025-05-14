import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/internet/cg/widgets/cg_payment_detail_widget.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class CgPaymentDeatilScreen extends StatelessWidget {
  final ServiceList service;

  final UtilityResponseData detailFetchData;

  const CgPaymentDeatilScreen({
    super.key,
    required this.detailFetchData,
    required this.service,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => UtilityPaymentCubit(
            utilityPaymentRepository:
                RepositoryProvider.of<UtilityPaymentRepository>(context),
          ),
      child: CgPaymentDeatilWidget(
        detailFetchData: detailFetchData,
        service: service,
      ),
    );
  }
}
