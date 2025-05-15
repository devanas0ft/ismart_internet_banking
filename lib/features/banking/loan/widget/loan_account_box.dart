import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/no_data_screen.dart';
import 'package:ismart_web/features/banking/loan/widget/loan_account_list_popuo.dart';
import 'package:ismart_web/features/customerDetail/model/customer_detail_model.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';

class LoanAccountBox extends StatefulWidget {
  final Function(String accountNumber)? onPressed;

  const LoanAccountBox({super.key, this.onPressed});

  @override
  State<LoanAccountBox> createState() => _LoanAccountBoxState();
}

class _LoanAccountBoxState extends State<LoanAccountBox> {
  bool showAmount = true;

  @override
  Widget build(BuildContext context) {
    final _customerDetailRepo = RepositoryProvider.of<CustomerDetailRepository>(
      context,
    );
    final _height = SizeUtils.height;
    final _width = SizeUtils.width;
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    return ValueListenableBuilder<AccountDetail?>(
      valueListenable: _customerDetailRepo.selectedAccount,
      builder: (context, selectedAccount, _) {
        return ValueListenableBuilder<CustomerDetailModel?>(
          valueListenable: _customerDetailRepo.customerDetailModel,
          builder: (context, val, _) {
            if (val != null) {
              final showValidAccount = val.accountDetail.firstWhere(
                (element) =>
                    element.accountType.toLowerCase() == "loan" ||
                    element.accountType.toLowerCase() == "od",
              );
              return InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => LoanAccountDetailPopUpBox(
                          onPressed: widget.onPressed,
                        ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  padding: const EdgeInsets.all(18),
                  width: double.infinity,
                  height: _height * 0.15,
                  decoration: BoxDecoration(
                    color: _theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _theme.scaffoldBackgroundColor,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/Banking.svg",
                            height: 30.hp,
                            color: _theme.primaryColor,
                          ),
                          SizedBox(width: _width * 0.03),
                          Expanded(
                            child: Text(
                              showValidAccount.accountTypeDescription ??
                                  showValidAccount.accountType,
                              maxLines: 2,
                              style: _theme.textTheme.headlineSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/Account Number.svg",
                            height: 30.hp,
                            color: _theme.primaryColor,
                          ),
                          SizedBox(width: _width * 0.03),
                          Expanded(
                            child: Text(
                              "${showValidAccount.mainCode}",
                              style: _textTheme.headlineSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          RotatedBox(
                            quarterTurns: 5,
                            child: SvgPicture.asset(
                              Assets.arrowRight,
                              height: _height * 0.02,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const NoDataScreen(
                title: "No Loan Account Found.",
                details: "No loan account was found.",
              );
            }
          },
        );
      },
    );
  }
}
