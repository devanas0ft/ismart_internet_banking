import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/categoryWiseService/governmentPayment/ui/widget/gov_place_widget.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class GovPlacePage extends StatelessWidget {
  final String serviceIdentifier;
  final String apiEndpoint;
  final bool isProvince;

  final Map<String, dynamic> accountDetails;
  const GovPlacePage({
    Key? key,
    required this.onBankSelected,
    required this.serviceIdentifier,
    required this.apiEndpoint,
    required this.accountDetails,
    required this.isProvince,
  }) : super(key: key);
  final Function({required String value, required String name}) onBankSelected;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => UtilityPaymentCubit(
            utilityPaymentRepository:
                RepositoryProvider.of<UtilityPaymentRepository>(context),
          ),
      child: GovnPlaceWidget(
        isProvince: isProvince,
        accountDetail: accountDetails,
        serviceIdentifier: serviceIdentifier,
        apiEndpoint: apiEndpoint,
        onBankSelected: onBankSelected,
      ),
    );
  }
}
