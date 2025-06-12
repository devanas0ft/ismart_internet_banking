import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/features/customerDetail/model/customer_detail_model.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/userAccount/widgets/bank_detail.dart';
import 'package:ismart_web/features/userAccount/widgets/personal_detail.dart';

class UserAccountWidget extends StatefulWidget {
  const UserAccountWidget({super.key});

  @override
  State<UserAccountWidget> createState() => _UserAccountWidgetState();
}

class _UserAccountWidgetState extends State<UserAccountWidget> {
  int activeIndex = 0;
  final List<String> _tabs = ['PERSONAL DETAILS', 'BANK DETAILS'];
  ValueNotifier<CustomerDetailModel?> customerDetail = ValueNotifier(null);
  ValueNotifier<AccountDetail?> selectedAccountNotifier = ValueNotifier(null);
  ValueNotifier<dynamic> accountDetail = ValueNotifier([]);
  String bannerImage = "";
  String? imageUrl;
  String? gender;

  @override
  void initState() {
    super.initState();
    customerDetail =
        RepositoryProvider.of<CustomerDetailRepository>(
          context,
        ).customerDetailModel;
    RepositoryProvider.of<CustomerDetailRepository>(context).accountsList;
    selectedAccountNotifier =
        RepositoryProvider.of<CustomerDetailRepository>(
          context,
        ).selectedAccount;
    bannerImage = RepositoryProvider.of<CoOperative>(context).bannerImage;
  }

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      topbarName: "User Account",
      subTitle: "Manage and view your account",
      showBackBotton: false,
      showRoundBotton: false,

      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),

        child: ValueListenableBuilder(
          valueListenable: selectedAccountNotifier,
          builder: (context, selectAcc, _) {
            return ValueListenableBuilder(
              valueListenable: customerDetail,
              builder: (context, customerDet, _) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Row(
                        children: [
                          ..._tabs.asMap().entries.map((entry) {
                            int index = entry.key;
                            String title = entry.value;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    activeIndex = index;
                                  });
                                },
                                child: _buildTab(title, activeIndex == index),
                              ),
                            );
                          }),
                          Spacer(),
                        ],
                      ),
                    ),
                    Divider(height: 1),
                    const SizedBox(height: 30),
                    if (activeIndex == 0)
                      PersonalDetail(
                        detail: customerDet,
                        selectedAccountNotifier: selectAcc,
                      ),
                    if (activeIndex == 1) BankDetail(accountDetail: selectAcc),
                    // if (activeIndex == 2) AccountDetailWidget(),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildTab(String title, bool isActive) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isActive ? const Color(0xFF1E3A8A) : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isActive ? const Color(0xFF1E3A8A) : const Color(0xFF666666),
        ),
      ),
    );
  }
}
