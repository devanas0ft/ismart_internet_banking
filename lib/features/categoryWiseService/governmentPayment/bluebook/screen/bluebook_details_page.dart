import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/categoryWiseService/governmentPayment/bluebook/widget/bluebook_detail_widget.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class BlueBookDetailsPage extends StatelessWidget {
  final UtilityResponseData response;

  const BlueBookDetailsPage({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => UtilityPaymentCubit(
            utilityPaymentRepository:
                RepositoryProvider.of<UtilityPaymentRepository>(context),
          ),
      child: BlueBookDetailWidget(response: response),
    );
  }
}
