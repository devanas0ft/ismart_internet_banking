import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/utils/file_download_utils.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/custom_cached_network_image.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/screen_appbar.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/history/models/recent_transaction_model.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class TransactionDetailPage extends StatelessWidget {
  final RecentTransactionModel recentTransactionModel;
  final ValueNotifier<String> downloadUrlNotifier;
  const TransactionDetailPage({
    super.key,
    required this.recentTransactionModel,
    required this.downloadUrlNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => UtilityPaymentCubit(
            utilityPaymentRepository:
                RepositoryProvider.of<UtilityPaymentRepository>(context),
          ),
      child: TransactionDetailWidget(
        downloadUrlNotifier: downloadUrlNotifier,
        recentTransactionModel: recentTransactionModel,
      ),
    );
  }
}

class TransactionDetailWidget extends StatefulWidget {
  final RecentTransactionModel recentTransactionModel;
  final ValueNotifier<String> downloadUrlNotifier;
  const TransactionDetailWidget({
    Key? key,
    required this.recentTransactionModel,
    required this.downloadUrlNotifier,
  }) : super(key: key);

  @override
  State<TransactionDetailWidget> createState() =>
      _TransactionDetailWidgetState();
}

class _TransactionDetailWidgetState extends State<TransactionDetailWidget> {
  String? downloadUrl;
  @override
  void initState() {
    context.read<UtilityPaymentCubit>().fetchDetails(
      serviceIdentifier: "",
      accountDetails: {
        "tranId": widget.recentTransactionModel.transactionIdentifier,
      },
      apiEndpoint: "/api/movie/ticket/download",
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final e = widget.recentTransactionModel;
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final r = widget.recentTransactionModel;
    return PageWrapper(
      padding: EdgeInsets.zero,
      backgroundColor: CustomTheme.white,
      showAppBar: false,
      body: SafeArea(
        child: Column(
          children: [
            const ScreenAppBar(title: "Transaction Detail"),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r.service,
                              style: _textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              r.date.toString(),
                              style: _textTheme.titleSmall,
                            ),
                            Text(
                              "Transaction ID : " +
                                  r.transactionIdentifier.toString(),
                              style: _textTheme.titleSmall,
                            ),
                            Text(
                              r.status,
                              style: _textTheme.titleSmall!.copyWith(
                                color:
                                    r.status == "Complete"
                                        ? CustomTheme.green
                                        : CustomTheme.googleColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: CustomCachedNetworkImage(
                            fit: BoxFit.cover,
                            height: 50.hp,
                            url:
                                RepositoryProvider.of<CoOperative>(
                                  context,
                                ).baseUrl +
                                r.iconUrl,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        r.service == "Movie"
                            ? BlocBuilder<UtilityPaymentCubit, CommonState>(
                              builder: (context, state) {
                                if (state
                                    is CommonStateSuccess<
                                      UtilityResponseData
                                    >) {
                                  final ticketUrl = state.data.findValueString(
                                    'ticketUrl',
                                  );
                                  final movieTicketPdfUrl =
                                      RepositoryProvider.of<CoOperative>(
                                        context,
                                      ).baseUrl +
                                      ticketUrl;

                                  return InkWell(
                                    onTap: () {
                                      FileDownloadUtils.downloadFile(
                                        downloadLink: movieTicketPdfUrl,
                                        fileName:
                                            FileDownloadUtils.generateDownloadFileName(
                                              name:
                                                  widget
                                                      .recentTransactionModel
                                                      .service,
                                              filetype: FileType.pdf,
                                            ),
                                        context: context,
                                      );
                                      widget.downloadUrlNotifier.value = "";
                                      NavigationService.pop();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _theme.primaryColor.withOpacity(
                                          0.05,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            Assets.downloadIcon,
                                            height: 25.hp,
                                          ),
                                          Text(
                                            "   Ticket   ",
                                            style: _textTheme.titleSmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            )
                            : ValueListenableBuilder<String>(
                              valueListenable: widget.downloadUrlNotifier,
                              builder: (context, val, _) {
                                if (val.isNotEmpty) {
                                  return InkWell(
                                    onTap: () {
                                      FileDownloadUtils.downloadFile(
                                        downloadLink:
                                            widget.downloadUrlNotifier.value,
                                        fileName:
                                            FileDownloadUtils.generateDownloadFileName(
                                              name:
                                                  widget
                                                      .recentTransactionModel
                                                      .service,
                                              filetype: FileType.pdf,
                                            ),
                                        context: context,
                                      );
                                      widget.downloadUrlNotifier.value = "";
                                      NavigationService.pop();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _theme.primaryColor.withOpacity(
                                          0.05,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            Assets.downloadIcon,
                                            height: 25.hp,
                                          ),
                                          Text(
                                            "Download",
                                            style: _textTheme.titleSmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                        SizedBox(width: 20.wp),
                        InkWell(
                          onTap: () {
                            showPopUpDialog(
                              context: context,
                              title: "Report Issue !",
                              message:
                                  "Are your sure you want to report this transaction ?",
                              buttonCallback: () {
                                // NavigationService.pushReplacement(
                                //     target: FeedBackPage(
                                //   transactionId: r.transactionIdentifier,
                                // ));
                              },
                              buttonText: "Yes",
                            );
                          },
                          child: Container(
                            width: 80.wp,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _theme.primaryColor.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  Assets.feedBackIcon,
                                  height: 25.hp,
                                ),
                                Text("Report", style: _textTheme.titleSmall),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Text(
                    "Destination",
                    style: _textTheme.titleSmall!.copyWith(
                      color: CustomTheme.darkGray,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    r.destination,
                    style: _textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.hp),
                  GridView(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1 / 0.3,
                        ),
                    children: [
                      customKeyValue(title: "Service", value: r.service),
                      customKeyValue(
                        title: "From Account",
                        value: r.accountNumber,
                      ),
                      customKeyValue(
                        title: "Charge",
                        value: r.charge.toString(),
                      ),
                      customKeyValue(
                        title: "Total Amt",
                        value: r.totalAmount.toString(),
                      ),
                      customKeyValue(
                        title: "Type",
                        value: r.debit == true ? "Debited" : "Credited",
                      ),
                      customKeyValue(
                        title: "Channel",
                        value:
                            widget.recentTransactionModel.channelType
                                        .toString()
                                        .toLowerCase() ==
                                    "GPRS".toLowerCase()
                                ? "Online"
                                : "SMS",
                      ),
                      customKeyValue(
                        title: "Remarks",
                        value:
                            widget
                                    .recentTransactionModel
                                    .customerRemarks
                                    .isEmpty
                                ? "-"
                                : widget.recentTransactionModel.customerRemarks,
                      ),
                      if (r.requestDetail.customerAddress != null)
                        customKeyValue(
                          title: "Address",
                          value: r.requestDetail.customerAddress.toString(),
                        ),
                      if (r.requestDetail.destinationAccountName != null)
                        customKeyValue(
                          title: "Destination Name",
                          value:
                              r.requestDetail.destinationAccountName.toString(),
                        ),
                      if (r.requestDetail.destinationBankName != null)
                        customKeyValue(
                          title: "Destination Bank",
                          value: r.requestDetail.destinationBankName.toString(),
                        ),
                      if (r.requestDetail.destinationAccountNumber != null)
                        customKeyValue(
                          title: "Destination Account",
                          value:
                              r.requestDetail.destinationAccountNumber
                                  .toString(),
                        ),
                      if (r.requestDetail.mobileNumber != null)
                        customKeyValue(
                          title: "Mobile Number",
                          value: r.requestDetail.mobileNumber.toString(),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  customKeyValue({required String title, required String value}) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleSmall!.copyWith(
            color: CustomTheme.darkGray,
            fontSize: 11,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
// PageWrapper(
//             body: CommonContainer(
//               verticalPadding: 0,
//               buttonName: "Close",
//               onButtonPressed: () {
//                 NavigationService.pop();
//               },
//               showDetail: false,
//               showTitleText: false,
//               topbarName: "Transaction Detail",
//               body: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         children: [
//                           Text(
//                             widget.recentTransactionModel.service,
//                             style: _textTheme.displaySmall!
//                                 .copyWith(fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             "${widget.recentTransactionModel.date.year}-${widget.recentTransactionModel.date.month}-${widget.recentTransactionModel.date.day}",
//                             style: _textTheme.titleLarge,
//                           ),
//                         ],
//                       ),
//                       CustomCachedNetworkImage(
//                         fit: BoxFit.cover,
//                         height: 50.hp,
//                         url: RepositoryProvider.of<CoOperative>(context)
//                                 .baseUrl +
//                             widget.recentTransactionModel.iconUrl,
//                       )
//                     ],
//                   ),
//                   SizedBox(height: 15.hp),
//                   Container(
//                     padding: const EdgeInsets.all(18),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(18),
//                         color: const Color(0xFFF3F3F3)),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Billing Details",
//                           style: _textTheme.titleSmall!
//                               .copyWith(fontWeight: FontWeight.w700),
//                         ),
//                         SizedBox(height: _height * 0.01),
//                         KeyValueTile(
//                           title: "Amount",
//                           value: widget.recentTransactionModel.totalAmount
//                               .toString(),
//                         ),
//                         KeyValueTile(
//                           title: "Charge",
//                           value:
//                               widget.recentTransactionModel.charge.toString(),
//                         ),
//                         KeyValueTile(
//                           title: "Total Amount",
//                           value: widget.recentTransactionModel.totalAmount
//                               .toString(),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(18),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(18),
//                         color: const Color(0xFFF3F3F3)),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Sender Details",
//                           style: _textTheme.titleSmall!
//                               .copyWith(fontWeight: FontWeight.w700),
//                         ),
//                         SizedBox(height: _height * 0.01),
//                         KeyValueTile(
//                           title: "Account Number",
//                           value: widget.recentTransactionModel.accountNumber
//                               .toString(),
//                         ),
//                         KeyValueTile(
//                           title: "Transaction ID",
//                           value: widget
//                               .recentTransactionModel.transactionIdentifier
//                               .toString(),
//                         ),
//                         KeyValueTile(
//                           title: "Channel",
//                           value: widget.recentTransactionModel.channelType
//                                       .toString()
//                                       .toLowerCase() ==
//                                   "GPRS".toLowerCase()
//                               ? "Online"
//                               : "SMS",
//                         ),
//                         KeyValueTile(
//                           useCustomColor: true,
//                           isRedColor: widget.recentTransactionModel.status
//                                       .toLowerCase() ==
//                                   "Complete".toLowerCase()
//                               ? false
//                               : true,
//                           title: "Status",
//                           value:
//                               widget.recentTransactionModel.status.toString(),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 10.hp),
//                   Container(
//                     padding: const EdgeInsets.all(18),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(18),
//                         color: const Color(0xFFF3F3F3)),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Receiver Details",
//                           style: _textTheme.titleSmall!
//                               .copyWith(fontWeight: FontWeight.w700),
//                         ),
//                         SizedBox(height: _height * 0.01),
//                         if (e.requestDetail.destinationAccountName != null)
//                           Column(
//                             children: [
//                               KeyValueTile(
//                                   title: "Name",
//                                   value: e.requestDetail.destinationAccountName
//                                       .toString()),
//                               KeyValueTile(
//                                   title: "Account Number",
//                                   value: e
//                                       .requestDetail.destinationAccountNumber
//                                       .toString()),
//                               KeyValueTile(
//                                   title: "Bank Name",
//                                   value: e.requestDetail.destinationBankName
//                                       .toString()),

//                               // this.amount,
//                               // this.mobileNumber,
//                               // this.serviceId,
//                               // this.serviceTo,
//                             ],
//                           ),
//                         if (e.requestDetail.customerAddress != null)
//                           KeyValueTile(
//                               title: "Address",
//                               value:
//                                   e.requestDetail.customerAddress.toString()),
//                         if (e.requestDetail.serviceId != null)
//                           KeyValueTile(
//                               title: "Service Id",
//                               value: e.requestDetail.serviceId.toString()),
//                         if (e.requestDetail.mobileNumber != null)
//                           KeyValueTile(
//                               title: "Mobile Number",
//                               value: e.requestDetail.mobileNumber.toString()),
//                         if (e.requestDetail.serviceTo != null)
//                           KeyValueTile(
//                               title: "Service To",
//                               value: e.requestDetail.serviceTo.toString()),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   ValueListenableBuilder<String>(
//                       valueListenable: widget.downloadUrlNotifier,
//                       builder: (context, val, _) {
//                         if (val.isNotEmpty) {
//                           return CustomRoundedButtom(
//                               title: "Download Receipt",
//                               verticalPadding: 10,
//                               icon: Icons.file_download_outlined,
//                               onPressed: () {
//                                 FileDownloadUtils.downloadFile(
//                                   downloadLink:
//                                       widget.downloadUrlNotifier.value,
//                                   fileName: FileDownloadUtils
//                                       .generateDownloadFileName(
//                                     name: widget.recentTransactionModel.service,
//                                     filetype: FileType.pdf,
//                                   ),
//                                   context: context,
//                                 );
//                                 widget.downloadUrlNotifier.value = "";
//                                 NavigationService.pop();
//                               });
//                         } else {
//                           return Container();
//                         }
//                       }),
//                 ],
//               ),
//             ),
//           );
