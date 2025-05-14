import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_transaction_success_screen.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/key_value_tile.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/primary_account_box.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/common/widget/transactipon_pin_screen.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class KuklBillDetailPage extends StatelessWidget {
  final String serviceIdentifier;
  final Map<String, dynamic> accountDetails;
  final String apiEndpoint;
  final Widget body;
  final ServiceList service;
  final String connectionNumber;
  final String customerNumber;
  final String sessionRequestID;
  final String sessionAuthenticationSignature;
  final String counterValue;

  const KuklBillDetailPage({
    super.key,
    required this.body,
    required this.accountDetails,
    required this.apiEndpoint,
    required this.service,
    required this.serviceIdentifier,
    required this.connectionNumber,
    required this.customerNumber,
    required this.sessionRequestID,
    required this.sessionAuthenticationSignature,
    required this.counterValue,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => UtilityPaymentCubit(
            utilityPaymentRepository:
                RepositoryProvider.of<UtilityPaymentRepository>(context),
          ),
      child: KuklBillDetailWidget(
        connectionNumber: connectionNumber,
        counterValue: counterValue,
        customerNumber: customerNumber,
        sessionAuthenticationSignature: sessionAuthenticationSignature,
        sessionRequestID: sessionRequestID,
        body: body,
        service: service,
        apiEndpoint: apiEndpoint,
        accountDetails: accountDetails,
        serviceIdentifier: serviceIdentifier,
      ),
    );
  }
}

class KuklBillDetailWidget extends StatefulWidget {
  final Map<String, dynamic> accountDetails;
  final String apiEndpoint;
  final ServiceList service;
  final Widget body;
  final String connectionNumber;

  final String serviceIdentifier;
  final String customerNumber;
  final String sessionRequestID;
  final String sessionAuthenticationSignature;
  final String counterValue;

  const KuklBillDetailWidget({
    super.key,
    required this.accountDetails,
    required this.apiEndpoint,
    required this.body,
    required this.service,
    required this.serviceIdentifier,
    required this.customerNumber,
    required this.sessionRequestID,
    required this.sessionAuthenticationSignature,
    required this.counterValue,
    required this.connectionNumber,
  });

  @override
  State<KuklBillDetailWidget> createState() => _KuklBillDetailWidgetState();
}

class _KuklBillDetailWidgetState extends State<KuklBillDetailWidget> {
  final _amountController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final _height = SizeUtils.height;
    final _width = SizeUtils.width;

    return PageWrapper(
      showBackButton: true,
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
                  serviceName: widget.service.service,
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
        child: Form(
          key: _formKey,
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
                    Row(
                      children: [
                        Column(
                          children: [
                            Center(
                              child: Image.network(
                                "${RepositoryProvider.of<CoOperative>(context).baseUrl}/ismart/serviceIcon/${widget.service.icon}",
                                height: _height * 0.08,
                              ),
                            ),
                            SizedBox(height: _height * 0.01),
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
                          ],
                        ),
                        SizedBox(width: _width * 0.02),
                        Expanded(
                          child: Text(
                            "Details about the payable amount for the service of ${widget.service.service} is shown below.",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: _height * 0.01),
                    const Divider(thickness: 1),
                    SizedBox(height: _height * 0.02),
                    PrimaryAccountBox(),
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
                          SizedBox(height: _height * 0.01),
                          widget.body,
                          CustomTextField(
                            required: true,
                            title: "Amount",
                            controller: _amountController,
                            textInputType: TextInputType.number,
                            validator:
                                (val) => FormValidator.validateFieldNotEmpty(
                                  val,
                                  "Amount",
                                ),
                          ),
                          KeyValueTile(
                            title: "Cashback",
                            value: "${widget.service.cashBackView ?? 0} %",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: _height * 0.02),
                    CustomRoundedButtom(
                      title: "Pay",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          NavigationService.push(
                            target: TransactionPinScreen(
                              onValueCallback: (p0) {
                                NavigationService.pop();

                                context.read<UtilityPaymentCubit>().makePayment(
                                  mPin: p0,
                                  serviceIdentifier: widget.serviceIdentifier,
                                  // serviceIdentifier: "traffic_fine_payments",
                                  apiEndpoint: widget.apiEndpoint,
                                  accountDetails: widget.accountDetails,
                                  body: {
                                    if (widget.connectionNumber.isNotEmpty)
                                      "customercode": widget.connectionNumber,
                                    if (widget.customerNumber.isNotEmpty)
                                      "customerno": widget.customerNumber,
                                    "type": "kukl Payment",
                                    "counter": widget.counterValue,
                                    "amount": _amountController.text,
                                    "sessionInfo": {
                                      "sessionRequestId":
                                          widget.sessionRequestID,
                                      "sessionAuthenticationSignature":
                                          widget.sessionAuthenticationSignature,
                                    },
                                  },
                                );
                              },
                            ),
                          );
                        }
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
      ),
    );
  }
}
