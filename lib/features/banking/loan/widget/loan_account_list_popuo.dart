import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/features/customerDetail/model/customer_detail_model.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';

class LoanAccountDetailPopUpBox extends StatefulWidget {
  final Function(String accountNumber)? onPressed;

  const LoanAccountDetailPopUpBox({super.key, this.onPressed});

  @override
  State<LoanAccountDetailPopUpBox> createState() =>
      _LoanAccountDetailPopUpBoxState();
}

class _LoanAccountDetailPopUpBoxState extends State<LoanAccountDetailPopUpBox> {
  @override
  Widget build(BuildContext context) {
    final _customerDetailRepo = RepositoryProvider.of<CustomerDetailRepository>(
      context,
    );
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final _width = SizeUtils.width;

    return ValueListenableBuilder<AccountDetail?>(
      valueListenable: _customerDetailRepo.selectedAccount,
      builder: (context, selectedAccount, _) {
        return ValueListenableBuilder<CustomerDetailModel?>(
          valueListenable: _customerDetailRepo.customerDetailModel,
          builder: (context, val, _) {
            if (val != null) {
              final List showValidAccount =
                  val.accountDetail
                      .where(
                        (element) =>
                            element.accountType.toLowerCase() == "loan" ||
                            element.accountType.toLowerCase() == "od",
                      )
                      .toList();
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(18),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: CustomTheme.white,
                      border: Border.all(color: Colors.black45),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: showValidAccount.length,
                      itemBuilder: (context, index) {
                        final AccountDetail account = showValidAccount[index];

                        final _isSelectedAccount = account.accountNumber
                            .toLowerCase()
                            .contains(selectedAccount?.accountNumber ?? "");

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                NavigationService.pop();
                                if (widget.onPressed != null)
                                  widget.onPressed!.call(account.accountNumber);
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                width: double.infinity,
                                height: _width * 0.35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color:
                                        _isSelectedAccount
                                            ? CustomTheme.primaryColor
                                            : CustomTheme.gray,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          Assets.bankingIcon,
                                          height: 25.hp,
                                          color: _theme.primaryColor,
                                        ),
                                        SizedBox(width: _width * 0.03),
                                        Expanded(
                                          child: Text(
                                            account.accountTypeDescription
                                                    .toString()
                                                    .isNotEmpty
                                                ? account.accountType
                                                : account.accountType,
                                            maxLines: 2,
                                            style:
                                                _theme.textTheme.headlineMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          Assets.personIcon,
                                          height: 25.hp,
                                          color: _theme.primaryColor,
                                        ),
                                        SizedBox(width: 5.wp),
                                        Expanded(
                                          child: Text(
                                            account.mainCode,
                                            style: _textTheme.headlineMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            {
              return Container();
            }
          },
        );
      },
    );
  }
}
