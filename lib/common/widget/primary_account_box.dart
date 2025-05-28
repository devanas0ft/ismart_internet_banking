import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/account_list_box.dart';
import 'package:ismart_web/features/customerDetail/model/customer_detail_model.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';

class PrimaryAccountBox extends StatefulWidget {
  final bool? validateMobileBankingStatus;

  const PrimaryAccountBox({super.key, this.validateMobileBankingStatus});

  @override
  State<PrimaryAccountBox> createState() => _PrimaryAccountBoxState();
}

class _PrimaryAccountBoxState extends State<PrimaryAccountBox> {
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
      builder: (context, selectedAcc, _) {
        return InkWell(
          onTap: () {
            showDialog(
              context: context,

              builder:
                  (context) => AccountDetailBox(
                    validateMobileBankingStatus:
                        widget.validateMobileBankingStatus,
                  ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.all(18),
            width: double.infinity,
            height: _height * 0.15,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _theme.primaryColor, width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      Assets.walletIcon,
                      height: _height * 0.023,
                      color: _theme.primaryColor,
                    ),
                    SizedBox(width: _width * 0.03),
                    Text(
                      showAmount
                          ? "XXXXXXX"
                          : "NPR ${selectedAcc?.availableBalance}",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "popinsemibold",
                        color: _theme.primaryColor,
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            showAmount = !showAmount;
                          });
                        },
                        child: Icon(
                          showAmount ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (selectedAcc?.primary.toString() == "true")
                      Container(
                        width: _width * 0.2,
                        height: _width * 0.06,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: _theme.primaryColor,
                        ),
                        child: const Center(
                          child: Text(
                            "Primary",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/Banking.svg",
                      height: _height * 0.023,
                      color: _theme.primaryColor,
                    ),
                    SizedBox(width: _width * 0.03),
                    Expanded(
                      child: Text(
                        (selectedAcc?.accountTypeDescription).toString().isEmpty
                            ? (selectedAcc?.accountNumber ?? "")
                            : "${selectedAcc?.accountTypeDescription}",
                        maxLines: 2,
                        style: _theme.textTheme.labelLarge,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/Account Number.svg",
                      height: _height * 0.023,
                      color: _theme.primaryColor,
                    ),
                    SizedBox(width: _width * 0.03),
                    Text(
                      "${selectedAcc?.mainCode}",
                      style: _textTheme.labelMedium,
                    ),
                    const Spacer(),
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
      },
    );
  }
}
