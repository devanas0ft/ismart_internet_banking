import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_transaction_success_screen.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/key_value_tile.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/common/widget/transactipon_pin_screen.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class CommonBillDetailPage extends StatelessWidget {
  final String serviceIdentifier;
  final Map<String, dynamic> accountDetails;
  final Map<String, dynamic> apiBody;
  final String apiEndpoint;
  final Widget body;
  final ServiceList service;
  final String serviceName;
  final String? verificationAmount;

  const CommonBillDetailPage({
    super.key,
    required this.body,
    required this.accountDetails,
    required this.apiEndpoint,
    required this.apiBody,
    required this.service,
    required this.serviceIdentifier,
    this.verificationAmount,
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
      child: CommonBillDetailWidget(
        verificationAmount: verificationAmount,
        body: body,
        service: service,
        apiBody: apiBody,
        apiEndpoint: apiEndpoint,
        accountDetails: accountDetails,
        serviceIdentifier: serviceIdentifier,
        serviceName: serviceName,
      ),
    );
  }
}

class CommonBillDetailWidget extends StatefulWidget {
  final Map<String, dynamic> accountDetails;
  final Map<String, dynamic> apiBody;
  final String apiEndpoint;
  final ServiceList service;
  final Widget body;
  final String serviceIdentifier;
  final String serviceName;
  final String? verificationAmount;

  const CommonBillDetailWidget({
    super.key,
    required this.accountDetails,
    required this.apiEndpoint,
    required this.body,
    required this.apiBody,
    required this.service,
    this.verificationAmount,
    required this.serviceIdentifier,
    required this.serviceName,
  });

  @override
  State<CommonBillDetailWidget> createState() => _CommonBillDetailWidgetState();
}

class _CommonBillDetailWidgetState extends State<CommonBillDetailWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final _height = SizeUtils.height;

    return PageWrapper(
      body: BlocListener<UtilityPaymentCubit, CommonState>(
        listener: (context, state) {
          if (state is CommonLoading && _isLoading == false) {
            _isLoading = true;
            showLoadingDialogBox(context);
          }
          if (state is! CommonLoading && _isLoading) {
            NavigationService.pop();
            _isLoading = false;
          }

          if (state is CommonError) {
            showPopUpDialog(
              context: context,
              message: state.message,
              title: "Error",
              showCancelButton: false,
              buttonCallback: () {
                NavigationService.pop();
              },
            );
          }

          if (state is CommonStateSuccess<UtilityResponseData>) {
            final UtilityResponseData _response = state.data;
            if (_response.code == "M0000" ||
                _response.status.toLowerCase() == "Success" ||
                _response.message.toLowerCase().contains(
                  "success".toLowerCase(),
                )) {
              NavigationService.pushReplacement(
                target: CommonTransactionSuccessPage(
                  serviceName: widget.serviceName,

                  ///test
                  pdfUrl: state.data.findValue(primaryKey: "airlinesPdfUrl"),
                  transactionID: state.data.transactionIdentifier,
                  body: widget.body,
                  message: state.data.message,
                  service: widget.service,
                ),
              );
            } else {
              showPopUpDialog(
                context: context,
                message: _response.message,
                title: _response.status,
                showCancelButton: false,
                buttonCallback: () {
                  NavigationService.pop();
                },
              );
            }
          }
        },
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                color: CustomTheme.white,
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      NavigationService.pop();
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Center(
                    child: Image.network(
                      "${RepositoryProvider.of<CoOperative>(context).baseUrl}/ismart/serviceIcon/${widget.service.icon}",
                      height: _height * 0.08,
                    ),
                  ),
                  SizedBox(height: _height * 0.02),
                  Center(
                    child:
                        widget.service.service.isEmpty
                            ? Container()
                            : Text(
                              widget.service.service,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                  ),
                  SizedBox(height: _height * 0.02),
                  Text(
                    "Details about the payable amount for the service of ${widget.service.service} is shown below.",
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Paymet Details",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: _height * 0.02),
                        KeyValueTile(
                          title: "From Account",
                          value:
                              RepositoryProvider.of<CustomerDetailRepository>(
                                context,
                              ).selectedAccount.value!.mainCode,
                        ),
                        SizedBox(height: 5.hp),
                        widget.body,
                        KeyValueTile(
                          title: "Cashback",
                          value: "${widget.service.cashBackView ?? 0} %",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: _height * 0.02),
                  CustomRoundedButtom(
                    verificationAmount: widget.verificationAmount,
                    title: "Pay",
                    onPressed: () {
                      NavigationService.push(
                        target: TransactionPinScreen(
                          onValueCallback: (p0) {
                            NavigationService.pop();

                            context.read<UtilityPaymentCubit>().makePayment(
                              mPin: p0,
                              serviceIdentifier: widget.serviceIdentifier,
                              // serviceIdentifier: "traffic_fine_payments",
                              apiEndpoint: widget.apiEndpoint,
                              body: widget.apiBody,
                              accountDetails: widget.accountDetails,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(18),
                  //       border:
                  //           Border.all(color: Theme.of(context).primaryColor)),
                  //   child: CustomRoundedButtom(
                  //       textColor: Theme.of(context).primaryColor,
                  //       title: "Download Receipt",
                  //       color: Colors.transparent,
                  //       onPressed: () {}),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
