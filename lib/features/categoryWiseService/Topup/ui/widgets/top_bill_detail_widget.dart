import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/key_value_tile.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/common/widget/transactipon_pin_screen.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/Topup/ui/widgets/topup_transaction_receipt_screen.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class TopUpBillDetailPage extends StatelessWidget {
  final String serviceIdentifier;
  final Map<String, dynamic> accountDetails;
  final Map<String, dynamic> apiBody;
  final String apiEndpoint;
  final Widget body;
  final CategoryList categoryList;

  const TopUpBillDetailPage({
    super.key,
    required this.body,
    required this.accountDetails,
    required this.apiEndpoint,
    required this.apiBody,
    required this.categoryList,
    required this.serviceIdentifier,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => UtilityPaymentCubit(
            utilityPaymentRepository:
                RepositoryProvider.of<UtilityPaymentRepository>(context),
          ),
      child: TopupBillDetailWidget(
        body: body,
        categoryList: categoryList,
        apiBody: apiBody,
        apiEndpoint: apiEndpoint,
        accountDetails: accountDetails,
        serviceIdentifier: serviceIdentifier,
      ),
    );
  }
}

// ignore: must_be_immutable
class TopupBillDetailWidget extends StatelessWidget {
  final Map<String, dynamic> accountDetails;
  final Map<String, dynamic> apiBody;
  final String apiEndpoint;
  final CategoryList categoryList;
  final Widget body;
  final String serviceIdentifier;

  TopupBillDetailWidget({
    super.key,
    required this.accountDetails,
    required this.apiEndpoint,
    required this.body,
    required this.apiBody,
    required this.categoryList,
    required this.serviceIdentifier,
  });
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final selectedService =
        categoryList.services
            .where(
              (element) => element.uniqueIdentifier.contains(serviceIdentifier),
            )
            .toList();
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
              message:
                  state.message.contains("Internal Server Error")
                      ? "Service is Currently unavailable"
                      : state.message,
              title: "Failure",
              showCancelButton: false,
              buttonCallback: () {
                NavigationService.pop();
              },
            );
          }

          if (state is CommonStateSuccess<UtilityResponseData>) {
            final UtilityResponseData _response = state.data;
            if (_response.status == "M0000") {
              NavigationService.pushReplacement(
                target: TopUpTransactionReceiptPage(
                  transactionID: state.data.transactionIdentifier,
                  body: body,
                  message: state.data.message,
                  service: selectedService[0],
                ),
              );
            } else {
              showPopUpDialog(
                context: context,
                message: _response.message,
                title: "Error",
                showCancelButton: false,
                buttonCallback: () {
                  NavigationService.pop();
                },
              );
            }
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                NavigationService.pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
            Container(
              decoration: BoxDecoration(
                color: CustomTheme.white,
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.network(
                    "${RepositoryProvider.of<CoOperative>(context).baseUrl}/ismart/serviceIcon/${selectedService[0].icon}",
                    height: _height * 0.08,
                  ),
                  SizedBox(height: _height * 0.02),
                  Text(
                    selectedService[0].service,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: _height * 0.02),
                  Text(
                    "Details about the payable amount for the service of ${selectedService[0].service} is shown below.",
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
                        body,
                        KeyValueTile(
                          title: "Cashback",
                          value: "${selectedService[0].cashBackView ?? "0"} %",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: _height * 0.02),
                  CustomRoundedButtom(
                    title: "Pay",
                    onPressed: () {
                      NavigationService.push(
                        target: TransactionPinScreen(
                          onValueCallback: (p0) {
                            NavigationService.pop();

                            context.read<UtilityPaymentCubit>().makePayment(
                              mPin: p0,
                              serviceIdentifier: serviceIdentifier,
                              // serviceIdentifier: "traffic_fine_payments",
                              apiEndpoint: apiEndpoint,
                              body: apiBody,
                              accountDetails: accountDetails,
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
