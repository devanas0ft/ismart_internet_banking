import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/utils/file_download_utils.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/key_value_tile.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/Dahboard/widgets/dashboard_widget.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class MovieTransactionSuccessPage extends StatelessWidget {
  final Widget body;
  final String message;
  final ServiceList? service;
  final String transactionID;
  final String serviceName;

  const MovieTransactionSuccessPage({
    super.key,
    required this.body,
    required this.message,
    this.service,
    required this.transactionID,
    required this.serviceName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => UtilityPaymentCubit(
            utilityPaymentRepository:
                RepositoryProvider.of<UtilityPaymentRepository>(context),
          ),
      child: MovieTransactionSuccessfulWidget(
        body: body,
        transactionID: transactionID,
        message: message,
        service: service,
        serviceName: serviceName,
      ),
    );
  }
}

class MovieTransactionSuccessfulWidget extends StatefulWidget {
  final Widget body;
  final String message;
  final String transactionID;
  final ServiceList? service;
  final String serviceName;

  const MovieTransactionSuccessfulWidget({
    super.key,
    required this.body,
    required this.message,
    required this.service,
    required this.transactionID,
    required this.serviceName,
  });

  @override
  State<MovieTransactionSuccessfulWidget> createState() =>
      _MovieTransactionSuccessfulWidgetState();
}

class _MovieTransactionSuccessfulWidgetState
    extends State<MovieTransactionSuccessfulWidget> {
  String? pdfUrl;
  String? phoneNumber;

  @override
  void initState() {
    super.initState();
    _checkPdfUrl();
  }

  Future<void> _checkPdfUrl() async {
    // Construct the initial PDF URL
    final url = 'https://ismart.devanasoft.com.np/${widget.transactionID}.pdf';

    try {
      // Check if the URL is valid by making an HTTP HEAD request
      final response = await HttpClient().headUrl(Uri.parse(url));
      final res = await response.close();

      if (res.statusCode == 200) {
        // If the response status is 200, the URL is valid
        setState(() {
          pdfUrl = url;
        });
      } else {
        // If not valid, trigger the API call to fetch the ticket URL
        _fetchTicketUrl();
      }
    } catch (e) {
      // Handle any exception (like network errors) and fetch from API
      _fetchTicketUrl();
    }
  }

  Future<void> _fetchTicketUrl() async {
    // API call to get ticket URL
    context.read<UtilityPaymentCubit>().fetchDetails(
      serviceIdentifier: "",
      accountDetails: {"tranId": widget.transactionID},
      apiEndpoint: "/api/movie/ticket/download",
    );
  }

  @override
  Widget build(BuildContext context) {
    final _height = SizeUtils.height;

    return BlocConsumer<UtilityPaymentCubit, CommonState>(
      listener: (context, state) {
        if (state is CommonStateSuccess<UtilityResponseData>) {
          final ticketUrl = state.data.findValueString('ticketUrl');
          setState(() {
            pdfUrl =
                RepositoryProvider.of<CoOperative>(context).baseUrl + ticketUrl;
          });
        }
      },
      builder: (context, state) {
        return PageWrapper(
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
                              widget.service?.service ?? (widget.serviceName),
                        ),
                        widget.body,
                        SizedBox(height: _height * 0.02),
                        CustomRoundedButtom(
                          title: "Done",
                          onPressed: () {
                            NavigationService.pushUntil(
                              target: DashboardWidget(),
                            );
                          },
                        ),
                        SizedBox(height: _height * 0.02),
                        if (pdfUrl != null)
                          CustomRoundedButtom(
                            title: 'Download Receipt',
                            onPressed: () {
                              FileDownloadUtils.downloadFile(
                                downloadLink: pdfUrl!,
                                fileName:
                                    FileDownloadUtils.generateDownloadFileName(
                                      name:
                                          widget.service?.serviceCategoryName ??
                                          'Utility_Payment',
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
      },
    );
  }
}
