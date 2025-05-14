import 'package:flutter/material.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/drinkingwater/khanepani/widget/khanepani_detail_widget.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class KhanepaniDetailsPage extends StatelessWidget {
  final UtilityResponseData useServiceResponse;
  final String customerCode;
  final String selectedCounter;
  final ServiceList serivceList;
  final String selectedCounterName;

  const KhanepaniDetailsPage({
    Key? key,
    required this.useServiceResponse,
    required this.customerCode,
    required this.selectedCounter,
    required this.serivceList,
    required this.selectedCounterName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KhanepaniDetailsWidgets(
      selectedCounterName: selectedCounterName,
      customerCode: customerCode,
      service: serivceList,
      selectedCounter: selectedCounter,
      useServiceResponse: useServiceResponse,
    );
  }
}
