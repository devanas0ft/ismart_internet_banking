import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/favourite/editAccount/widget/update_fav_account_widget.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class UpdateFavAccountPage extends StatelessWidget {
  final String? accountNumber;
  final String? accountName;
  final String? bankCode;
  final String? bankName;
  final bool isBankTransfer;
  final String id;

  final String remainderType;
  final String serviceInfoType;
  const UpdateFavAccountPage({
    super.key,
    this.accountNumber,
    this.accountName,
    this.bankCode,
    this.bankName,
    required this.isBankTransfer,
    required this.id,
    required this.remainderType,
    required this.serviceInfoType,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => UtilityPaymentCubit(
            utilityPaymentRepository:
                RepositoryProvider.of<UtilityPaymentRepository>(context),
          ),
      child: UpdateFavAccountWidget(
        remainderType: remainderType,
        serviceInfoType: serviceInfoType,
        id: id,
        accountName: accountName,
        accountNumber: accountNumber,
        bankCode: bankCode,
        bankName: bankName,
        isBankTransfer: isBankTransfer,
      ),
    );
  }
}
