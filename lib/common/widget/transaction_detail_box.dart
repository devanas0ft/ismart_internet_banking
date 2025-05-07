import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/constants/env.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/custom_cached_network_image.dart';
import 'package:ismart_web/features/history/models/recent_transaction_model.dart';

class TransactionDetailBox extends StatelessWidget {
  final RecentTransactionModel recentTransactionModel;
  final VoidCallback? onClickAction;
  const TransactionDetailBox({
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
                      recentTransactionModel.date.toString(),
                      style: _textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
              SizedBox(width: _width * 0.05),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "NPR ${recentTransactionModel.totalAmount}",
                    style: TextStyle(
                      fontFamily: "popinsemibold",
                      fontSize: 12,
                      color:
                          (recentTransactionModel.status
                                          .toString()
                                          .toLowerCase() ==
                                      "complete" ||
                                  recentTransactionModel.status
                                          .toString()
                                          .toLowerCase() ==
                                      "approved")
                              ? Colors.green
                              : Colors.red,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color:
                          (recentTransactionModel.status
                                          .toString()
                                          .toLowerCase() ==
                                      "complete" ||
                                  recentTransactionModel.status
                                          .toString()
                                          .toLowerCase() ==
                                      "approved")
                              ? Colors.green
                              : Colors.red,
                    ),
                    padding: EdgeInsets.all(4),
                    child: Center(
                      child: Text(
                        recentTransactionModel.status,
                        style: TextStyle(
                          fontFamily: "popinsemibold",
                          color: CustomTheme.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
