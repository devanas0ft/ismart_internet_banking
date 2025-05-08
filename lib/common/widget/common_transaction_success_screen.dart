import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/utils/file_download_utils.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/key_value_tile.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/features/Dahboard/widgets/dashboard_widget.dart';
import 'package:ismart_web/features/Dahboard/widgets/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/model/airlines_avliable_list_model.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/widgets/flight_detail_box.dart';
import 'package:ismart_web/features/history/cubit/receipt_download_cubit.dart';
import 'package:ismart_web/features/history/resources/recent_transaction_repository.dart';

class CommonTransactionSuccessPage extends StatelessWidget {
  final Widget body;
  final String message;
  final ServiceList? service;
  final String transactionID;
  final String? pdfUrl;
  final Flight? departure;
  final Flight? arrival;
  final String serviceName;

  const CommonTransactionSuccessPage({
    super.key,
    required this.body,
    required this.message,
    this.service,
    required this.transactionID,
    this.pdfUrl,
    this.departure,
    this.arrival,
    required this.serviceName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => TransactionDownloadCubit(
            recentTransactionRepository:
                RepositoryProvider.of<RecentTransactionRepository>(context),
          )..generateUrl(transactionId: transactionID),
      child: CommonTransactionSuccessfulWidget(
        body: body,
        arrival: arrival,
        departure: departure,
        transactionID: transactionID,
        message: message,
        service: service,
        serviceName: serviceName,
      ),
    );
  }
}

class CommonTransactionSuccessfulWidget extends StatefulWidget {
  final Widget body;
  final String message;
  final String transactionID;
  final String? pdfUrl;
  final Flight? departure;
  final Flight? arrival;
  final String serviceName;

  final ServiceList? service;
  const CommonTransactionSuccessfulWidget({
    super.key,
    required this.body,
    required this.message,
    required this.service,
    required this.transactionID,
    this.pdfUrl,
    this.departure,
    this.arrival,
    required this.serviceName,
  });

  @override
  State<CommonTransactionSuccessfulWidget> createState() =>
      _CommonTransactionSuccessfulWidgetState();
}

class _CommonTransactionSuccessfulWidgetState
    extends State<CommonTransactionSuccessfulWidget> {
  String? phoneNumber;
  getUserPhoneNumber() async {
    // final number = await SecureStorageService.appPhoneNumber;
    final number = '9813894737';
    phoneNumber = number;
    setState(() {});
    return number;
  }

  @override
  void initState() {
    getUserPhoneNumber();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _height = SizeUtils.height;
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;

    return PageWrapper(
      showAppBar: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: CustomTheme.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SvgPicture.asset(
                      Assets.successIcon,
                      height: _height * 0.08,
                    ),
                    SizedBox(height: _height * 0.02),
                    const Text(
                      "Transaction Successful",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: _height * 0.02),
                    Text(
                      widget.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SizedBox(height: _height * 0.02),
                    const Divider(thickness: 1),
                    SizedBox(height: _height * 0.02),
                    (widget.service?.uniqueIdentifier ?? "") == "ARS"
                        ? Column(
                          children: [
                            Text(
                              "Departure Flight Details",
                              style: _textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 5.hp),
                            FlightDetailBox(flight: widget.departure),
                            SizedBox(height: 10.hp),
                            if (widget.arrival != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Return Flight Details",
                                    style: _textTheme.titleSmall!.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 5.hp),
                                  FlightDetailBox(flight: widget.arrival),
                                ],
                              ),
                          ],
                        )
                        : Container(
                          padding: const EdgeInsets.all(12),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xFFF3F3F3),
                            // border: Border.all(color: Colors.black),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Paymet Details",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              SizedBox(height: _height * 0.01),
                              KeyValueTile(
                                title: "Transaction ID",
                                value: widget.transactionID,
                              ),
                              KeyValueTile(
                                title: "Initiator(Mobile Number)",
                                value: phoneNumber ?? "",
                              ),
                              KeyValueTile(
                                title: "Date Time",
                                value: DateFormat(
                                  'EEEE, MMM d, HH:mm',
                                ).format(DateTime.now()),
                              ),
                              KeyValueTile(
                                title: "Service",
                                value:
                                    widget.service?.service ??
                                    (widget.serviceName),
                              ),
                              widget.body,
                            ],
                          ),
                        ),
                    SizedBox(height: _height * 0.02),
                    CustomRoundedButtom(
                      title: "Done",
                      onPressed: () {
                        NavigationService.pushUntil(target: DashboardWidget());
                      },
                    ),
                    SizedBox(height: _height * 0.02),
                    widget.pdfUrl == null
                        ? BlocConsumer<TransactionDownloadCubit, CommonState>(
                          listener: (context, state) {},
                          builder: (context, state) {
                            if (state is CommonStateSuccess<String>) {
                              return CustomRoundedButtom(
                                borderColor: Theme.of(context).primaryColor,
                                textColor: Theme.of(context).primaryColor,
                                title: "Download Receipt",
                                color: Colors.transparent,
                                onPressed: () {
                                  FileDownloadUtils.downloadFile(
                                    downloadLink: state.data,
                                    fileName:
                                        FileDownloadUtils.generateDownloadFileName(
                                          name:
                                              widget
                                                  .service
                                                  ?.serviceCategoryName ??
                                              "Utility_Payment",
                                          filetype: FileType.pdf,
                                        ),
                                    context: context,
                                  );
                                },
                              );
                            } else {
                              return Container();
                            }
                          },
                        )
                        : CustomRoundedButtom(
                          borderColor: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).primaryColor,
                          title: "Download Receipt",
                          color: Colors.transparent,
                          onPressed: () {
                            print(widget.pdfUrl.toString());
                            FileDownloadUtils.downloadFile(
                              downloadLink: widget.pdfUrl.toString(),
                              fileName:
                                  FileDownloadUtils.generateDownloadFileName(
                                    name:
                                        widget.service?.serviceCategoryName ??
                                        "Utility_Payment",
                                    filetype: FileType.pdf,
                                  ),
                              context: context,
                            );
                          },
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
