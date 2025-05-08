import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/utils/file_download_utils.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/custom_cached_network_image.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/key_value_tile.dart';
import 'package:ismart_web/features/history/models/recent_transaction_model.dart';
import 'package:ismart_web/features/history/widget/transaction_detail_widget.dart';

class TransactionDetailAlertWidget extends StatefulWidget {
  final RecentTransactionModel recentTransactionModel;
  final ValueNotifier<String> downloadUrlNotifier;
  const TransactionDetailAlertWidget({
    Key? key,
    required this.recentTransactionModel,
    required this.downloadUrlNotifier,
  }) : super(key: key);

  @override
  State<TransactionDetailAlertWidget> createState() =>
      _TransactionDetailAlertWidgetState();
}

class _TransactionDetailAlertWidgetState
    extends State<TransactionDetailAlertWidget> {
  String? downloadUrl;
  @override
  Widget build(BuildContext context) {
    final e = widget.recentTransactionModel;
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final _height = SizeUtils.height;
    return RepositoryProvider.of<CoOperative>(
              NavigationService.context,
            ).clientCode ==
            "EHVNI7CZJ3"
        ? Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: CustomTheme.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.recentTransactionModel.service,
                        style: _textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "${widget.recentTransactionModel.date.year}-${widget.recentTransactionModel.date.month}-${widget.recentTransactionModel.date.day}",
                        style: _textTheme.titleSmall!.copyWith(
                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    child: CustomCachedNetworkImage(
                      url:
                          RepositoryProvider.of<CoOperative>(context).baseUrl +
                          e.iconUrl,
                      fit: BoxFit.contain,
                      height: 60.hp,
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder:
                        (context) => [
                          PopupMenuItem(
                            child: Container(child: const Text("hello1")),
                          ),
                          PopupMenuItem(
                            child: Container(child: const Text("hello1")),
                          ),
                        ],
                  ),
                ],
              ),
              SizedBox(height: _height * 0.01),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: const Color(0xFFF3F3F3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Billing Details",
                      style: _textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: _height * 0.01),
                    KeyValueTile(
                      title: "Transaction ID",
                      value:
                          widget.recentTransactionModel.transactionIdentifier
                              .toString(),
                    ),
                    e.requestDetail.destinationAccountName != null
                        ? Column(
                          children: [
                            KeyValueTile(
                              title: "Receiver Name",
                              value:
                                  e.requestDetail.destinationAccountName
                                      .toString(),
                            ),
                            KeyValueTile(
                              title: "Receiver Bank Name",
                              value:
                                  e.requestDetail.destinationBankName
                                      .toString(),
                            ),
                            KeyValueTile(
                              title: "Receiver Account Number",
                              value:
                                  e.requestDetail.destinationAccountNumber
                                      .toString(),
                            ),
                          ],
                        )
                        : KeyValueTile(
                          // title: "Username",
                          title: "Service To",
                          value:
                              widget.recentTransactionModel.serviceTo
                                  .toString(),
                        ),
                    KeyValueTile(
                      title: "Channel",
                      value:
                          widget.recentTransactionModel.channelType
                                      .toString()
                                      .toLowerCase() ==
                                  "GPRS".toLowerCase()
                              ? "Online"
                              : "SMS",
                    ),
                    KeyValueTile(
                      isRedColor:
                          widget.recentTransactionModel.status.toLowerCase() ==
                                  "Complete".toLowerCase()
                              ? false
                              : true,
                      title: "Status",
                      value: widget.recentTransactionModel.status.toString(),
                    ),
                    KeyValueTile(
                      title: "Amount",
                      value:
                          widget.recentTransactionModel.totalAmount.toString(),
                    ),
                    KeyValueTile(
                      title: "Charge",
                      value: widget.recentTransactionModel.charge.toString(),
                    ),
                    KeyValueTile(
                      title: "Total Amount",
                      value:
                          widget.recentTransactionModel.totalAmount.toString(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.hp),
              CustomRoundedButtom(
                title: "View More",
                onPressed: () {
                  NavigationService.push(
                    target: TransactionDetailWidget(
                      recentTransactionModel: widget.recentTransactionModel,
                      downloadUrlNotifier: widget.downloadUrlNotifier,
                    ),
                  );
                },
              ),
              SizedBox(height: 10.hp),
              ValueListenableBuilder<String>(
                valueListenable: widget.downloadUrlNotifier,
                builder: (context, val, _) {
                  if (val.isNotEmpty) {
                    return CustomRoundedButtom(
                      title: "Download Receipt",
                      verticalPadding: 10,
                      icon: Icons.file_download_outlined,
                      onPressed: () {
                        FileDownloadUtils.downloadFile(
                          downloadLink: widget.downloadUrlNotifier.value,
                          fileName: FileDownloadUtils.generateDownloadFileName(
                            name: widget.recentTransactionModel.service,
                            filetype: FileType.pdf,
                          ),
                          context: context,
                        );
                        widget.downloadUrlNotifier.value = "";
                        NavigationService.pop();
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        )
        : Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: CustomTheme.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.recentTransactionModel.service,
                        style: _textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "${widget.recentTransactionModel.date.year}-${widget.recentTransactionModel.date.month}-${widget.recentTransactionModel.date.day}",
                        style: _textTheme.titleSmall!.copyWith(
                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    child: CustomCachedNetworkImage(
                      url:
                          RepositoryProvider.of<CoOperative>(context).baseUrl +
                          e.iconUrl,
                      fit: BoxFit.contain,
                      height: 60.hp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: _height * 0.01),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: const Color(0xFFF3F3F3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Billing Details",
                      style: _textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: _height * 0.01),
                    KeyValueTile(
                      title: "Transaction ID",
                      value:
                          widget.recentTransactionModel.transactionIdentifier
                              .toString(),
                    ),
                    e.requestDetail.destinationAccountName != null
                        ? Column(
                          children: [
                            KeyValueTile(
                              title: "Receiver Name",
                              value:
                                  e.requestDetail.destinationAccountName
                                      .toString(),
                            ),
                            KeyValueTile(
                              title: "Receiver Bank Name",
                              value:
                                  e.requestDetail.destinationBankName
                                      .toString(),
                            ),
                            KeyValueTile(
                              title: "Receiver Account Number",
                              value:
                                  e.requestDetail.destinationAccountNumber
                                      .toString(),
                            ),
                          ],
                        )
                        : KeyValueTile(
                          // title: "Username",
                          title: "Service To",
                          value:
                              widget.recentTransactionModel.serviceTo
                                  .toString(),
                        ),
                    KeyValueTile(
                      title: "Channel",
                      value:
                          widget.recentTransactionModel.channelType
                                      .toString()
                                      .toLowerCase() ==
                                  "GPRS".toLowerCase()
                              ? "Online"
                              : "SMS",
                    ),
                    KeyValueTile(
                      useCustomColor: true,
                      isRedColor:
                          widget.recentTransactionModel.status.toLowerCase() ==
                                  "Complete".toLowerCase()
                              ? false
                              : true,
                      title: "Status",
                      value: widget.recentTransactionModel.status.toString(),
                    ),
                    KeyValueTile(
                      title: "Amount",
                      value:
                          widget.recentTransactionModel.totalAmount.toString(),
                    ),
                    KeyValueTile(
                      title: "Charge",
                      value: widget.recentTransactionModel.charge.toString(),
                    ),
                    KeyValueTile(
                      title: "Total Amount",
                      value:
                          widget.recentTransactionModel.totalAmount.toString(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.hp),
              CustomRoundedButtom(
                title: "View More",
                onPressed: () {
                  NavigationService.push(
                    target: TransactionDetailWidget(
                      recentTransactionModel: widget.recentTransactionModel,
                      downloadUrlNotifier: widget.downloadUrlNotifier,
                    ),
                  );
                },
              ),
              SizedBox(height: 10.hp),
              ValueListenableBuilder<String>(
                valueListenable: widget.downloadUrlNotifier,
                builder: (context, val, _) {
                  if (val.isNotEmpty) {
                    return CustomRoundedButtom(
                      title: "Download Receipt",
                      verticalPadding: 10,
                      icon: Icons.file_download_outlined,
                      onPressed: () {
                        FileDownloadUtils.downloadFile(
                          downloadLink: widget.downloadUrlNotifier.value,
                          fileName: FileDownloadUtils.generateDownloadFileName(
                            name: widget.recentTransactionModel.service,
                            filetype: FileType.pdf,
                          ),
                          context: context,
                        );
                        widget.downloadUrlNotifier.value = "";
                        NavigationService.pop();
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        );
  }
}
