import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/favourite/addAccount/widget/add_fav_account_widget.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class AddFavAccountPage extends StatelessWidget {
  final String? accountNumber;
  final String? accountName;
  final String? bankCode;
  final String? bankName;

  const AddFavAccountPage({
    super.key,
    this.accountNumber,
    this.accountName,
    this.bankCode,
    this.bankName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => UtilityPaymentCubit(
            utilityPaymentRepository:
                RepositoryProvider.of<UtilityPaymentRepository>(context),
          ),
      child: AddFavAccountWidget(
        accountName: accountName,
        accountNumber: accountNumber,
        bankCode: bankCode,
        bankName: bankName,
      ),
    );
  }
}
