import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/utils/amount_utils.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/key_value_tile.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/internet/cg/screens/cg_payement_inquiry_screen.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class CgPaymentDeatilWidget extends StatefulWidget {
  final ServiceList service;
  final UtilityResponseData detailFetchData;

  const CgPaymentDeatilWidget({
    super.key,
    required this.detailFetchData,
    required this.service,
  });
  @override
  State<CgPaymentDeatilWidget> createState() => _CgPaymentDeatilWidgetState();
}

class _CgPaymentDeatilWidgetState extends State<CgPaymentDeatilWidget> {
  final TextEditingController _amountController = TextEditingController();
  bool _isLoading = false;
  double _dueAmount = 0;

  @override
  void initState() {
    super.initState();
    print("Hello this is my print: ${widget.detailFetchData}");

    _dueAmount =
        double.tryParse(
          widget.detailFetchData
                  .findValue(primaryKey: "dueAmount")
                  ?.toString() ??
              "0",
        ) ??
        0;

    _amountController.text =
        ((double.tryParse(
                      widget.detailFetchData.findValueString(
                        "amount",
                        emptyString: "",
                      ),
                    ) ??
                    0) +
                _dueAmount)
            .toString();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final _height = SizeUtils.height;

    final amount =
        widget.detailFetchData.findValue(primaryKey: "dueAmount").toString();

    return PageWrapper(
      body: CommonContainer(
        verificationAmount: amount,
        showDetail: true,
        topbarName: 'Payment',
        title: 'Customer Detail',
        buttonName: 'Proceed',
        detail:
            'Proceed to the Next page for the package selection and Payment',
        showAccountSelection: true,
        body: BlocListener<UtilityPaymentCubit, CommonState>(
          listener: (context, state) {
            if (state is CommonLoading && _isLoading == false) {
              _isLoading = true;
              showLoadingDialogBox(context);
            } else if (state is! CommonLoading && _isLoading) {
              _isLoading = false;
              NavigationService.pop();
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

              if (_response.code == "M0000") {
                NavigationService.push(
                  target: CgPaymentInquiryScreen(
                    service: widget.service,
                    detailFetchData: _response,
                    userId:
                        widget.detailFetchData
                            .findValue(primaryKey: "userId")
                            .toString(),
                  ),
                );
              } else {
                showPopUpDialog(
                  context: context,
                  message: _response.message,
                  title: "Error",
                  buttonCallback: () {
                    NavigationService.pop();
                  },
                  showCancelButton: false,
                );
              }
            }
          },
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Details", style: _textTheme.headlineSmall),
                  SizedBox(height: _height * 0.01),
                  KeyValueTile(
                    title: "Customer Name",
                    value:
                        widget.detailFetchData
                            .findValue(primaryKey: "name")
                            .toString(),
                  ),
                  SizedBox(height: _height * 0.008),
                  KeyValueTile(
                    title: "Customer ID",
                    value:
                        widget.detailFetchData
                            .findValue(primaryKey: "userId")
                            .toString(),
                  ),
                  SizedBox(height: _height * 0.008),
                  KeyValueTile(
                    title: "Subscribed Package",
                    value:
                        widget.detailFetchData
                            .findValue(primaryKey: "currentPlanName")
                            .toString(),
                  ),
                  SizedBox(height: _height * 0.008),
                  KeyValueTile(
                    title: "Address",
                    value:
                        widget.detailFetchData
                            .findValue(primaryKey: "address")
                            .toString(),
                  ),
                  SizedBox(height: _height * 0.008),
                  KeyValueTile(
                    title: "City",
                    value:
                        widget.detailFetchData
                            .findValue(primaryKey: "city")
                            .toString(),
                  ),
                  SizedBox(height: _height * 0.008),
                  KeyValueTile(
                    title: "Nation",
                    value:
                        widget.detailFetchData
                            .findValue(primaryKey: "nation")
                            .toString(),
                  ),
                  SizedBox(height: _height * 0.008),
                  KeyValueTile(
                    title: "State",
                    value:
                        widget.detailFetchData
                            .findValue(primaryKey: "state")
                            .toString(),
                  ),
                  SizedBox(height: _height * 0.008),
                  KeyValueTile(
                    title: "Type",
                    value:
                        widget.detailFetchData
                            .findValue(primaryKey: "type")
                            .toString(),
                  ),
                  SizedBox(height: _height * 0.008),
                  KeyValueTile(
                    title: "Expiry Date",
                    value: formatExpiryDate(
                      widget.detailFetchData.findValue(
                        primaryKey: "expiryDate",
                      ),
                    ),
                  ),
                  KeyValueTile(
                    title: "Amount",
                    value:
                        AmountUtils.getAmountInRupees(
                          amount: amount,
                        ).toString(),
                  ),
                  SizedBox(height: _height * 0.008),
                  SizedBox(height: _height * 0.01),
                ],
              ),
            ],
          ),
        ),
        onButtonPressed: () {
          onButtonPressed(
            username:
                widget.detailFetchData
                    .findValue(primaryKey: "userId")
                    .toString(),
          );
        },
      ),
    );
  }

  String formatExpiryDate(String expiryDate) {
    final timestamp = int.tryParse(
      expiryDate.replaceAll(RegExp(r'[^0-9]'), ''),
    );

    if (timestamp != null) {
      final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final formatter = DateFormat('yyyy-MM-dd');
      return formatter.format(dateTime);
    }

    return 'Invalid date';
  }

  void onButtonPressed({required String username}) {
    context.read<UtilityPaymentCubit>().fetchDetails(
      serviceIdentifier: widget.service.uniqueIdentifier,
      accountDetails: {"userId": username},
      apiEndpoint: "api/cg_net/bill_inquiry",
    );
  }
}
