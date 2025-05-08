import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/custom_cached_network_image.dart';
import 'package:ismart_web/features/history/models/recent_transaction_model.dart';

class TransactionDetailBoxService extends StatelessWidget {
  final RecentTransactionModel recentTransactionModel;
  final VoidCallback? onClickAction;
  const TransactionDetailBoxService({
    Key? key,
    this.onClickAction,
    required this.recentTransactionModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final _width = SizeUtils.width;
    final _height = SizeUtils.height;
    return InkWell(
      onTap: () {
        if (onClickAction != null) {
          onClickAction!.call();
        }
      },
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                width: _width * 0.15,
                height: _height * 0.08,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: CustomCachedNetworkImage(
                  url:
                      RepositoryProvider.of<CoOperative>(context).baseUrl +
                      recentTransactionModel.iconUrl.replaceFirst("/", ""),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: _width * 0.05),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recentTransactionModel.service.toString(),
                      style: _textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      recentTransactionModel.destination,
                      style: _textTheme.labelLarge,
                    ),
                    Text(
                      "NPR ${recentTransactionModel.totalAmount}",
                      style: TextStyle(
                        fontFamily: "popinsemibold",
                        fontSize: 12,
                        color:
                            recentTransactionModel.debit
                                ? Colors.red
                                : Colors.green,
                      ),
                    ),
                    Text(
                      recentTransactionModel.status,
                      style: _textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Text(
                    //   recentTransactionModel.date.toString(),
                    //   style: _textTheme.labelLarge,
                    // ),
                  ],
                ),
              ),
              SizedBox(width: _width * 0.05),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.green,
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Center(
                  child: Text(
                    "Pay",
                    style: TextStyle(
                      fontFamily: "popinsemibold",
                      color: CustomTheme.white,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
