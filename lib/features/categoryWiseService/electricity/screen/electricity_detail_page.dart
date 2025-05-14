import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/electricity/widget/electricity_detail_widget.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class ElectricityDetailPage extends StatelessWidget {
  const ElectricityDetailPage({
    super.key,
    required this.useServiceResponse,
    required this.counterName,
    required this.customerId,
    required this.scNumber,
    required this.services,
    required this.counterCode,
  });

  final UtilityResponseData useServiceResponse;
  final String counterName;
  final String customerId;
  final String scNumber;
  final ServiceList services;
  final String counterCode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => UtilityPaymentCubit(
            utilityPaymentRepository:
                RepositoryProvider.of<UtilityPaymentRepository>(context),
          ),
      child: ElectricityDetailsWidgets(
        useServiceResponse: useServiceResponse,
        counterCode: counterCode,
        counterName: counterName,
        customerId: customerId,
        scNumber: scNumber,
        service: services,
      ),
    );
  }
}
