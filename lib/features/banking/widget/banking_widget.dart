import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/utils/responsive.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/common_gridview_container.dart';
import 'package:ismart_web/common/widget/common_loading_widget.dart';
import 'package:ismart_web/features/appServiceManagement/cubit/app_service_cubit.dart';
import 'package:ismart_web/features/appServiceManagement/model/app_service_management_model.dart';
import 'package:ismart_web/features/banking/balanceInquiry/screen/balance_inquiry_page.dart';
import 'package:ismart_web/features/banking/cheque/screen/cheque_block_page.dart';
import 'package:ismart_web/features/banking/loan/screen/loan_choose_account_widget.dart';
import 'package:ismart_web/features/statement/screen/statement_page.dart';

class BankingWidget extends StatefulWidget {
  const BankingWidget({Key? key}) : super(key: key);

  @override
  State<BankingWidget> createState() => _BankingWidgetState();
}

class _BankingWidgetState extends State<BankingWidget> {
  @override
  void initState() {
    super.initState();
    context.read<AppServiceCubit>().fetchAppService();
  }

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      showDetail: false,
      topbarName: "Banking",
      subTitle: 'Manage your Funds, Loans, and view other Account information.',
      showTitleText: false,
      showRoundBotton: false,
      showBackBotton: false,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            // height: _height * 0.7,
            child: Container(
              child: BlocBuilder<AppServiceCubit, CommonState>(
                builder: (context, state) {
                  if (state
                      is CommonDataFetchSuccess<AppServiceManagementModel>) {
                    final filteredItems =
                        state.data
                            .where(
                              (item) =>
                                  item.uniqueIdentifier
                                      .toString()
                                      .toLowerCase()
                                      .contains("loan_payment".toLowerCase()) &&
                                  item.status.toString().toLowerCase() ==
                                      "Active".toLowerCase(),
                            )
                            .toList();

                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filteredItems.isEmpty ? 4 : itemName.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: Responsive.isDesktop(context) ? 4 : 3,
                      ),
                      itemBuilder:
                          (context, index) => CommonGridViewContainer(
                            onContainerPress: () {
                              NavigationService.push(target: onPress[index]);
                            },
                            margin:
                                Responsive.isDesktop(context)
                                    ? const EdgeInsets.all(24)
                                    : const EdgeInsets.all(8),
                            containerImage: images[index],
                            title: itemName[index],
                          ),
                    );
                  }
                  if (state is CommonLoading) {
                    return const CommonLoadingWidget();
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  final itemName = [
    "Account Info",
    "Balance Inquiry",
    "Statement",
    // "Fund Transfer",
    'Cheque Request',
    'Loan',
  ];
  final images = [
    Assets.accountInfo,
    Assets.balanceInquiry,
    Assets.statement,
    // Assets.sendMoneyRemit,
    Assets.chequeBookIcon,
    Assets.loanIcon,
  ];
  final onPress = <Widget>[
    BalanceInquiryPage(),
    BalanceInquiryPage(),
    StatementPage(),
    ChequeBlocKScreen(),
    ChooseAccountLoanWidget.ChooseLoanAccountWidget(),
  ];
}
