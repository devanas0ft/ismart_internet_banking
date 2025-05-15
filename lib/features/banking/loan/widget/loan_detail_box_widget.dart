import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class LoanDetailBoxWidget extends StatelessWidget {
  final UtilityResponseData loanResponse;
  const LoanDetailBoxWidget({Key? key, required this.loanResponse})
    : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Product Name",
                style: _theme.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: CustomTheme.darkerBlack,
                ),
              ),
              Text(
                "${loanResponse.findValueString("product")}",
                style: _theme.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: CustomTheme.darkerBlack,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Account Number",
                style: _theme.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: CustomTheme.darkerBlack,
                ),
              ),
              Text(
                loanResponse.findValueString("accountNumber"),
                style: _theme.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: CustomTheme.darkerBlack,
                ),
              ),
            ],
          ),
          const Divider(thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              detailBox(
                title: "Issued On",
                value: loanResponse.findValueString("issuedOn"),
              ),
              detailBox(
                title: "Matures On",
                value: loanResponse.findValueString("maturesOn"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  detailBox({required String title, required String value}) {
    final theme = Theme.of(NavigationService.context);
    return Column(
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 11,
            color: CustomTheme.darkerBlack,
          ),
        ),
        SizedBox(height: 3.hp),
        Text(
          value,
          style: theme.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 11,
            color: CustomTheme.darkerBlack,
          ),
        ),
      ],
    );
  }
}
