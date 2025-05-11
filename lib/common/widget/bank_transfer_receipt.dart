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
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/model/airlines_avliable_list_model.dart';
import 'package:ismart_web/features/history/cubit/receipt_download_cubit.dart';
import 'package:ismart_web/features/history/resources/recent_transaction_repository.dart';

class BankTransferReciptPage extends StatelessWidget {
  final Widget body;
  final String message;
  final ServiceList? service;
  final String transactionID;
  final String? pdfUrl;
  final Flight? departure;
  final Flight? arrival;

  const BankTransferReciptPage({
    super.key,
    required this.body,
    required this.message,
    this.service,
    required this.transactionID,
    this.pdfUrl,
    this.departure,
    this.arrival,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => TransactionDownloadCubit(
            recentTransactionRepository:
                RepositoryProvider.of<RecentTransactionRepository>(context),
          )..generateUrl(transactionId: transactionID),
      child: BankTransferReciptWidget(
        body: body,
        transactionID: transactionID,
        message: message,
        service: service,
      ),
    );
  }
}

class BankTransferReciptWidget extends StatelessWidget {
  final Widget body;
  final String message;
  final String transactionID;

  final ServiceList? service;
  const BankTransferReciptWidget({
    super.key,
    required this.body,
    required this.message,
    required this.service,
    required this.transactionID,
  });

  @override
  Widget build(BuildContext context) {
    final _height = SizeUtils.height;

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
                      message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SizedBox(height: _height * 0.02),
                    const Divider(thickness: 1),
                    SizedBox(height: _height * 0.02),
                    Container(
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
                            "Payment Details",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(height: _height * 0.01),
                          KeyValueTile(
                            title: "Transaction ID",
                            value: transactionID,
                          ),
                          body,
                        ],
                      ),
                    ),
                    SizedBox(height: _height * 0.02),
                    CustomRoundedButtom(
                      title: "Done",
                      onPressed: () {
                        NavigationService.pushReplacement(
                          target: DashboardWidget(),
                        );

                        // NavigationService.pushReplacement(
                        //     target: const DashboardPage());
                      },
                    ),
                    SizedBox(height: _height * 0.02),
                    BlocConsumer<TransactionDownloadCubit, CommonState>(
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
                                          service?.serviceCategoryName ??
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
