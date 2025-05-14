import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/internet/cg/widgets/cg_payment_inquiry_widget.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class CgPaymentInquiryScreen extends StatelessWidget {
  final ServiceList service;

  final UtilityResponseData detailFetchData;
  final String userId;

  const CgPaymentInquiryScreen({
    super.key,
    required this.detailFetchData,
    required this.service,
    required this.userId,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => UtilityPaymentCubit(
            utilityPaymentRepository:
                RepositoryProvider.of<UtilityPaymentRepository>(context),
          ),
      child: CgPaymentInquiryWidget(
        detailFetchData: detailFetchData,
        service: service,
        userId: userId,
      ),
    );
  }
}
